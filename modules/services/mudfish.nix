# Import this module and pass mudfishLegacy = inputs.nixpkgs-mudfish
# through nixosSystem.specialArgs. See the setup instructions in the reply.
{ config, lib, pkgs, mudfishLegacy, ... }:

let
  cfg = config.cfg.services.mudfish;
  version = "6.5.5";
  installDir = "/opt/mudfish/${version}";

  # This is deliberately separate from the system's nixpkgs/config.
  # ISC dhclient is EOL, but is required by the tested Mudfish setup.
  legacyPkgs = import mudfishLegacy {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      permittedInsecurePackages = [ "dhcp-4.4.3-P1" ];
    };
  };

  dhclient = legacyPkgs.dhcp.override { withClient = true; };

  payload = pkgs.stdenvNoCC.mkDerivation {
    pname = "mudfish-payload";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://mudfish.net/releases/mudfish-${version}-linux-x86_64.sh";
      hash = "sha256-9b8x40v/tiCzAaHycnA4IjdchEQ5ZlitFtbHfTAPAyQ=";
    };

    nativeBuildInputs = [ pkgs.gnutar pkgs.bzip2 ];
    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    # Verified against the hash-pinned 6.5.5 Makeself installer:
    # 760 header lines followed by a bzip2-compressed tar archive.
    # Extract only; never run its host-modifying installation script.
    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      tail -n +761 "$src" | tar -xj --no-same-owner -C "$out"
      rm "$out/bin/pkg_linux_setup.sh"
      test -x "$out/bin/mudrun-headless"
      test -f "$out/etc/htdocs-www-${version}.tar"
      runHook postInstall
    '';

    meta = {
      description = "Mudfish Cloud VPN proprietary Linux binaries";
      homepage = "https://mudfish.net/";
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  };

  dhcpHook = pkgs.writeText "mudfish-dhclient-enter-hooks" ''
    # Scope the fix to the interface used in the tested setup.
    if [ "$interface" = "tap0" ]; then
      unset new_routers old_routers
      make_resolv_conf() { :; }
    fi
  '';

  launcher = pkgs.writeShellScript "mudfish-launch" ''
    cd /var/lib/mudfish
    exec ${installDir}/bin/mudrun-headless -B -a 127.0.0.1 -P 8282
  '';

  environment = pkgs.buildFHSEnv {
    name = "mudfish-fhs";

    targetPkgs = p: [
      p.bashInteractive p.coreutils p.gnugrep p.gnused p.gawk
      p.findutils p.gnutar p.gzip p.which
      p.iproute2 p.net-tools dhclient p.iputils p.procps p.util-linux
      p.cacert p.curl p.openssl p.zlib p.stdenv.cc.cc.lib
    ];

    unshareUser = false;
    unshareNet = false;
    extraBwrapArgs = [
      "--cap-add CAP_NET_ADMIN"
      "--cap-add CAP_NET_RAW"
    ];

    # Supply the vendor's hardcoded paths inside the FHS mount namespace.
    # Executables/resources are immutable; state remains writable/persistent.
    extraBuildCommands = ''
      mkdir -p "$out${installDir}" "$out/etc"
      for directory in bin etc sbin share; do
        ln -s "${payload}/$directory" "$out${installDir}/$directory"
      done
      ln -s /var/lib/mudfish "$out${installDir}/var"
      cp ${dhcpHook} "$out/etc/dhclient-enter-hooks"
    '';

    runScript = launcher;
  };
in
{
  options.cfg.services.mudfish = {
    enable = lib.mkEnableOption "Mudfish Cloud VPN";
    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Start the Mudfish launcher at boot. VPN connection behavior is configured in its web UI.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
      message = "This Mudfish package supports x86_64-linux only.";
    }];

    boot.kernelModules = [ "tun" ];

    systemd.services.mudfish = {
      description = "Mudfish Cloud VPN";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = lib.optionals cfg.autoStart [ "multi-user.target" ];

      environment = {
        HOME = "/var/lib/mudfish";
        SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      };

      serviceConfig = {
        Type = "simple";
        User = "root";
        StateDirectory = "mudfish";
        StateDirectoryMode = "0700";
        WorkingDirectory = "/var/lib/mudfish";
        UMask = "0077";
        ExecStart = "${environment}/bin/mudfish-fhs";
        KillSignal = "SIGINT";
        KillMode = "control-group";
        TimeoutStopSec = 30;
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
