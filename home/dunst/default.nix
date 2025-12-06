{
  stylix.targets.dunst.enable = true;

  services.dunst = {
    enable = true;

    settings = {
      global = {
        width = "(200, 300)";
        height = "(0, 150)";
        offset = "(30, 50)";
        origin = "top-right";
        follow = "mouse";
      };
    };
  };
}
