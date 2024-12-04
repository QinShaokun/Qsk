#!/bin/bash


#######################  shell辅助脚本  ########################

# 定义一个函数，用于提示用户输入并带有默认值  
function Tips() {  
    # $1 是提示信息，$2 是默认值  
    local prompt="$1"  
    local default="$2"  
    local input  
    read -p "$prompt [$default]: " input  
      
    # 如果输入为空，则使用默认值  
    # ${input:-$default} 是一种参数扩展的语法  
    input=${input:-$default}  
  
    # 输出（返回）用户的输入或默认值  
    echo "$input"  
}  



#######################  新系统基本工具  ########################

install_build() {
    echo "安装V编译软件所需的基本工具集:gcc,g++,make等" 
    sudo apt install -y build-essential
    sudo apt-get install -y make build-essential libncurses5-dev libncursesw5-dev --fix-missing

}


install_VM_tools() {
    echo "安装VM-tools" 
    sudo apt autoremove -y open-vm-tools
    sudo apt-get install -y open-vm-tools-desktop
}


install_CLASH() {
    wget https://mirror.ghproxy.com//https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v1.7.7/clash-verge_1.7.7_amd64.deb
    sudo dpkg -i clash-verge_1.7.7_amd64.deb
    rm -rf clash-verge_1.7.7_amd64.deb
}


Init(){
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y git
    sudo apt install -y xclip
    sudo apt install -y curl
    install_build
}


Basic_setup(){
 while true
    do
        clear
        echo "新系统基本工具安装，请输入要执行的命令: "
        echo "1: 安装常用工具"
        echo "2: 系统代理:CLASH"
        echo "3: 虚拟机VM-tool"
        echo "0: 退出"
        read -p "选择要执行的命令：" operation

        if [ "$operation" -eq 1 ]; then 
            Init
        elif [ "$operation" -eq 2 ]; then  
            install_CLASH
        elif [ "$operation" -eq 3 ]; then  
            install_VM_tools
        elif [ "$operation" -eq 0 ]; then  
            break
        else  
            echo "无效输入"  
        fi
    done
}


#######################  系统配置类  ########################

Ubuntu_Config_Addtsinghua(){
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.back
    echo "
## 官方源
    # deb http://cn.archive.ubuntu.com/ubuntu/ focal main restricted
    # deb http://cn.archive.ubuntu.com/ubuntu/ focal-updates main restricted
    # deb http://cn.archive.ubuntu.com/ubuntu/ focal universe
    # deb http://cn.archive.ubuntu.com/ubuntu/ focal-updates universe
    # deb http://cn.archive.ubuntu.com/ubuntu/ focal multiverse
    # deb http://cn.archive.ubuntu.com/ubuntu/ focal-updates multiverse
    # deb http://cn.archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
    # deb http://security.ubuntu.com/ubuntu focal-security main restricted
    # deb http://security.ubuntu.com/ubuntu focal-security universe
    # deb http://security.ubuntu.com/ubuntu focal-security multiverse
    # deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > sources.list
    
    echo " 
## 清华源
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
    deb http://security.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse" >> sources.list
    
    sudo cp sources.list /etc/apt/sources.list
    rm sources.list
    sudo apt update
    sudo apt upgrade -y
}



Ubuntu_Config(){

 while true
    do
        clear
        echo "系统配置，请输入要执行的命令: "
        echo "1: 添加清华源(ubuntu20.04)"
        echo "0: 退出"
        read -p "选择要执行的命令：" operation

        if [ "$operation" -eq 1 ]; then 
            echo "配置文件位置:/etc/apt/sources.list"
            echo "其他版本源登录官网查看: https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/"
            echo "针对ubuntu20.04更换清华源，按任意键继续..."  
            read -rsn1  
            Ubuntu_Config_Addtsinghua
        elif [ "$operation" -eq 0 ]; then  
            break
        else  
            echo "无效输入"  
        fi
    done
}





#######################  软件类  ########################
##  1
Soft_install_Edge() {
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
    sudo rm microsoft.gpg
    sudo apt update
    sudo apt install microsoft-edge-dev
}

##  2
Soft_install_Google() {
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb 
    rm -rf google-chrome-stable_current_amd64.deb 
}

##  3
Soft_install_VScode() {
    sudo apt update
    sudo apt install software-properties-common apt-transport-https wget
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt install code
}


