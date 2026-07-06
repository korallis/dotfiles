{ config, pkgs, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = "leebarry";
  home.homeDirectory = "/Users/leebarry";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    neovim
    nodejs_24 # runtime for firstmate AXI CLIs (gh-axi, chrome-devtools-axi, lavish-axi)
    gh        # GitHub CLI; gh-axi wraps it and firstmate's bootstrap requires it
    tmux      # firstmate's reference backend; required by its e2e test suite (.no-mistakes.yaml test step)
    # the font everything renders in
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables.EDITOR = "nvim";
  # Cursor's official installer drops cursor-agent here; keep it on PATH.
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Install cursor-agent from Cursor's official script rather than Homebrew.
  # The Homebrew cask ships an unsigned binary that fails to load; the official
  # installer places a signed, self-updating binary in ~/.local/bin. We only run
  # it when the binary is missing - once installed, cursor-agent updates itself.
  home.activation.cursorAgent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -x "$HOME/.local/bin/cursor-agent" ]; then
      verboseEcho "Installing cursor-agent from cursor.com/install"
      run ${pkgs.curl}/bin/curl -fsS https://cursor.com/install \
        | run ${pkgs.bash}/bin/bash
    fi
  '';

  # Wire each AI CLI into herdr. `herdr integration install` drops a per-agent
  # hook script (herdr owns and overwrites it on update) and registers it in the
  # agent's own config, so a fresh machine ends up fully wired and existing
  # installs get bumped to the current integration version on every switch. It's
  # idempotent. Guarded on the herdr binary (a Homebrew cask) so the switch still
  # succeeds if Homebrew hasn't installed it yet; runs after cursorAgent so
  # cursor-agent exists first.
  home.activation.herdrIntegrations = lib.hm.dag.entryAfter [ "cursorAgent" ] ''
    if [ -x /opt/homebrew/bin/herdr ]; then
      for agent in claude codex cursor; do
        verboseEcho "herdr: installing $agent integration"
        run /opt/homebrew/bin/herdr integration install "$agent" || true
      done
    fi
  '';

  # firstmate's toolchain that isn't in nixpkgs, made fully reproducible so a
  # fresh Mac ends up with everything firstmate needs. treehouse and no-mistakes
  # are self-updating binaries installed from their vendors' scripts (same idiom
  # as cursorAgent above); the AXI CLIs and tasks-axi are npm packages installed
  # against the nix node. Everything lands in ~/.local/bin, which is on
  # sessionPath. npm installs are guarded on the binary so a normal switch skips
  # them, while the AXI hook registration re-runs every switch (idempotent, like
  # herdrIntegrations) so agent hooks stay wired. Installs tolerate a network
  # hiccup so a flaky download never aborts the whole switch - the missing tool
  # is simply retried on the next rebuild.
  home.activation.firstmateTools = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.nodejs_24}/bin:$HOME/.local/bin:$PATH"
    run mkdir -p "$HOME/.local/bin"

    if [ ! -x "$HOME/.local/bin/treehouse" ]; then
      verboseEcho "firstmate: installing treehouse"
      run ${pkgs.curl}/bin/curl -fsSL https://kunchenguid.github.io/treehouse/install.sh \
        | run ${pkgs.bash}/bin/bash \
        || echo "rebuild: treehouse install failed (will retry next switch)" >&2
    fi

    if [ ! -x "$HOME/.local/bin/no-mistakes" ]; then
      verboseEcho "firstmate: installing no-mistakes"
      export NO_MISTAKES_LINK_DIR="$HOME/.local/bin"
      run ${pkgs.curl}/bin/curl -fsSL \
        https://raw.githubusercontent.com/kunchenguid/no-mistakes/main/docs/install.sh \
        | run ${pkgs.bash}/bin/bash \
        || echo "rebuild: no-mistakes install failed (will retry next switch)" >&2
    fi

    # firstmate AXI CLIs: install when missing, then always (re)register the
    # per-agent session hooks that firstmate's `<tool> setup hooks` step wires.
    for axi in gh-axi chrome-devtools-axi lavish-axi; do
      if [ ! -x "$HOME/.local/bin/$axi" ]; then
        verboseEcho "firstmate: installing $axi"
        run ${pkgs.nodejs_24}/bin/npm install -g --prefix "$HOME/.local" "$axi" \
          || echo "rebuild: $axi install failed (will retry next switch)" >&2
      fi
      if [ -x "$HOME/.local/bin/$axi" ]; then
        verboseEcho "firstmate: registering $axi hooks"
        run "$HOME/.local/bin/$axi" setup hooks || true
      fi
    done

    # tasks-axi: firstmate's backlog backend (npm CLI, no hooks to register).
    if [ ! -x "$HOME/.local/bin/tasks-axi" ]; then
      verboseEcho "firstmate: installing tasks-axi"
      run ${pkgs.nodejs_24}/bin/npm install -g --prefix "$HOME/.local" tasks-axi \
        || echo "rebuild: tasks-axi install failed (will retry next switch)" >&2
    fi
  '';

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept

      # Keep ~/.local/bin on PATH. home.sessionPath adds it via hm-session-vars.sh,
      # but that file guards on an exported __HM_SESS_VARS_SOURCED and returns early
      # for child shells, while macOS path_helper (run from the login sequence after
      # ~/.zshenv) rebuilds PATH and drops the entry. .zshrc runs after both and does
      # not depend on the guard, so re-prepend here to guarantee firstmate's tools
      # (treehouse, no-mistakes, tasks-axi, the AXI CLIs) in ~/.local/bin are found.
      typeset -U path PATH
      export PATH="$HOME/.local/bin:$PATH"
    '';
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude --dangerously-skip-permissions";
      co = "codex --yolo --search";
      csr = "cursor-agent --yolo";
    };
  };

  programs.git.settings.user = {
    name = "korallis";
    email = "lee.barry84@gmail.com";
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
