{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    cmake
    gnumake
    ninja
    pkg-config
    clang-tools
    (if stdenv.isDarwin then lldb else gdb)
  ];
  shellHook = ''
    echo ""
    echo "============================="
    echo "= C/C++ Develop Environment ="
    echo "============================="
    echo ""
  '';
}