##  4
Soft_install_Anaconda() {
    wget --user-agent="Mozilla" https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
    bash Anaconda3-2024.06-1-Linux-x86_64.sh 
    gnome-terminal
    #conda config --add channels  https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
    #conda config --add channels  https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
    #conda config --add channels  https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
    #conda config --add channels  https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro
    #conda config --add channels  https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
    conda config --set auto_activate_base false   
    rm -rf Anaconda3-2024.06-1-Linux-x86_64.sh 
}


##  5
Soft_install_Pycharm() {
    sudo snap install pycharm-community --classic
}

##  6
Soft_install_Clion() {
    sudo snap install clion --classic
}

Soft_install_Zotero() {
		wget -qO- https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh | sudo bash
		sudo apt update
		sudo apt install -y zotero
}

Soft_install_Unity(){
	wget -qO - https://hub.unity3d.com/linux/keys/public | gpg --dearmor | sudo tee /usr/share/keyrings/Unity_Technologies_ApS.gpg > /dev/null
	sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/Unity_Technologies_ApS.gpg] https://hub.unity3d.com/linux/repos/deb stable main" > /etc/apt/sources.list.d/unityhub.list'
	sudo apt update
	sudo apt-get install unityhub -y
	sudo apt install libgconf-2-4 -y
}


#安装命令
Soft_install() {
    while true
    do
        clear
        echo "软件安装：请输入要安装的软件: "
        echo "1: 安装Edge浏览器"
        echo "2: 安装Google浏览器"
        echo "3: 安装VS Code"
        echo "4: 安装Anaconda"
        echo "5: 安装Pycharm"
        echo "6: 安装Clion"
        echo "7: 安装Zotero"
        echo "8: 安装Unity"
        echo "0: 退出"
        
        read -p "选择要执行的命令：" operation
        
        if [ "$operation" -eq 1 ]; then  
            Soft_install_Edge
        elif [ "$operation" -eq 2 ]; then  
            Soft_install_Google 
        elif [ "$operation" -eq 3 ]; then 
            Soft_install_VScode
        elif [ "$operation" -eq 4 ]; then  
            Soft_install_Anaconda
        elif [ "$operation" -eq 5 ]; then 
            Soft_install_Pycharm 
        elif [ "$operation" -eq 6 ]; then 
            Soft_install_Clion
        elif [ "$operation" -eq 7 ]; then 
            Soft_install_Zotero
        elif [ "$operation" -eq 8 ]; then 
            Soft_install_Unity
        elif [ "$operation" -eq 0 ]; then  
            break
        else  
            echo "无效输入"  
        fi
    done
}

