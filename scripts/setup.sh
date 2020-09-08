# env setup
printf "Setting up developer environment...\n\n"
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.gitignore_global ~/.gitignore_global
mkdir ~/Repos
git config --global core.excludesfiles ~/.gitignore_global

# install nvm
printf "Installing NVM...\n\n"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# install rvm
printf "Installing RVM...\n\n"
curl -sSL https://get.rvm.io | bash -s stable

# install brew stuff
printf "Installing Homebrew...\n\n"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update

# install postgres
printf "Installing Postgres...\n\n"
brew install postgresql
brew services start postgresql

# install monokai terminal theme
printf "Installing Monokai Terminal theme...\n\n"
mkdir tmp
curl -o tmp/monokai.terminal 'https://raw.githubusercontent.com/stephenway/monokai.terminal/master/Monokai.terminal'
open tmp/monokai.terminal
rm -r tmp

printf "All done! Don't forget to set Monokai as the default theme.\n\n"

