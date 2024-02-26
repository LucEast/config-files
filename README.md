# config-files ✏️

Here I store my config files. Feel free to use them.
I also created a neat [installer](setup.sh) to easily link the configfiles to their belonged loaction or delete them.

This repository contains config-files for the following applications.

## Applications

| application                                | configuration                                                                                  |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| [neovim](#neovim)                          | [common/.config/nvim](common/.config/nvim)                                                     |
| [Starship.rs](#starshiprs)                 | [common/.config/starship.toml](common/.config/starship.toml)                                   |
| [terminator](#terminator)                  | [Linux/terminator](Linux/terminator)                                                           |
| [tmux](#tmux)                              | [common/.tmux.conf](common/.tmux.conf), [common/.tmux-minimal.conf](common/.tmux-minimal.conf) |
| [vim](#vim)                                | [common/.vimrc](common/.vimrc)                                                                 |
| [Warp.dev](#warpdev)                       | [macOS/.warp/themes](macOS/.warp/themes)                                                       |
| [ZSH](#zsh)                                | [common/.zsh](common/.zsh), [common/.zshrc](common/.zshrc)                                     |

## Installation

 • [help](#help)\
 • [install](#install)\
 • [delete](#delete)

```bash
git clone https://github.com/LucEast/config-files.git; cd config-files
./setup.sh
```

**You will need to add arguments (-i|-d) to the script to work.**\
You can navigate through the script via the up and down arrow keys.\
To select a config-file, press space.\
Once selected, press Return to commit.

### help

![help](https://raw.githubusercontent.com/LucEast/config-files/main/screenshots/help.png)

### install

```bash
./setup.sh -i
```

<!-- ![install](https://raw.githubusercontent.com/LucEast/config-files/main/screenshots/install.png) -->

### delete

```bash
./setup.sh -d
```

<!-- ![delete](https://raw.githubusercontent.com/LucEast/config-files/main/screenshots/delete.png) -->

## neovim

[neovim](https://neovim.io)  

## Starship\.rs

[Starship.rs](https://starship.rs)

## terminator

[terminator](https://gnome-terminator.org)

## tmux

[tmux](https://github.com/tmux/tmux/wiki)

## vim

[vim](https://www.vim.org)

## Warp.dev

[Warp.dev](https://www.warp.dev)

## ZSH

[ZSH](https://www.zsh.org)


![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=LucEast&repo=dotfiles&title_color=3e83c8&text_color=00cb71&icon_color=299bab&bg_color=171717&hide_border=true)
