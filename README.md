# dotfiles

## how to use it

First, move the current directory to `home` or `root`.

### stow a single package
```
stow -t target-dir package
```

### stow all packages
```
stow -t target-dir *
```

### unstow a single package
```
stow -D -t target-dir package
```

### unstow all packages
```
stow -D -t target-dir *
```

### adopt a configuration from local machine
```
stow --adopt -t target-dir package
```
> This does not work!! Just copy the file to stow dir and delete it from the original place

### simulation mode
```
stow -nt -D -t target-dir *
```

## nixos

The `nixos` package (under `root`) tracks the system config at
`/etc/nixos/configuration.nix`. Stow it with:
```
cd root && sudo stow -t / nixos
```
This symlinks `/etc/nixos/configuration.nix` into this repo. Only
`configuration.nix` is tracked — `hardware-configuration.nix` is machine-specific
and intentionally left as a local, untracked file.

Boot does not depend on the symlink: `nixos-rebuild switch` compiles the config
into `/nix/store` and the bootloader points at that generation. The symlink only
matters at rebuild time. To recover, use `sudo nixos-rebuild switch --rollback`
or restore from a `configuration.nix.bak.*` backup.
