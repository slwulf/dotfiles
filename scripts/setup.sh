# env setup
printf "Setting up developer environment...\n\n"
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.gitignore_global ~/.gitignore_global
mkdir ~/Repos
git config --global core.excludesfiles ~/.gitignore_global

# install nvm
printf "Installing NVM...\n\n"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# install monokai terminal theme
printf "Installing Monokai Terminal theme...\n\n"
mkdir tmp
curl -o tmp/monokai.terminal 'https://raw.githubusercontent.com/stephenway/monokai.terminal/master/Monokai.terminal'
open tmp/monokai.terminal
rm -r tmp

printf "All done! Don't forget to set Monokai as the default theme.\n\n"

