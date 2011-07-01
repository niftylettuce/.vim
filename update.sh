#!/bin/bash

DOTVIM="$HOME/.vim"

if [ ! -e `which git` ]
then
  echo "You need git. On Ubuntu, install with sudo apt-get install git-core"
  exit 0
fi

if [ ! -d $DOTVIM ]
then
  mkdir $DOTVIM
fi

get_repo() {
    gh_user=$1
    repo=$2
    echo "Checking $repo"
    if [ -d "$DOTVIM/bundle/$repo/" ]
    then
        echo "Pulling latest from $repo"
        cd $DOTVIM/bundle/$repo
        git pull origin master
        cd ..
    else
        echo "Cloning repo for $repo"
        git clone git://github.com/$gh_user/$repo.git
    fi
}

get_other_repo() {
   path=$1
   repo=$2

   echo "Checking $repo"
   if [ -d "$DOTVIM/bundle/$repo/" ]
   then
      echo "Pulling latest from $repo"
      cd $DOTVIM/bundle/$repo
      git pull origin master
      cd ..
   else
      echo "Cloning repo for $repo"
      git clone $url$repo.git
   fi
}

echo "Creating .vim folders if necessary"
mkdir -p $DOTVIM/{autoload,bundle}
cd $DOTVIM/bundle/

tpope_repos=(git surround unimpaired abolish repeat markdown ragtag fugitive speeddating)

for r in ${tpope_repos[*]}; do
    repo="vim-$r"
    get_repo "tpope" $repo
done

echo "Installing NerdTree"
get_repo "scrooloose" "nerdtree"

echo "Installing TComment"
get_repo "tomtom" "tcomment_vim"

echo "Installing snipMate"
get_repo "msanders" "snipmate.vim"

echo "Installing xmledit"
get_repo "sukima" "xmledit"

echo "Installing solarized"
get_repo "altercation" "vim-colors-solarized"

echo "Installing xoria256.vim"
get_repo "guns" "xoria256.vim"

echo "Installing vim-matchit"
get_repo "mhz" "vim-matchit"

echo "Installing ack.vim"
get_repo "mileszs" "ack.vim"

echo "Installing javascript.vim"
get_repo "pangloss" "vim-javascript"

echo "Installing haskell.vim"
get_repo "vim-scripts" "haskell.vim"

echo "Installing calendar-vim"
get_repo "mattn" "calendar-vim"

echo "Installing molokai.vim"
get_repo "vim-scripts" "molokai"

echo "Installing vim-jade"
get_repo "digitaltoad" "vim-jade"

echo "Installing vim-stylus"
get_repo "wavded" "vim-stylus"

echo "Installing delimitMate"
get_repo "Raimondi" "delimitMate"

# echo "Installing neocomplcache"
# get_repo "Shougo" "neocomplcache"

echo "Installing supertab"
get_repo "ervandew" "supertab"

echo "Installing jshint"
get_repo "walm" "jshint.vim"

echo "Installing tabular"
get_repo "godlygeek" "tabular"

echo "Installing utl.vim"
get_repo "vim-scripts" "utl.vim"

echo "Installing vim-orgmode"
get_repo "jceb" "vim-orgmode"

# echo "Installing VimOrganizer"
# get_repo "hsitz" "VimOrganizer"

echo "Installing coffee-script"
get_repo "kchmck" "vim-coffee-script"

echo "Installing jellybeans"
get_repo "nanotech" "jellybeans.vim"

echo "Installing Command-T"
get_repo "wincent" "Command-T"
echo "Building Commant-T"
cd $DOTVIM/bundle/Command-T
if which rvm
then
    rvm system rake make
else
    rake make
fi

cd $DOTVIM/autoload
echo "Fetching latest pathogen.vim"
rm pathogen.vim
curl -O https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

echo "Checking to see if pathogen has already been added to .vimrc"
pathogen_cmd="call pathogen#runtime_append_all_bundles()"
contains=`grep "$pathogen_cmd" ~/.vimrc | wc -l`

if [ $contains == 0 ]
then
    echo "Hasn't been added, adding now."
    echo "$pathogen_cmd" >> ~/.vimrc
else
    echo "It was already added. Good to go"
fi
