{ pkgs }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    uv
  ];
  shellHook = ''
    echo ""
    echo "=============================="
    echo "= Python Develop Environment ="
    echo "=============================="
    echo ""
  '';
}
