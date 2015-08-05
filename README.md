##  Magento 2
Magento with db manager running easily in just one build / run.

### What's bundled :
- Magento 2.0 (Beta build)
- Adminer (Db Manager)
- Ubuntu 14.04 with shell access
- AMP (Apache (2.0) / Php (5.5.9) / Mysql 5.6)
- Supervisor [to keep them up and running all time]

### How to Run using docker hub
This is simple and one command that does it all
> docker run -d -p 80:80 -p 2222:22 ilampirai/docker-magento2

Thats it, The docker image will be pulled and start the container automatically.

### How to build & run :
Step 1 : Build
Get into your server with SHELL access. And run a git pull which follows
> git clone https://github.com/ilampirai/docker-magento2.git .

NOTE: There is a tiny little dot in the end

This will get basic files for building our docker image. Then start the build using
> docker build -t {sitename}/magento .

NOTE: Again there is a tiny little dot in the end

This will take some time wait till the docker finish building. Once done, Docker will bring a success message.

Step 2 : Run
Using the docker image we build we can bring the server up in seconds. 

Just execute the final shell command  
> docker run -d -p 80:80 -p 2222:22 {sitename}/magento

This gives a container ID and your new magento is ready to be installed.

### Installing Magento :
Haha Not going to tell you the whole process just the starting point, Hoping you know the rest.

Open a browser and type 
> http://your.ip.address-or-sitename.com/

You can see a brand new magneto waiting to be installed.

Proceed the magento setup and when you are in need of Database details,
Our default root user with only the localhost connection
> root with empty password

Using root account login into 
> http://your.ip.address-or-sitename.com/adminer.php
NOTE : In a separate tab

You will get your Database Manager. 
Create a new database for Magento and use this info in Magento installation process and proceed. 

Thats it your Magento store is now running!!!!

### Shell Access to your Magento :
To access files you can use the shell access with 
- Host : your site ip or domain
- Port : 2222
- User : root
- Pass : admin123

Make sure you change the password on first login this is just a easy password that anyone can hack.
> passwd
this will help you set new password.

Enjoy you very own Magento 2.0
