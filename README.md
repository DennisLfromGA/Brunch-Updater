# Brunch-Updater
Brunch Updater is a handy bash script intended to make updating the Brunch Framework easier for users unfamiliar or uncomfortable with writing out terminal commands. It is intended to be ran as a single command that then guides users into making selections tailored to their own files and system. It is a bit slower than writing out the installation command, this is by design to help new users feel comfortable with updating their system.
All Brunch installation and documentation is maintained at https://github.com/sebanc/brunch

# Currently implemented:

Script checks for Brunch update files with their default names on the PC in ~/Downloads
- If no files are present, it will prompt the user to download a Brunch release, this can either be the most recent release downloaded automatically in the script, or the user can be linked to the release page to pick a different release if they want to.
- If one file is present, it will ask if the user want to update with that release.
- If multiple brunch files are present, the script will list them and allow the user to pick which they want to use.
In all cases, the script will then check if it is the same version they are already using, and warn them if it is. (Giving them the option to back out or proceed)

Before updating, the script will check for any Chrome OS Recovery files with their default names on the PC in ~/Downloads
- If no files are present, it proceeds to update Brunch without interuption.
- If one file is present, it will ask if the user wants to update Chrome OS with it. If they select no, it just updates Brunch.
- If multiple recoveries are present, the script will ask the user if they want to update Chrome OS and list them if the users says yes. If they select no, it just updates Brunch.

The script will sanitize itself and return the user's terminal to their original working directory when it is closed, it is intended to be ran from anywhere and handles the complex operations itself.

In most cases, this is a simple script. Launching it with a Brunch file already downloaded will update the framework without the user having to input any difficult terminal commands. If they dont have an update file it will provide one for them, and if they have multiple if gives them the options.

# To-do list
- Clean up. This code is messy and uncommented. I would like to clean it up to make it leaner and easier for others to understand.
- Handeling and unzipping of Chrome OS recoveries that are still zipped.
- Parsing recoveries to display as board name and release version based on default file name if possible.
- More user friendly interface for beginners
- Companion Applet/Extention/script that checks latest Brunch releases against a user's version to inform them if an update is avaliable
