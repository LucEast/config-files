# Setup steps for neovim

- [Setup steps for neovim](#setup-steps-for-neovim)
  - [Install neovim](#install-neovim)
  - [Install Vim Plug](#install-vim-plug)
  - [Install node for coc](#install-node-for-coc)
    - [Via package manager](#via-package-manager)
    - [Using NodeSource PPA](#using-nodesource-ppa)


## Install neovim

```bash
sudo apt install neovim
```

## Install [Vim Plug](https://github.com/junegunn/vim-plug)

```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

## Install node for [coc](https://github.com/neoclide/coc.nvim)

### Via package manager

```bash
sudo apt search nodejs
sudo apt install nodejs
sudo apt install npm
```

### Using [NodeSource](https://github.com/nodesource/distributions#debinstall) PPA

```bash
cd ~
curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
```

Verify that the script is safe to run

```bash
less /tmp/nodesource_setup.sh
```

When you are satisfied that the script is safe to run, exit your editor. Then run the script with sudo:

```bash
sudo bash /tmp/nodesource_setup.sh
```

```bash
sudo apt install nodejs
```
