# Dmg2Pkg

A great deal of the macOS apps provided on the Net are DMG files, that contain a single app at the root of the volume. Then, one must drag manually the app to the Applications folder to install it. This makes the process of installing these apps cumbersome when they must be imported into a deployment system (say, [Jamf Pro](https://www.jamf.com)) as these can't import directly the DMG and work with it… The DMG must be converted first.

There are many tools that can easily convert a DMG to a PKG format that is easy to import in Jamf Pro, like [AutoPkgr](https://github.com/lindegroup/autopkgr/), but they can be a bit complex to deal with and they have their limits, i.e. downloading the DMG if it's located behind a paywall. [quickpkg](https://github.com/scriptingosx/quickpkg/) is another great tool, but I wanted to find a fast way to perform batch conversion of DMG files, and also be able to make conversion as easy as dropping the files in a folder. Thus, Make DMGs from PKGs here.

## How it works

1. Download and install [quickpkg](https://github.com/scriptingosx/quickpkg/). Ensure that the quickpkg command is in your $PATH!
2. Download the _Dmg2Pkg.sh_ script.
3. Install this script where you want, and don't forget to _chmod 755_ it.
4. Change the variables in the script. If you don't, it will create a new _Make_DMG_From_PKG_ folder in _/Users/_Shared_.
5. Move your DMG file in the **Source_DMGs** folder.
6. Run the script.
7. If everything works properly, new PKGs file should be spit in the _Packages_ folder and the DMG should move in the _Processed_DMGs_ folder automatically.

## But wait, there's more!

Let's make things a bit more automatic!

1. Get the Launchagent file (_net.gete.dmg2pkg.plist_).
2. Install it in _~/Library/LaunchAgents_.
3. Launch the file with : `launchctl load ~/Library/LaunchAgents/net.gete.dmg2pkg.plist`
4. Move your DMG file in the **Source_DMGs** folder.
5. Wait for a few seconds, and the new PKG files should appear in the _Packages_ folder and the DMG should move in the _Processed_DMGs_ folder automatically.
