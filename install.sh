#!/bin/sh

cd $HOME

NERD_FONT=DroidSansMono

echo "Installing Development Tools..."
sudo dnf groupinstall -y "Development Tools" "Development Libraries"
sudo dnf install -y cmake
sudo dnf install -y wget
sudo dnf install -y util-linux-user
sudo dnf install -y which
sudo dnf install -y 'dnf-command(copr)'

echo "Installing Rust..."
curl https://sh.rustup.rs -sSf | bash -s -- -y
source $HOME/.bashrc

echo "Installing ZSH..."
dnf install -y zsh

echo "Installing Nerd Font ($NERD_FONT)..."
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$NERD_FONT.zip
mkdir .fonts
unzip $NERD_FONT -d .fonts/
rm -f $NERD_FONT.zip
fc-cache -fv

echo "Changing Default Shell to ZSH..."
chsh -s $(which zsh)

echo "Installing Oh-My-ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing Starship..."
cargo install starship --locked
echo 'eval "$(starship init zsh)"' >> .zshrc

echo "Installing NeoVim..."
dnf copr enable -y agriffis/neovim-nightly
dnf install -y neovim python3-neovim
