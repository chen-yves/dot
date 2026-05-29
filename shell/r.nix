{ pkgs }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    R
    rstudio
    rPackages.languageserver
    rPackages.ggplot2
    rPackages.dplyr
    rPackages.tidyverse
  ];
  shellHook = ''
    echo ""
    echo "========================="
    echo "= R Develop Environment ="
    echo "========================="
    echo ""
    echo "You can use 'rstudio >/dev/null 2>&1 &' to launch RStudio."
  '';
}
