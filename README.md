# RunNint

RunNint is a collection of iOS tweaks that allow you to play various Nintendo apps (Fire Emblem Heroes, Miitomo, Pokémon Go) on a jailbroken device.

## Usage

- Until this is published, pre-build .deb packages should be in the `packages` folder in each tweak folder. These should work under 32-bit as well, but they are so far only tested on 64-bit devices. These can be installed with any usual .deb installer, such as Filza.
- Compile with THEOS, `make package FINALPACKAGE=1` in each tweak folder.

## Why
On a jailbroken iOS device, these applications will quit immediately after launching. This offers a method of being able to run these applications in spite of jailbreak detection. 

**I am not liable for any consequences you may incur by abusing this tweak or using it improperly, nor do I condone any such actions. The sole purpose of this tweak is such that a user with a jailbroken device may still play these games just as a user with a non-jailbroken device would.**

## Credits
Thanks to @leavez's [RunMario](https://github.com/leavez/RunMario) project, for the example and idea.

## Takeaways after Discontinuing
As of the time of editing this, I believe the games Super Mario Run and Miitomo are either discontinued or in the process of being discontinued, themselves. As for the others, particularly Fire Emblem Heroes and Fate Grand Order, the added security measures as of recent rely on the use of system calls within their own code. Although this shouldn't be permitted for applications in the App Store to begin with, it happened regardless and it forcibly halted the development of this tweak. Unlike normal function calls, system calls are functions that are located in kernel memory and thus can never be modified or hooked into. Therefore it is out of the scope of working with `THEOS`. The most recent commits to these respective directories ought to show the locations in the decrypted binaries where these system calls are, and it should be trivial at that point to overwrite those 4-8 bytes with effective `nop` instructions, so that they don't get called.

However, at that point it became too much of a hassle for me to even bother testing, so I just updated my device, removing my jailbreak, so I could play the games.
