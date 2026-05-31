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
