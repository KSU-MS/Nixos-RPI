{ pkgs, ... }:
{
  # Keep git installed for all users
  environment.systemPackages = with pkgs; [ git ];

  # Optional: enable Git module and set a couple of defaults
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      # Store credentials in ~/.git-credentials (you can change this later)
      credential.helper = "store";
    };
  };
}
