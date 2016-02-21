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

#define DEFAULT_CONFIG "{\n\
  \"NasServers\": [{\n\
    \"ServerName\": \"serv\",\n\
    \"MacAdress\": \"aa:bb:aa:bb:aa:bb\",\n\
    \"MountPoint\": \"/Volumes/Storage\",\n\
    \"Protocol\": \"afp\",\n\
    \"VolumeName\": \"Storage\",\n\
    \"BootDuration\": 180,\n\
    \"Ip\": \"192.168.178.26\",\n\
    \"User\": \"root\"\n\
  }],\n\
  \"RpiServers\": [{\n\
    \"Ip\": \"192.168.178.21\",\n\
    \"ServerName\": \"raspberry\",\n\
    \"User\": \"pi\"\n\
  }]\n\
}"

#define MOUNT_VOLUME_SCRIPT "tell application \"Finder\" to mount volume \"afp://Server/VolumeName\""