#!/usr/bin/env bash

CLBlueOnWhite="\033[48;5;020m"
CLCyanOnBlack="\033[48;5;051m\033[38;5;016m"
CLYellowOnBlack="\033[48;5;220m\033[38;5;016m"
CLOrangeOnBlack="\033[48;5;202m\033[38;5;016m"
CLRedOnWhite="\033[48;5;160m\033[38;5;015m"
CLGrayOnGreen="\033[244;5;160m\033[38;5;015m"
#CLGrayOnGreen="\033[244;5;160m\033[38;5;015m" # This blinks
CLReset="\033[0m"
# PALETTE_BLINK="\e[5m"
# PALETTE_RESET='\e[0m'
# normal=$'\e[0m'

# setab => Background
# setaf => Foreground

get_server_name() {
    read -p "Enter server name: " InstanceName
    export NameInstance=$InstanceName
    echo "Updating .bashrc: $NameInstance"
    echo "export SERVER_NAME=\"$NameInstance\"" >> ~/.bashrc
    source ~/.bashrc

    read -p "Press Enter to continue..."
}

get_project_name() {
    read -p "Enter project name: " project_name
    export NameProject=$project_name
    echo "Selected project: $project_name"

    mkdir -p ~/projects/$project_name;
    echo "Project folder is created on ~/projects/$project_name"
    read -p "Press Enter to continue..."

}

# Bright pink 198

function ohCredits()
{
    tput setab 161
   echo -e "\

     ____  _      _____ _     _  __ _      
    / __ \| |    / ____| |   (_)/ _| |     
   | |  | | |__ | (___ | |__  _| |_| |_    
   | |  | | '_ \ \___ \| '_ \| |  _| __|   
   | |__| | | | |____) | | | | | | | |_    
    \____/|_| |_|_____/|_| |_|_|_|  \__|   
                                           "
tput setab 198 
echo -e "   Toolkit Installer - ohshift.io          \033[0m"
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
    echo -e "$CLBlueOnWhite => $1 $CLReset $2"
}

ohInfo(){
    echo -e "$CLCyanOnBlack => $1 $CLReset $2"
}

ohWarn(){
    echo -e "$CLYellowOnBlack => $1 $CLReset $2"
}

ohAlert(){
    echo -e "$CLOrangeOnBlack => $1 $CLReset $2"
}

ohError(){
    echo -e "$CLRedOnWhite => $1 $CLReset $2"
}

ohNode(){
    tput setab 118
    tput setaf 237
    echo -e " => $1 $CLReset $2"
}

# Function to display the main menu
display_main_menu() {
    clear
    ohCredits
    echo ""
    ohWarn 1 "Configure Server"
    ohNode 2 "Install Node Tools" 
    ohInfo 3 "Install Server & DB"
    ohLog 4 "Utilities"
    ohError 0 "Exit"
    # echo "Main Menu:"
    # echo "1. Configure Server"
    # echo "2. Manage Applications"
    # echo "0. Exit"
}

display_server_submenu() {
    clear
    ohWarn "Server Configuration"
    ohWarn 1 "Set Servername"
    ohWarn 2 "Create Project" 
    echo ""
    ohAlert 0 "Back"
    ohError 00 "Exit"
}

display_node_submenu() {
    clear
    ohNode "NodeJS Menu"
    ohNode 1 "Install Node Version Manager"
    ohNode 2 "Just Node JS"
    echo ""
    ohWarn "0 " "Back"
    ohAlert 00 "Exit"
}

display_http_submenu() {
    clear
    ohInfo "Server & DB Installation"
    ohInfo 1 "Install Nginx"
    ohInfo 2 "Set Nginx Firewall settings"
    ohInfo 3 "Nginx Let's Encrypt"
    ohInfo 4 "Install PostgreSQL"
    ohInfo 5 "Install MySQL"
    ohInfo 6 "Install MongoDB"
    echo ""
    ohWarn "0 " "Back"
    ohAlert 00 "Exit"
}

display_util_submenu() {
    clear
    ohLog "Utilities"
    ohLog 1 "Install Neovim"
    ohLog 2 "Cloudflare Tunnel Script"
    ohLog 3 "Cloudflare DDNS Script"
    ohLog 4 "Firewall Status"
    ohLog 5 "Firewall Enable"
    ohLog 6 "Firewall Disable"
    ohLog 7 "Port Search"
    ohLog 8 "Install Syncthing"
    echo ""
    ohWarn "0 " "Back"
    ohAlert 00 "Exit"
}

