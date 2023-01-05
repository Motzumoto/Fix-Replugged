# Fix-Replugged
A bat script designed to fix replugged on discord canary. Will check if you have node installed and install it for you too!


# What it does
Checks if you have an internet connection and will wait until you have one if you don't have said internet connection
Checks if you have node.js installed
  If you dont have node installed it will ask you if you want to install it
    if you select yes the script will then get the node webpage and get the installer and install the application for you 
  if you select no, the script will exit
it will then try to kill discord canary 
installs pnpm
updates git config to make the directory safe (probably not needed)
pulls updates from the replugged repo
unplugs from canary and installs dependencies 
builds replugged 
plugs back into canary
launches canary for you 

# How to contribute
Thats easy, you can star the repo or add your own lines of code if you have suggestions.

# Join my Discord server
Join [here](https://discord.gg/cNRNeaX)
