# Nix Based and Install Scripts Based Configuration

## Install Based

### macOS/Linux/BSD

```sh
sh install.sh
```

### Windows

```pwsh
.\install.ps1
```

## Nix Based

### Darwin

```sh
# Install nix on darwin device
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)

# Install nix-darwin under nix-darwin
sudo nix run nix-darwin/master#darwin-rebuild -- switch {{dot_dir}}#{{name}}

# First build
sudo darwin-rebuild switch --flake {{dot_dir}}#{{name}}

# Rebuild command with just
cd {{dot_dir}}
just rb_mac {{name}}
```