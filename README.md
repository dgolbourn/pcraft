Percycraft
==========

I made this Minecraft server so that my son and I can play Minecraft together, with various mods and so on. 

This project is indebted to the fine work of [itzg/docker-minecraft-server](https://github.com/itzg/docker-minecraft-server) and [minecraft-spot-pricing](https://github.com/vatertime/minecraft-spot-pricing).

Percycraft deploys to AWS a Java Minecraft server with Fabric mods. The cloud infrastructure uses scheduled auto scaling to turn the server off and on and spot pricing while it is on to keep things affordable. The deployment includes a file server to aid users in downloading the correct Resource Packs and Client Mods.

The selection of mods I've chosen is motivated by the desire to track the look and feel of my favourite Minecraft Youtubers such as those on the [Hermitcraft](https://hermitcraft.com/) series.

[Here](https://cdn.pcraft.co.uk/album/latest.png) is the world so far!

For players
-----------

1. Tell the admin (me) your Minecraft user name so I can add you to the allow list

2. Install the [Fabric Loader](https://fabricmc.net/use/); this will enable you to select the Fabric version of Minecraft in the Minecraft Launcher when you start the game

3. *Windows*: Install the [client mods](https://cdn.pcraft.co.uk/percycraft_installer.exe)

   *Others*: download the client mods from [here](https://cdn.pcraft.co.uk/mods) and place them in the `/mods` directory of your Minecraft

6. Launch the game, choose Multiplayer, and add the Percycraft server address `pcraft.co.uk`.
  
7. **Congratulations, you've joined the Percycraft server!**

For server admins
-----------------
If you want your own Percycraft:

1. Create an AWS Stack using the [Cloudformation template](aws/cf.yml)

3. Enjoy