#######################  Vim类  ########################
Vim_Config_vimrc(){
    echo "
    \"显示管理
    set number			\"设置绝对行号
    \"set relativenumber	\"设置相对行号
    syntax on			\"语法高亮
    set wrap			\"自动换行
    \"set cursorline		\"突出显示当前行
    \"set cursorcolumn	\"突出显示当前列
    set showmatch		\"显示括号匹配
    set showmode		\"底部显示当前模式
    set showcmd			\"输入的命令显示出来
    set shiftwidth=4	\"设置自动缩进长度为4空格
    set autoindent                  \" 设置自动缩进：即每行的缩进值与上一行相等；使用 noautoindent 取消设置
    set cindent                     \" 以C/C++的模式缩进
    set scrolloff=4                 \" 设定光标离窗口上下边界 4 行时窗口自动滚动
    set mouse=a
    set splitbelow
    set splitright
    \"set clipboard=unnamed
    \"set clipboard=unnamedplus


    \"按键管理
    let mapleader=\" \"
    nmap <leader>t <Esc>:ter<CR>
    nmap <leader>s :w<CR>
    nmap <leader>w :q<CR>
    
    set tabstop=4		\"设置tab长度为4空格
    map <silent> <C-e> :NERDTreeToggle<CR>	\"将nerdtree插件绑定为	ctrl+e

    \" function管理
    map <F5> :call CompileRunGpp()<CR>
    map <F5> :call RunPython()<CR>
    
    \" C++的编译和运行
    func! CompileRunGpp()
        exec \"w\"
        exec \"!g++ % -o %<\"
        exec \"! ./%<\"
    endfunc
    
    func! RunPython()
        exec \"W\"
        if &filetype == \'python\'
            exec \"!time python3 %\"
        endif
    endfunc    

    \"插件管理
    call plug#begin()

        Plug 'scrooloose/nerdtree'
    \"    Plug 'valloric/youcompleteme'
        \"Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
        Plug 'jiangmiao/auto-pairs'
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
        Plug 'preservim/nerdcommenter'
        Plug 'mhinz/vim-startify'
        Plug 'ghifarit53/tokyonight-vim'
        Plug 'Yggdroot/indentLine'
        Plug 'preservim/tagbar'
        Plug 'voldikss/vim-floaterm'


    call plug#end()
    
    
    \"插件配置
    \"<ghifarit53/tokyonight-vim>
    set termguicolors
    let g:tokyonight_style = 'night' \" available: night, storm
    let g:tokyonight_enable_italic = 1
    \"let g:tokyonight_transparent_background = 1 
    colorscheme tokyonight
    
    
    \"<auto-pairs>
    au Filetype FILETYPE
    au FileType php
    
    
    \"<vim-airline>
    set laststatus=2  \"永远显示状态栏
    let g:airline_powerline_fonts = 1  \" 支持 powerline 字体
    let g:airline#extensions#tabline#enabled = 1 \" 显示窗口tab和buffer
    \"let g:airline_theme='moloai'  \" murmur配色不错
    if !exists('g:airline_symbols')
      let g:airline_symbols = {}
    endif
    let g:airline_left_sep = '▶'
    let g:airline_left_alt_sep = '❯'
    let g:airline_right_sep = '◀'
    let g:airline_right_alt_sep = '❮'
    let g:airline_symbols.linenr = '¶'
    let g:airline_symbols.branch = '⎇'
    

		\" tabline中当前buffer两端的分隔字符
		let g:airline#extensions#tabline#left_sep = ' '
		\" tabline中未激活buffer两端的分隔字符
		let g:airline#extensions#tabline#left_alt_sep = ' '
		\" tabline中buffer显示编号
		let g:airline#extensions#tabline#buffer_nr_show = 1
		\" 映射<leader>num到num buffer
		map <leader>1 :b 1<CR>
		map <leader>2 :b 2<CR>
		map <leader>3 :b 3<CR>
		map <leader>4 :b 4<CR>
		map <leader>5 :b 5<CR>
		map <leader>6 :b 6<CR>
		map <leader>7 :b 7<CR>
		map <leader>8 :b 8<CR>
		map <leader>9 :b 9<CR>
    
    

    
    
    "<vim-floatterm> " 设置浮动终端的快捷键
	  let g:floaterm_keymap_new = '<Leader>tw'     "新建终端。
    let g:floaterm_keymap_toggle = '<Leader>tt'  "终端显隐。
    let g:floaterm_keymap_prev = '<Leader>tp'    "上一个终端。
    let g:floaterm_keymap_next = '<Leader>tn'    "下一个终端。
    let g:floaterm_keymap_kill = '<Leader>tk'    "关掉终端。
    let g:floaterm_wintype = 'float'             "浮动窗口类型。
    let g:floaterm_position = 'center'           "在窗口中间显示。
    

    " > ~/.vimrc 
}


Vim_install_font() {
    wget -c https://mirror.ghproxy.com//https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip
    sudo unzip Hack.zip -d /usr/share/fonts/Hack
    rm -rf Hack.zip
    cd /usr/share/fonts/Hack
    sudo mkfontscale # 生成核心字体信息
    sudo mkfontdir # 生成字体文件夹
    sudo fc-cache -fv # 刷新系统字体缓存
    gsettings set org.gnome.desktop.interface monospace-font-name 'Hack Nerd Font Regular 12'
}

Vim_install_neovim() {
    echo "安装neovim-v0.9.5,并配置LazyVim" 
    sudo remove neovim
    sudo wget https://mirror.ghproxy.com//https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
    sudo tar xzvf nvim-linux64.tar.gz
    sudo mv nvim-linux64 /usr/local/neovim
    rm -rf nvim-linux64.tar.gz
    sudo ln -s /usr/local/ne ovim/bin/nvim /usr/bin/nvim
}

Vim_install_initVim(){
    sudo apt-get install vim
    Vim_Config_vimrc
    if [ ! -f "~/.vim/autoload/plug.vim"]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
}

Vim_install_LazyVim(){
    Vim_install_neovim
    # 安装LazyVim
    git clone https://mirror.ghproxy.com//https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
}


