//
//  Enums.m
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  boot,
  halt,
  sshNas
} NasAction;

typedef enum {
  restartServer,
  restartAirplay,
  sshPi
} RaspberryAction;

typedef enum {
  editConfig,
  restoreDefaults,
  exitApp
} GeneralAction;