{ config, options, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    ignores = [
      "*~"
    ];

    includes = [
      { path = "~/.config/git/config_default_settings"; }
      { path = "~/.config/git/config_private"; }
    ];
    lfs.enable = true;

    #signing = "7239FA16084C3CAD";

    settings.user = {
      name = lib.mkDefault "dgengtek";
      email = lib.mkDefault "dgengtek@users.noreply.github.com";
    };

    iniContent = {
      commit = {
        template = "${../git/.config/git/gitmessage}";
      };
      core = {
        editor = "vim";
        whitespace = "trailing-space,space-before-tab";
        askpass = "";
        excludesFile = "${../git/.config/git/ignore}";
      };
      merge = {
        tool = "nvimdiff";
        conflictstyle = "diff3";
        stat = true;
      };
      "merge \"ours\"" = {
        driver = true;
      };
      push = {
        default = "simple";
      };
      pull = {
        rebase = true;
      };
      color = {
        ui = "auto";
      };
      alias = {
        s = "status";
        d = "diff";
        dc = "diff --cached";
        l = "pull";
        p = "push";
        co = "checkout";
        r = "remote";
        cm = "checkout master";
        b = "branch";
        a = "add";
        m = "merge";
        st = "stash";
      };
      branch = {
        autosetupmerge = true;
      };
      pager = {
        diff = "delta";
        log = "delta";
        reflog = "delta";
        show = "delta";
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      delta = {
        features = "side-by-side line-numbers decorations";
        "whitespace-error-style" = "22 reverse";
      };
      "delta \"decorations\"" = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow ul";
        file-decoration-style = "none";
      };
      pack = {
        windowMemory = "100m";
        sizeLimit = "100m";
        threads = 1;
        window = 0;
      };
    };
  };
}
