FILE *fopen(const char *path, const char *mode);
int   stat(const char *path, struct stat *buf);
int   lstat(const char *path, struct stat *buf);
int   sysctlbyname(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen);
// syscall instead of libc
// int   access(const char *pathname, int mode);

BOOL allowAccess(NSString *filename) {
   NSArray *NotAllowedPathPrefixes =
   @[
   @"/bin/bash",
   @"/usr/bin",
   @"/usr/sbin",
   @"/usr/libexec/",
   // @"/usr/libexec/sftp-server",
   @"/private/var/",
   // @"/private/var/",
   @"/private/var/mobile/Library/SBSettings",
   @"/private/var/tmp/cydia.log",
   @"/Applications/",
   // @"/Applications/Cyren.app",
   @"/Library/MobileSubstrate",
   @"/System/Library/LaunchDaemons",
   @"/etc",
   @"/etc/apt"
   ];

   if (filename.length == 0) {
       return YES;
   }
   for (NSString *prefix in NotAllowedPathPrefixes) {
       if ([filename hasPrefix:prefix]) {
           return NO;
       }
   }
   return YES;
}

%hookf(FILE *, fopen, const char *path, const char *mode) {
    if (!strcmp(path, "/Applications/Cydia.app") ||
        !strcmp(path, "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
        !strcmp(path, "/bin/bash") ||
        !strcmp(path, "/usr/bin/sshd") ||
        !strcmp(path, "/etc/apt") ||
        !strcmp(path, "/usr/bin/ssh")) {
        return NULL;
    }
    return %orig;
}

%hookf(int, stat, const char *path, struct stat *buf) {
    if (!strcmp(path, "/Library/Frameworks/CydiaSubstrate.framework")) {
        return -1;
    }
    return %orig;
}

%hookf(int, lstat, const char *path, const char *mode) {
    if (!strcmp(path, "/Applications") || strstr(path, "/var/stash") || strstr(path, "/var/db/stash")) {
        return -1;
    }
    return %orig;
}

%hookf(int, sysctlbyname, const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen) {
    const char * sysctls[12] = {
        "security.mac.socket_enforce",
        "security.mac.pipe_enforce",
        "security.mac.system_enforce",
        "security.mac.vm_enforce",
        "security.mac.vnode_enforce",
        "security.mac.posixshm_enforce",
        "security.mac.sysvmsg_enforce",
        "security.mac.posixsem_enforce",
        "security.mac.device_enforce",
        "security.mac.proc_enforce",
        "security.mac.sysvshm_enforce",
        "security.mac.sysvsem_enforce"
    };
    int counter;
    for (counter = 0; counter < 12; counter++) {
        if (!strcmp(name, sysctls[counter])) {
            oldp = (void*)0xFAFAFAFA;
            return 0;
        }
    }
    return %orig;
}

// syscall instead of libc
// %hookf(int, access, const char *pathname, int mode) {
//    const char * filenames[18] = {
//        "/usr/lib/libmis.dylib",
//        "/pguntether",
//        "/System/Library/Caches/com.apple.xpcd/xpcd_cache.dylib",
//        "/panguaxe",
//        "/System/Library/LaunchDaemons/io.pangu.untether.plist",
//        "/evasi0n7",
//        "/taig/taig",
//        "/usr/lib/pangu_xpcd.dylib",
//        "/xuanyuansword",
//        "/System/Library/LaunchDaemons/io.pangu.axe.untether.plist",
//        "/xuanyuansword.installed",
//        "/panguaxe.installed",
//        "/System/Library/Caches/com.apple.dyld/enable-dylibs-to-overrie-c",
//        "/System/Library/LaunchDaemons/com.evad3rs.evasi0n7.untether.plis",
//        "/bin/bash",
//        "/bin/sh",
//        "/Applications/Cydia.app/Cydia",
//        "/usr/sbin/sshd"
//    };
//    int counter;
//    for (counter = 0; counter < 18; counter++) {
//        if (!strcmp(pathname, filenames[counter])) {
//            return -1;
//        }
//    }
//    return %orig;
//}


%hook NSFileManager
- (BOOL)fileExistsAtPath:(NSString *)path {
    if (!allowAccess(path)) {
        return NO;
    }
    return %orig;
}
%end

%hook SmartBeatUtil
+ (bool)isJailbroken {
        return NO;
}
+ (BOOL)fileExistsAtPath:(id)path {
    if (!allowAccess((NSString *)path)) {
        return NO;
    }
    return %orig;
}
+ (bool)isWritableAtPath:(id)path {
    NSString *strPath = (NSString *)path;
    if ([strPath isEqualToString:@"/private"]) {
       return NO;
    }
    return %orig;
}
%end

%hook AppsFlyerUtils
+ (bool)isJailBreakon {
        return NO;
}
%end
