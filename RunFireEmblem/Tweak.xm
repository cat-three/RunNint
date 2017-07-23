#include <Foundation/Foundation.h>
#include <substrate.h>

// syscall instead of libc
// note, actual syscall is represented as "stat64" (#define SYS_stat64 338)
// int stat(const char *restrict path, struct stat *restrict buf)

// syscall instead of libc
// %hookf(int, stat, const char *restrict path, struct stat *restrict buf) {
//    const char * filenames[21] = {
//        "/Applications/Cydia.app",
//        "/Applications/RockApp.app",
//        "/Applications/Icy.app",
//        "/usr/sbin/sshd",
//        "/usr/bin/sshd",
//        "/usr/libexec/sftp-server",
//        "/Applications/WinterBoard.app",
//        "/Applications/SBSettings.app",
//        "/Applications/MxTube.app",
//        "/Applications/IntelliScreen.app",
//        "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
//        "/Applications/FakeCarrier.app",
//        "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
//        "/private/var/lib/apt",
//        "/Applications/blackra1n.app",
//        "/private/var/stash",
//        "/private/var/mobile/Library/SBSettings/Themes",
//        "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
//        "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
//        "/private/var/tmp/cydia.log",
//        "/private/var/lib/cydia"
//    };
//    int counter;
//    for (counter = 0; counter < 21; counter++) {
//        if (!strcmp(path, filenames[counter])) {
//            return -1;
//        }
//    }
//    return %orig;
//}

%hook NSFileManager
- (BOOL)fileExistsAtPath:(NSString *)path {
    const char * filenames[23] = {
        "/bin/bash",  // from before
        "/bin/sh",    // from before
        "/Applications/Cydia.app", // from before, also in new list
        "/Applications/RockApp.app",
        "/Applications/Icy.app",
        "/usr/sbin/sshd",
        "/usr/bin/sshd",
        "/usr/libexec/sftp-server",
        "/Applications/WinterBoard.app",
        "/Applications/SBSettings.app",
        "/Applications/MxTube.app",
        "/Applications/IntelliScreen.app",
        "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
        "/Applications/FakeCarrier.app",
        "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
        "/private/var/lib/apt",
        "/Applications/blackra1n.app",
        "/private/var/stash",
        "/private/var/mobile/Library/SBSettings/Themes",
        "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
        "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
        "/private/var/tmp/cydia.log",
        "/private/var/lib/cydia"
    };
    int counter;
    for (counter = 0; counter < 23; counter++) {
        if (!strcmp([path UTF8String], filenames[counter])) {
            return NO;
        }
    }
    return %orig;
}
%end

%hook NSBundle
- (id)objectForInfoDictionaryKey:(NSString *)key {
  if ([key isEqualToString:@"SignerIdentity"]) {
    return 0;
  }
  return %orig;
}
%end

%hook CLSAnalyticsMetadataController
+ (BOOL)hostJailbroken {
  return NO;
}
%end
