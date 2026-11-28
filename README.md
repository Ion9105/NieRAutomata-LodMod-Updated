# NieRAutomata-LodMod-Updated
This is an updated version of the NieRAutomata-LodMod, that has been updated for the 2026 Steam version of the game, but will also work on older versions and non-steam versions.

# About
An XInput/DInput/DXGI wrapper DLL that hooks into NieR Automata (PC ver.) and disables object LODs, improves shadow quality/distances, and much more!

More info & stable releases can be found at https://www.nexusmods.com/nierautomata/mods/165

# Building
**I will not be maintaining nor giving instructions on how to build this project with Visual Studio on Windows, but it should be the same as with any other project.**
## Linux
1. To build on Linux, make sure that you have [msvc-wine](https://github.com/mstorsjo/msvc-wine) installed, as well as Cmake, and other necessary packages for building on your distribution.
	   On Arch Linux, this can be installed through the AUR using your favourite AUR helper (or manually obtaining the package).
	   *I don't know what the package name might be for your distribution, so adjust accordingly, or install it from the Github repo.*
2. Since this is also distribution-specific, please modify the following line in ``msvc-wine-toolchain.cmake`` to actually point to the bin directory of your installation of the package/repo. On Arch Linux, this default location should work as of writing this:
```
set(MSVC_BIN_DIR "/opt/msvc/bin/x64" CACHE PATH "MSVC-wine bin directory")
```
3. Decide if you want to build with H.264 support or not. If you want to use any other mod that requires H.264 support for their video files, then you need this feature.
	1. Navigate to [here](https://github.com/Final-Game-Production-Inc/Autodesk-Scaleform-GFx-SDK/releases) and download 3rdParty.7z. 
	2. Extract the following file from the archive: ``cri2019/pc/libs/x64/cri_mana_pcx64.lib`` to the ``Automata-LodMod`` folder (contains the .cpp and .h files).
	3. Edit the bottom of CMakeLists.txt file. Comment out ``target_link_libraries(lodmod PRIVATE mfplat mfuuid shell32)`` by putting a # in front of the line. Then uncomment ``#target_link_libraries(lodmod PRIVATE mfplat mfuuid shell32 cri_mana_pcx64)`` by removing the # at the beginning of the line. Make sure to save the file.
	4. Edit the top of ``Automata-LodMod/CriH264.cpp``. Uncomment the line 
	   ``// #define CRI_H264_SUPPORT 1`` by removing the // at the beginning. Save the file.
4. Finally, run the build script. If you want to make the build automatically output the build .dll in your game directory, run the build script like so:
   ``GAME_DIR=/path/to/game/folder ./build.sh``.
   E.g: ``GAME_DIR=/home/user/.local/share/Steam/steamapps/common/NieRAutomata ./build.sh``. If you had already built the project, make sure to also use the ``--clean`` flag at the end of the line.
   You only need to specify the GAME_DIR if you have not already built the project, or if you are running a clean build.
   The ``--clean`` flag can be used at any time to cleanly rebuild the entire project.
5. If you haven't set up the build script to automatically copy the built .dll, you can find it in ``build/`` as ``xinput1_4.dll``. If you haven't already, also make sure to copy ``LodMod.ini`` to the root of the game directory. Even when setting the game directory in the build script, it will not automatically copy this.


# Thanks
Many thanks to Raincode for their https://github.com/Raincode/DeskCalc project, the parser code of which is used in LodMod for parsing math expressions. (is quite performant, and also has nice features like temporary variables)
