# env setup
printf "Setting up dotfiles...\r\n"

touch "$DOTFILES/secrets.sh"
touch "$DOTFILES/machine_specific.sh"
touch "$DOTFILES/path.sh"

if [ -f ~/.bashrc ]; then
  echo "# PRE-EXISTING ~./bashrc" >> "$DOTFILES/machine_specific.sh"
  echo ": '" >> "$DOTFILES/machine_specific.sh"
  cat ~/.bashrc >> "$DOTFILES/machine_specific.sh"
  echo -e "'\n" >> $DOTFILES/machine_specific.sh
  rm ~/.bashrc
  echo "Moved existing ~/.bashrc contents to $DOTFILES/machine_specific.sh"
fi;

if [ -f ~/.bash_profile ]; then
  echo "# PRE-EXISTING ~./bash_profile" >> "$DOTFILES/machine_specific.sh"
  echo ": '" >> "$DOTFILES/machine_specific.sh"
  cat ~/.bash_profile >> "$DOTFILES/machine_specific.sh"
  echo -e "'\n" >> $DOTFILES/machine_specific.sh
  rm ~/.bash_profile
  echo "Moved existing ~/.bash_profile contents to $DOTFILES/machine_specific.sh"
fi;

if [ -f ~/.profile ]; then
  echo "# PRE-EXISTING ~./profile" >> "$DOTFILES/machine_specific.sh"
  echo ": '" >> "$DOTFILES/machine_specific.sh"
  cat ~/.profile >> "$DOTFILES/machine_specific.sh"
  echo -e "'\n" >> $DOTFILES/machine_specific.sh
  rm ~/.profile
  echo "Moved existing ~/.profile contents to $DOTFILES/machine_specific.sh"
fi;

ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.profile ~/.profile

source ~/.bash_profile

printf "Done."
