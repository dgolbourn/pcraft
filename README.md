Percycraft
==========

I made this Minecraft server so that my son and I can play Minecraft together, with various mods and so on. 

This project is indebted to the fine work of [docker-minecraft-server](https://github.com/itzg/docker-minecraft-server), [minecraft-spot-pricing](https://github.com/vatertime/minecraft-spot-pricing) and [lazymc](https://github.com/timvisee/lazymc).

Percycraft deploys to AWS a Java Minecraft server with Fabric mods. The server can be turned on on-demand when connected to via Minecraft and turns itself off when left idle for long enough. Additionally, the cloud infrastructure is configured to use scheduled auto scaling to also turn the server off and on at certain times of day. When the server is on, it uses spot pricing to keep things affordable. The deployment also includes a file server to aid users in downloading the correct Resource Packs and Client Mods.

The selection of mods I've chosen is motivated by the desire to track the look and feel of my favourite Minecraft Youtubers such as those on the [Hermitcraft](https://hermitcraft.com/) series.

[Here](http://cdn.pcraft.co.uk/album/latest.png) is the world so far!

For players
-----------

1. Tell the admin (me) your Minecraft user name so I can add you to the allow list

2. Install the [Fabric Loader](https://fabricmc.net/use/); this will enable you to select the Fabric version of Minecraft in the Minecraft Launcher when you start the game

3. *Windows*: Install the [client mods](http://cdn.pcraft.co.uk/percycraft-installer.exe)

   *Others*: download the client mods from [here](http://cdn.pcraft.co.uk/mods) and place them in the `/mods` directory of your Minecraft

6. Launch the game, choose Multiplayer, and add the Percycraft server lobby `lobby.pcraft.co.uk`.
  
7. **Congratulations, you've joined the Percycraft server!**

For server admins
-----------------
If you want your own Percycraft:

1. Create an AWS Stack using the [Cloudformation template](aws/cf.yml)

3. Enjoy
