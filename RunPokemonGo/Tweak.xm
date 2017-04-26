FILE *fopen(const char *path, const char *mode);
int   stat(const char *path, struct stat *buf);
int   lstat(const char *path, struct stat *buf);

BOOL allowAccess(NSString *filename) {
   NSArray *NotAllowedPathPrefixes =
   @[
   @"/bin",
   @"/usr/bin",
   @"/usr/sbin",
   @"/etc/apt",
   @"/etc/ssh/sshd_config",
   @"/usr/bin/sshd",
   @"/usr/sbin/sshd",
   @"/usr/libexec/sftp-server",
   @"/usr/libexec/ssh-keysign",
   @"/private/var/lib",
   @"/private/var/stash",
   @"/private/var/mobile/Library/SBSettings",
   @"/private/var/tmp/cydia.log",
   @"/var/log/syslog",
   @"/Applications/",
   @"/Library/MobileSubstrate",
   @"/System/Library/LaunchDaemons"
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
    if (!strcmp(path, "/bin/bash")) {
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

%hook UIApplication
- (BOOL)canOpenURL:(NSURL *)url {
    if (url && [[url scheme] hasPrefix:@"cydia"]) {
        return 0;
    } else {
        return %orig;
    }
}
%end

%hook NSFileManager
- (BOOL)fileExistsAtPath:(NSString *)path {
    if (!allowAccess(path)) {
        return NO;
    } 
    return %orig; 
}
%end

%hook USParametersProvider
- (id)isJailbroken {
    return [NSNumber numberWithBool:NO];
}
%end
