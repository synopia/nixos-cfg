{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.syncon;
let
  cfg = config.syncon.browsers.firefox;
in
{
  options.syncon.browsers.firefox = with types; {
    enable = mkBoolOpt false "Whether to enable firefox browser.";
    extensions = mkOption {
      type = nullOr (listOf package);
      description = ''
        Extensions to install
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ pywalfox-native ];
    nixpkgs.config.firefox-unwrapped.enablePlasmaBrowserIntegration = true;

    syncon.home.extraOptions.programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          CaptivePortal = false;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          OfferToSaveLoginsDefault = false;
          PasswordManagerEnabled = true;
          Preferences = {

          };
          FirefoxHome = {
            Search = true;
            Pocket = false;
            Snippets = false;
            TopSites = false;
            Highlights = false;
          };
          UserMessaging = {
            ExtensionRecommendations = false;
            SkipOnboarding = true;
          };
        };
      };
      profiles = {
        synopia = {
          extensions.packages =
            with pkgs.nur.repos.rycee.firefox-addons;
            [
              ublock-origin
              plasma-integration
              darkreader
              pywalfox
              sponsorblock
            ]
            ++ cfg.extensions;
          id = 0;
          name = "synopia";

          search = {
            force = true;
            default = "google";
            order = [
              "google"
              "ddg"
            ];
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliased = [ "@np" ];
              };

            };
          };
          settings = {
            "general.smoothScroll" = true;
            "browser.sessionstore.resume_session" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "layout.css.has-selector.enabled" = true;
            "userChrome.TabSeparatorsLowSaturation-Enabled" = true;
            "userChrome.Tabs.Option4.Enabled" = true;
            "userChrome.FilledMenuIcons-Enabled" = true;
          };
        };
      };
    };
  };
}
