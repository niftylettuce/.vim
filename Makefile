vim = ~/.vim
all:update

install:
	@mv ~/.vimrc ~/.vimrc_bak || echo "There was no existing .vimrc, so no need to backup"
	@mv ~/.gvimrc ~/.gvimrc_bak || echo "There was no existing .gvimrc, so no need to backup"
	@ln -s ${vim}/vimrc ~/.vimrc
	@git submodule update --init
	@make -s command-t

update:
	@git submodule foreach git pull
	@make -s command-t
	@make -s pathogen

command-t:
	@cd ${vim}/bundle/command-t && rake clean && rake make

pathogen:
	@cd ${vim}/autoload && rm pathogen.vim && curl -O https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
