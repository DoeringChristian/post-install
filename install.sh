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
sudo dnf install -y git

echo "Installing Rust..."
curl https://sh.rustup.rs -sSf | bash -s -- -y
source $HOME/.bashrc

echo "Installing ZSH..."
sudo dnf install -y zsh

echo "Installing Nerd Font ($NERD_FONT)..."
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$NERD_FONT.zip
mkdir .fonts
unzip -f $NERD_FONT -d .fonts/
rm -f $NERD_FONT.zip
fc-cache -fv

echo "Changing Default Shell to ZSH..."
chsh -s $(which zsh)

echo "Installing Oh-My-ZSH..."
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing Config..."
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.zshrc
echo ".cfg" >> .gitignore
git clone --recursive --bare https://github.com/DoeringChristian/dotfiles.git $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

echo "Backup old Config..."
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}

echo "Checkout main..."
config checkout
config config --local status.showUntrackedFiles no

cd $HOME
config submodule update --init


echo "Installing Starship..."
cargo install starship --locked
echo 'eval "$(starship init zsh)"' >> .zshrc

echo "Installing NeoVim..."
sudo dnf copr enable -y agriffis/neovim-nightly
sudo dnf install -y neovim python3-neovim

# echo "Installing Tmux..."
# dnf install -y tmux
#
# echo "Installing Tmux:TPM..."
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#
# echo "Reloading Tmux..."
# tmux new-session -d -s "tmp" tmux source-file ~/.tmux.conf

echo "Installing Zellij..."
cargo install --locked zellij
