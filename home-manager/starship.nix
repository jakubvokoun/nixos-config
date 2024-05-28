{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$package"
        "$python"
        "$golang"
        "$nix_shell"
        "$line_break"
        "$jobs"
        "$character"
      ];
    };
  };
}
