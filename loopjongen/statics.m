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
  \"NasServers\": [{\
    \"ServerName\": \"serv\",\
    \"MacAdress\": \"aa:bb:aa:bb:aa:bb\",\
    \"MountPoint\": \"\/Volumes\/Storage\",\
    \"Protocol\": \"afp\",\
    \"VolumeName\": \"Storage\",\
    \"BootDuration\": 180,\
    \"Ip\": \"192.168.178.26\",\
    \"User\": \"root\"\
  }],\
  \"RpiServers\": [{\
    \"Ip\": \"192.168.178.21\",\
    \"ServerName\": \"raspberry\",\
    \"User\": \"pi\"\
  }]\
}"