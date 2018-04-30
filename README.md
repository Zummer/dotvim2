```
cd ~
git clone git@github.com:Zummer/dotvim2.git dovim
ln -s dotvim/vimrc .vimrc
ln -s dotvim .vim
mkdir dotvim/backups
sudo apt-get install vim

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \

vim
:PlugInstall
:source ~/.vimrc
```
