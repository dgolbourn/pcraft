Pcraft
==========

I made this Minecraft server so my son and I can play Minecraft, with various mods and so on. 

This project is indebted to the fine work of [itzg/docker-minecraft-server](https://github.com/itzg/docker-minecraft-server) and [minecraft-spot-pricing](https://github.com/vatertime/minecraft-spot-pricing).

Pcraft deploys to AWS a Java Minecraft server with Fabric mods. The cloud infrastructure uses scheduled auto scaling to turn the server off and on and spot pricing while it is on to keep things affordable. The deployment includes a file server to aid users in downloading the correct Resource Packs and Client Mods. The server also has administration tools [mcrcon](https://github.com/Tiiffi/mcrcon) and [MCA Selector](https://github.com/Querz/mcaselector) to help admins keep things tidy.

The selection of mods I've chosen is motivated by the desire to track the look and feel of my favourite Minecraft Youtubers such as those on the [Hermitcraft](https://hermitcraft.com/) series.

For players
-----------

1. Tell the admin (me) your Minecraft user name so I can add you to the allow list

2. Install the [Fabric Loader](https://fabricmc.net/use/); this will enable you to select the Fabric version of Minecraft in the Minecraft Launcher when you start the game

3. Download the client mods from [Pcraft](http://pcraft.co.uk:8080/mods) and place them in the `/mods` directory of your Minecraft (e.g. probably `%APPDATA%\.minecraft\mods` on Windows)

4. Launch the game, choose Multiplayer, and add the Pcraft server address `pcraft.co.uk`.
  
5. **Congratulations, you've joined the Pcraft server!**

While playing, you can use the map [here](http://pcraft.co.uk:8100)


For server admins
-----------------
If you want your own Pcraft:

1. Create an AWS Stack using the [Cloudformation template](aws/cf.yml)

3. Enjoy
