//
//  Enums.m
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  boot=1,
  halt=2,
  sshNas=3
} NasAction;

typedef enum {
  restartServer=1,
  restartAirplay=2,
  sshPi=3
} RaspberryAction;

typedef enum {
  editConfig=1,
  restoreDefaults=2,
  exitApp=0
} GeneralAction;