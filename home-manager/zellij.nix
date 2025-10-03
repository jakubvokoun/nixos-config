{ inputs, lib, config, pkgs, ... }: {
  programs.zellij = {
    enable = true;
    settings = {
      simplefied_ui = true;
      pane_frames = false;
      copy_on_select = true;
      mouse_mode = true;
      show_startup_tips = false;
      show_release_notes = false;
      theme = "catppuccin-mocha";
    };
  };
}
