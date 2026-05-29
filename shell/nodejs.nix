{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    nodejs_24
  ];
  shellHook = ''
    export PATH="$PWD/node_modules/.bin:$PATH"
    echo "==============================="
    echo "= Node.js Develop Environment ="
    echo "==============================="
    echo ""
    echo "Node Version: $(node --version)"
    echo "NPM Version: $(npm --version)"
  '';
}
