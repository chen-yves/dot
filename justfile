# Default parameters
dot_dir := justfile_directory()

# List all commands
default:
    @just --list

# Rebuild nix on darwin
rb_mac name:
    sudo darwin-rebuild switch --flake {{dot_dir}}#{{name}}

# Clean old generation for releasing disk volume
gc:
    sudo nix-collect-garbage -d
