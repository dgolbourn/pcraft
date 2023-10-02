Percycraft
==========

Percycraft is a Java Minecraft server with Fabric [mods](https://github.com/dgolbourn/percycraft/wiki/Mods) deployed to AWS.

I made this Minecraft server so that my son and I can play Minecraft together.

This project is indebted to the fine work of [docker-minecraft-server](https://github.com/itzg/docker-minecraft-server), [minecraft-spot-pricing](https://github.com/vatertime/minecraft-spot-pricing) and [lazymc](https://github.com/timvisee/lazymc).

About
-----

To control costs, while balancing the user experience, Percycraft takes the approach of running the server on demand.

When one connects to Percycraft, if the server is not active, they connect to the lobby. Starting the game from the lobby will start up the server and shut down the lobby; then the player can connect as normal after a few minutes.

Once the last player disconnects, if the server is idle for more than an hour, it shuts down and the lobby starts up again in its place.

At shutdown the server is backed up.

As Percycraft was set up with my son in mind, to mitigate his lack of patience, the server is also configured to start up at certain times (e.g. weekends) so it is immediately ready even if no one has recently tried to connect.

The selection of mods I've chosen is motivated by the desire to track the look and feel of my favourite Minecraft Youtubers such as [Forge Labs](https://www.youtube.com/channel/UCiSVf-UpLC9rRjAT1qRTW0g) and those of the [Hermitcraft](https://hermitcraft.com/) series.

There is also a file server to host the client-side resource packs and mods.

[Here](http://cdn.pcraft.co.uk/album/latest.png) is the world so far!

For players
-----------

1. Tell the admin (me) your Minecraft user name so I can add you to the allow list
2. Install the [Fabric Loader](https://fabricmc.net/use/); this will enable you to select the Fabric version of Minecraft in the Minecraft Launcher when you start the game
3. *Windows*: Install the [client mods](http://cdn.pcraft.co.uk/percycraft-installer.exe)

   *Others*: download the client mods from [here](http://cdn.pcraft.co.uk/mods) and place them in the `/mods` directory of your Minecraft
4. **OPTIONAL** Download these [shaders](https://sonicether.com/shaders/download/renewed-v1-0-1) and place them in the `/shaderpacks` directory of your Minecraft
5. Launch the game, choose Multiplayer, and add the Percycraft server `pcraft.co.uk`.
6. **Congratulations, you've joined the Percycraft server!**

For server admins
-----------------
If you want your own Percycraft:

1. Create an AWS Stack using the [Cloudformation template](aws/cf.yml)
2. Enjoy

