//
//  statics.m
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VERSION "0.1"

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"

#define DEFAULT_CONFIG "{\
\"Freenas\": {\
\"Ip\": \"192.168.178.26\",\
\"Mac\": \"aa:bb:aa:bb:aa:bb\",\
\"User\": \"root\",\
\"BootDuration\": \"180\",\
\"Protocol\": \"afp\",\
\"ServerName\": \"serv\",\
\"VolumeName\": \"Storage\",\
\"MountPoint\": \"/Volumes/Storage\"\
},\
\"Raspberry\": {\
\"Ip\": \"192.168.178.21\",\
\"User\": \"pi\",\
\"ServerName\": \"raspberry\"\\
}\
}"