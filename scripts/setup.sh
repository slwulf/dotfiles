# env setup
printf "Setting up developer environment...\n\n"
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.profile ~/.profile

source ~/.bash_profile

printf "Done."
