# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

Each top-level directory is a Stow package. The directory structure inside mirrors where files should land relative to `$HOME`.

```
dotfiles/
├── nvim/.config/nvim/   → ~/.config/nvim/
├── sway/.config/sway/   → ~/.config/sway/
├── docs/                → setup guides (not stowed)
└── ...                  → future packages
```

## Setup

```bash
# Clone
git clone https://github.com/Antranduc/dotfiles.git ~/Developer/dotfiles

# Install dependencies
brew install stow

# Symlink everything
cd ~/Developer/dotfiles
./install.sh
```

## Adding a new package

Create a directory mirroring the target path relative to `$HOME`, then re-run `./install.sh`. For example, to track `.zshrc`:

```
mkdir -p zsh
# Place .zshrc inside zsh/
mv ~/.zshrc zsh/.zshrc
./install.sh
```