##Vim类安装接口
Vim_install(){
 while true
    do
        clear
        echo "Vim安装,请输入要执行的命令: "
        echo "1: 安装字体"
        echo "2: 安装配置原生vim"
        echo "3: 安装neovim并使用Lazyvim配置"
        echo "0: 退出"
        read -p "选择要执行的命令：" operation

        if [ "$operation" -eq 1 ]; then 
            Vim_install_font
        elif [ "$operation" -eq 2 ]; then  
            Vim_install_initVim
        elif [ "$operation" -eq 3 ]; then  
            Vim_install_LazyVim
        elif [ "$operation" -eq 0 ]; then  
            break
        else  
            echo "无效输入"  
        fi
    done
}
#######################   Docker类    ########################
Docker_ins(){
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable docker
}

Docker_Config(){
    echo "
        {
        \"registry-mirrors\" :
            [
                \"https://docker.m.daocloud.io\",
                \"https://noohub.ru\",
                \"https://huecker.io\",
                \"https://dockerhub.timeweb.cloud\",
                \"https://docker.rainbond.cc\"
            ]
        }
    " >> /etc/docker/daemon.json

}


Docker_install(){

while true
    do
        clear
        echo "Docker配置,请输入要执行的命令: "
        echo "1: 安装Docker"
        echo "2: 更换Docker源"
        echo "0: 退出"
        read -p "选择要执行的命令：" operation
            
        if [ "$operation" -eq 1 ]; then 
            Docker_ins
        elif [ "$operation" -eq 2 ]; then 
            echo "配置文件位置:/etc/docker/daemon.json"
            echo "添加Docker源,按任意键继续..."  
            read -rsn1  
            Docker_Config
        elif [ "$operation" -eq 0 ]; then  
            break
        else  
            echo "无效输入"  
        fi
    done

 
}



#######################   Ros类    ########################
install_gazebo(){
    sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
    wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
    echo "安装gazebo11: "
    sudo apt-get update
    sudo apt-get install -y gazebo11
    sudo apt-get install -y libgazebo11-dev
    echo "检查安装："    
    # sudo apt-get install ros-noetic-rviz
    # sudo apt-get install ros-foxy-robot-state-publisher
    sudo apt-get install -y ros-foxy-gazebo-ros-pkgs ros-noetic-gazebo-ros-control
    sudo apt-get install -y ros-foxy-moveit
    sudo apt-get install -y ros-foxy-joint-state-controller
    sudo apt-get update -y
    echo "安装模型："  
    cd ~/.gazebo || exit
    git clone https://github.com/osrf/gazebo_models
    sudo cp -r ~/.gazebo/gazebo_models/* /usr/share/gazebo-11/models
}

install_ROS2_env(){
    while true
    do
        clear
        echo "请输入要安装的软件: "
        echo "1: fishros一键配置"
        echo "2: 安装gazebo"
        echo "0: 退出"
        
        read -p "选择要执行的命令：" operation
        
        if [ "$operation" -eq 1 ]; then  
            wget https://fishros.com/install -O fishros && . fishros            
        elif [ "$operation" -eq 2 ]; then  
            install_gazebo
        elif [ "$operation" -eq 3 ]; then 
            break
        elif [ "$operation" -eq 4 ]; then  
            break
        elif [ "$operation" -eq 5 ]; then 
            break
        elif [ "$operation" -eq 0 ]; then  
            break
        else  
            echo "无效输入"  
        fi
    done

}

#######################  主程序  ########################
quit() { 
    exit 0 
}

main() {
    while true
    do
        clear
        echo "请输入要执行的命令: "
        echo "1: 新系统基本工具安装"
        echo "2: Ubuntu系统配置"
        echo "3: 安装配置vim"
        echo "4: 安装常用软件"
        echo "5: 安装docker"
        echo "6: 配置ROS环境"
        echo "0: 退出"
        
        read -p "选择要执行的命令：" operation

        if [ "$operation" -eq 1 ]; then 
            Basic_setup 
        elif [ "$operation" -eq 2 ]; then  
            Ubuntu_Config
        elif [ "$operation" -eq 3 ]; then 
            Vim_install
        elif [ "$operation" -eq 4 ]; then  
            Soft_install
        elif [ "$operation" -eq 5 ]; then  
            Docker_install
        elif [ "$operation" -eq 6 ]; then  
            install_ROS2_env
        elif [ "$operation" -eq 0 ]; then  
            quit
        else  
            echo "无效输入"  
        fi
    done
}

main




