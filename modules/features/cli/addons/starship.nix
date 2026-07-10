args@{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.matrix;
let
  toml = pkgs.formats.toml { };
  starshipBase = toml.generate "starship-base.toml" {
    add_newline = false;
    character = {
      success_symbol = "[ ](bold fg:243)";
      error_symbol = "[ ](bold fg:244)";
    };
    package = {
      disabled = true;
    };
    format = ''
      $cmd_duration $directory$git_branch
        $character
    '';
    cmd_duration = {
      min_time = 0;
      format = "[](bold fg:252)[󰪢 $duration](bold bg:252 fg:235)[](bold fg:252)";
    };
    git_branch = {
      style = "bg:252";
      symbol = "󰘬";
      truncation_length = 12;
      truncation_symbol = "";
      format = " 󰜥 [](bold fg:252)[$symbol $branch(:$remote_branch)](fg:235 bg:252)[ ](bold fg:252)";
    };
    git_commit = {
      commit_hash_length = 4;
      tag_symbol = " ";
    };
    git_state = {
      format = "[\($state( $progress_current of $progress_total)\)]($style) ";
      cherry_pick = "[🍒 PICKING](bold red)";
    };
    git_status = {
      conflicted = " 🏳 ";
      ahead = " 🏎💨 ";
      behind = " 😰 ";
      diverged = " 😵 ";
      untracked = " 🤷 ‍";
      stashed = " 📦 ";
      modified = " 📝 ";
      staged = "[++\($count\)](green)";
      renamed = " ✍️ ";
      deleted = " 🗑 ";
    };
    hostname = {
      ssh_only = false;
      format = "[•$hostname](bg:252 bold fg:235)[](bold fg:252)";
      trim_at = ".objectfab.de";
      disabled = false;
    };

    line_break = {
      disabled = false;
    };
    memory_usage = {
      disabled = true;
      threshold = -1;
      symbol = " ";
      style = "bold dimmed green";
    };
    time = {
      disabled = true;
      format = "🕙[\[ $time \]]($style) ";
      time_format = "%T";
    };
    username = {
      style_user = "bold bg:252 fg:235";
      style_root = "red bold";
      format = "[](bold fg:252)[$user]($style)";
      disabled = false;
      show_always = true;
    };
    directory = {
      home_symbol = " ";
      read_only = "  ";
      style = "bg:255 fg:240";
      truncation_length = 2;
      truncation_symbol = ".../";
      format = "[](bold fg:255)[󰉋 → $path]($style)[](bold fg:255)";
      substitutions = {
        "Desktop" = "  ";
        "Documents" = "  ";
        "Downloads" = "  ";
        "Music" = " 󰎈 ";
        "Pictures" = "  ";
        "Videos" = "  ";
        "GitHub" = " 󰊤 ";
      };
    };
  };
  composeStarship = pkgs.writeShellScript "compose-starship-config" ''
        set -eu
        base="${starshipBase}"
        palette="$HOME/.cache/noctalia/starship-palette.toml"
        out="$HOME/.config/starship/generated.toml"
        tmp="$out.tmp"

        mkdir -p "$(dirname "$out")"
        {
            cat "$base"
            printf '\n\n'
            if [ -f "$palette" ]; then
                cat "$palette"
            else
              cat <<'EOF'
    [palettes.noctalia]
    blue = "#89b4fa"
    green = "#a6e3a1"
    red = "#f38ba8"
    yellow = "#f9e2af"
    mauve = "#cba6f7"
    EOF
            fi
        } > "$tmp"
        mv "$tmp" "$out"
  '';
in
mkFeature args {
  name = "cli.addons.starship";

  options = {
  };

  home = { cfg, ... }: {

    programs.starship = {
      enable = true;
      enableBashIntegration = config.matrix.cli.defaultShell == "bash";
      enableFishIntegration = config.matrix.cli.defaultShell == "fish";
      enableZshIntegration = config.matrix.cli.defaultShell == "zsh";
      enableNushellIntegration = config.matrix.cli.defaultShell == "nushell";
      enableIonIntegration = config.matrix.cli.defaultShell == "ion";
      enableTransience = true;
      configPath = "${config.matrix.user.homeDirectory}/.config/starship/generated.toml";
      # configPath = "${config.xdg.configHome}/starship/generated.toml";
      settings = {
      };
    };
    home.activation.composeStarshipConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${composeStarship}
    '';

    programs.fish.interactiveShellInit = lib.mkBefore ''
      ${composeStarship}
    '';
    home.packages = [
      pkgs.starship
    ];
  };
}
