Percycraft
==========

I made this Minecraft server so my son and I can play Minecraft with various mods and so on. 

It deploys to AWS a Fabric mod Java Minecraft server which uses auto scaling and spot pricing to keep things affordable. The server also features a file server for downloading the requisite Resource Packs and Mods to your client. The server also has Minecraft administration tools mcrcon and mca-selector to keep things tidy.

For players
-----------

1. Tell the admin (me) your Minecraft user name so I can add it to the allow list

2. Get the IP address of the server from said admin

3. Install the [Fabric Loader](https://fabricmc.net/use/); this will allow you to select the Fabric version of Minecraft in the Minecraft Launcher when you start the game

5. Download:
    * Simple Voice Chat (`http://<server ip address>:8080/mods/voicechat-fabric-1.20.1-2.4.24.jar`)
    * Fabric API (`http://<server ip address>:8080/mods/fabric-api-0.88.1+1.20.1.jar`)
and place them in the `/mods` directory of your Minecraft (e.g. somewhere like `%APPDATA%\\.minecraft\\mods` on Windows)

6. Join the Percycraft server!

For server admins
-----------------

1. Create a AWS Stack using the Cloudformation template `aws/cf.yml`

2. `scp` the `aws/ec2` scripts to the EC2 instance, `ssh` in and run them

3. Enjoy

Or, if you just want to run the Percycraft server locally, type `./aws/ec2/start.sh" from the project root and it should all Just Work