updateSystem () {
    ohInfo "Fetching  " "OS Updates"

    # Update package index
    sudo apt update


    ohLog "Upgrading " "OS"

    # Install upgrades 
    sudo apt upgrade
}

ohPortSearch(){
    echo -n "Enter port number: "
    read -r port
    ohLog "Searching for port" $port
    sudo lsof -nP -i4TCP:$port | grep LISTEN
    read -p "Press Enter to continue..."
}


installNVM () {
    ohLog "Installing" "NVM"

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
    ohLog "Installing" "NodeJS"
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
    ohLog "Installing" "Nginx"
    # Install
    sudo apt update
    sudo apt install nginx

    # Firewall
    sudo ufw app list
    sudo ufw allow 'Nginx Full'
    sudo ufw status
}

installPSQL () {
    ohLog "Installing" "PostgreSQL"
    sudo apt install postgresql postgresql-contrib
    
    ohAlert "Starting  " "Services"
    sudo systemctl start postgresql.service
    sudo -i -u postgres
}

installMYSQL(){

    ohLog "Installing" "MySQL"
}

installMongoDB(){
    ohLog "Installing" "MongoDB"
}

cloudflareTunnel(){
    ohAlert "Installing" "Cloudflare Tunnel Helper"
}

cloudflareDDNS(){
    ohAlert "Generating" "Cloudflare DDNS Script"
}


firewallEnable(){
    sudo ufw enable
}

firewallDisable(){
    sudo ufw disable
}

firewallStatus(){
    sudo ufw status
    sudo ufw app list
}

firewallAllow(){
    sudo ufw allow 'Nginx Full'
}

closeApp(){
    tput setab 232
    tput setaf 213 
    clear
    echo -e "Thanks for using, exiting..."
    
    exit 0

}

while true; do
    display_main_menu

    read -p "Enter your choice (0-4): " main_choice

    case $main_choice in
        1)
            # Submenu for server configuration
            while true; do
                display_server_submenu

                read -p "Enter your choice (0-2): " server_choice

                case $server_choice in
                    1)
                        get_server_name
                        ;;
                    2)
                        get_project_name
                        ;;
                    0)
                        break
                        ;;
                    00)
                        closeApp
                        ;;
                    *)
                        echo "Invalid choice. Please enter a valid option."
                        ;;
                esac

                # read -p "Press Enter to continue..."
            done
            ;;
        2)
            while true; do
                display_node_submenu

                read -p "Enter your choice (0-2): " node_choice

                case $node_choice in
                    1)
                        installNVM
                        ;;
                    2)
                        installNodeJS
                        ;;                        
                    0)
                        break
                        ;;
                    00)
                        closeApp
                        ;;
                    *)
                        echo "Invalid choice. Please enter a valid option."
                        ;;
                esac

                # read -p "Press Enter to continue..."
            done
            ;;
        3)
            while true; do
                display_http_submenu

                read -p "Enter your choice (0-6): " http_choice

                case $http_choice in
                    1)
                        installNginx
                        ;;
                    2)
                        installNodeJS
                        ;;
                    3)
                        installNginxLets
                        ;;
                    4)
                        installPSQL
                        ;;
                    5)
                        installMYSQL
                        ;;
                    6)
                        installMongoDB
                        ;;
                    0)
                        break
                        ;;
                    00)
                        closeApp
                        ;;
                    *)
                        echo "Invalid choice. Please enter a valid option."
                        ;;
                esac

                # read -p "Press Enter to continue..."
            done
            ;;
        4)
            while true; do
                display_util_submenu

                read -p "Enter your choice (0-7): " util_choice

                case $util_choice in
                    1)
                        installNeovim
                        ;;
                    2)
                        cloudflareTunnel
                        ;;
                    3)
                        cloudflareDDNS
                        ;;
                    4)
                        firewallStatus
                        ;;
                    5)
                        firewallEnable
                        ;;
                    6)
                        firewallDisable
                        ;;
                    7)
                        ohPortSearch
                        ;;
                    0)
                        break
                        ;;
                    00)
                        closeApp
                        ;;
                    *)
                        echo "Invalid choice. Please enter a valid option."
                        ;;
                esac

                # read -p "Press Enter to continue..."
            done
            ;;
        0)
            closeApp
            ;;
        *)
            echo "Invalid choice. Please enter a valid option."
            ;;
    esac

    # read -p "Press Enter to continue..."
done

