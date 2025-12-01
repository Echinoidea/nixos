{
  stylix.targets.dunst.enable = true;

  programs.dunst = {
    enable = true;

    settings = {
      width = "(200, 300)";
      height = "(0, 150)";
      offset = "(30, 50)";
      origin = "top-right";
    };
  };
}
