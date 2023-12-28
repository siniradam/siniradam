#!/usr/bin/env bash
function ohCredits()
{
   echo -e "\033[45m\

  ____  _      _____ _     _  __ _   
 / __ \| |    / ____| |   (_)/ _| |  
| |  | | |__ | (___ | |__  _| |_| |_ 
| |  | | '_ \ \___ \| '_ \| |  _| __|
| |__| | | | |____) | | | | | | | |_ 
 \____/|_| |_|_____/|_| |_|_|_|  \__|
                                     "
echo -e "\033[0m   Toolkit Installer - ohshift.io"
}

# Tools

osOS () {
    lsb_release -a
}

ohPM2 () {
    npm install pm2 -g
}

# Log Tools
ohLog(){
    echo -e "\033[48;5;020m => $1:\033[0m $2"
}

ohInfo(){
    echo -e "\033[48;5;051m \033[38;5;016m=> $1:\033[0m $2"
}

ohWarn(){
    echo -e "\033[48;5;220m \033[38;5;016m=> $1:\033[0m $2"
}

ohAlert(){
    echo -e "\033[48;5;202m \033[38;5;016m=> $1:\033[0m $2"
}

ohError(){
    echo -e "\033[48;5;160m \033[38;5;015m=> $1:\033[0m $2"
}




# Samples
# ohInfo "Fetching  " "OS Updates"  # Light Bule
# ohInfo "Loading   " "NVM"         # Light Bule
# ohLog "Upgrading " "OS"           # Purple
# ohLog "Updating  " "Permissions"  # Purple
# ohWarn "Installing" "OS Updates"  # Yellow
# ohAlert "Scheiße   " "OS Updates" # Orange
# ohError "Error     " "OS Updates" # Red

updateSystem () {
    ohInfo "Fetching  " "OS Updates"

    # Update package index
    sudo apt update


    ohLog "Upgrading " "OS"

    # Install upgrades 
    sudo apt upgrade
}

installNVM () {

    if ! command -v nvm &> /dev/null
    then
        # Install Node Version Manager
        ohInfo "Fetching  " "Node Version Manager"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
        source ~/.bashrc

        # Initiate NVM
        ohInfo "Loading   " "Node Version Manager"
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

        # Run Node 18 with NVM
        ohLog "Installing" "NodeJW 18"
        nvm install 18
        nvm use 18
    else
        ohLog "Found     " "NVM, skipping."
    fi

}

installNodeJS () {
    if ! command -v node &> /dev/null
    then
        ohInfo "Fetching  " "NodeJS"
    else
        ohLog "Found     " "NodeJS, skipping."
    fi
}


installNeovim () {
    # ohInfo "Fetching  " "NeoVIM"
    ohInfo "Updating  " "Apt for NeoVIM"  # Purple
    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:neovim-ppa/unstable

    ohInfo "Updating  " "APT"  # Purple
    sudo apt-get update

    ohWarn "Installing" "NeoVIM"
    sudo apt-get install neovim

    # NeoVIM Config;
    if [ ! -d ~/.config/nvim ]; then
        mkdir -p ~/.config/nvim;
        git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
    fi
}

installNginxLets () {
    sudo apt install certbot python3-certbot-nginx
}

installNginx () {
# Install
    sudo apt update
    sudo apt install nginx

# Firewall
    sudo ufw app list
    sudo ufw allow 'Nginx Full'
    sudo ufw status
}

ohPSQL () {
    ohLog "Installing" "PostgreSQL"
    sudo apt install postgresql postgresql-contrib
    
    ohAlert "Starting  " "Services"
    sudo systemctl start postgresql.service
    sudo -i -u postgres
}


#FN: Set a Machine Name
#Install Text Editor.




# if ! command -v nvim &> /dev/null
# then
# else
#     ohLog "Found     " "Neovim, skipping."
# fi


if [ "$1" = '' ]; then
    ohCredits
    echo ""
    ohInfo "Param\t" "Package"
    ohLog "update\t" "Apt Update & Upgrade"
    ohLog "neovim\t" "NeoVIM"
    ohLog "nvm\t\t" "Node Version Manager"
    ohLog "node\t" "Node JS"
    ohLog "psql\t" "PostgreSQL"
    ohLog "pm2\t\t" "PM2 - Process Manager"
    echo ""
    ohInfo "Param\t" "Output"
    ohAlert "pp\t\t" "Creates default projects path"
    ohAlert "osi\t\t" "OS Info"
    ohAlert "osi\t\t" "OS Info"
elif [ "$1" = 'neovim' ]; then
    ohInfo "Fetching  " "NeoVIM"
    ohInfo "Permissions" "NeoVIM"
    ohWarn "Starting  " "NeoVIM"
    # ohLog "App     " "OK."
fi


# updateSystem
