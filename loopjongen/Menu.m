//
//  Menu.m
//  loopjongen
//
//  Created by Julian Geywitz on 25/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import "Menu.h"
#import "Enums.m"
#import "statics.m"
#import "Helpers.h"

@implementation Menu
static BOOL Shutdown = false;

+ (void) printMenu:(Settings*) settings {
  printf("Server Manager %s\n", VERSION);
  printf("\n");
  
  if (!settings) {
    [NSException raise:@"No (valid) servers provided. Please check your config file." format:@"servers is nil"];
    
    return;
  }
  
  int menuEntry = 1;
  
  // foreach element in servers
  // for NAS, insert below
  printf(ANSI_COLOR_RED "NAS" ANSI_COLOR_RESET "\n");
  
  for (Nas *server in settings.NasServers) {
    printf(ANSI_COLOR_GREEN "Server-IP: %s" "\n", [server.Ip UTF8String]);
    printf(ANSI_COLOR_GREEN "Server-MAC: %s" "\n", [server.MacAdress UTF8String]);
    printf(ANSI_COLOR_GREEN "User: %s" "\n", [server.User UTF8String]);
    printf(ANSI_COLOR_GREEN "Volume to mount: %s" "\n", [server.VolumeName UTF8String]);
    printf(ANSI_COLOR_GREEN "Mountpoint: %s" "\n" ANSI_COLOR_RESET, [server.MountPoint UTF8String]);
    
    printf("%i. boot & mount" "\n", menuEntry);
    menuEntry++;
    printf("%i. unmount & shutdown" "\n", menuEntry);
    menuEntry++;
    printf("%i. SSH" "\n", menuEntry);
    menuEntry++;
    
    printf("\n");
  }
  
  // for Raspi, insert below
  printf(ANSI_COLOR_RED "RASPBERRY PI" ANSI_COLOR_RESET "\n");
  for (Raspberry *server in settings.RpiServers) {
    printf(ANSI_COLOR_GREEN "Server-IP: %s" "\n", [server.Ip UTF8String]);
    printf(ANSI_COLOR_GREEN "User: %s" "\n" ANSI_COLOR_RESET, [server.User UTF8String]);
    printf("%i. restart Pi" "\n", menuEntry);
    menuEntry++;
    printf("%i. restart AirPlay" "\n", menuEntry);
    menuEntry++;
    printf("%i. SSH" "\n", menuEntry);
    menuEntry++;
    
    printf("\n");
  }
  
  // at the end
  printf(ANSI_COLOR_RED "GENERAL" ANSI_COLOR_RESET "\n");
  printf("%i. edit config" "\n", menuEntry);
  menuEntry++;
  printf("%i. restore default settings" "\n", menuEntry);
  printf(ANSI_COLOR_MAGENTA "0. EXIT" "\n" ANSI_COLOR_RESET);
}

+ (void) executeAction:(int) action settings:(Settings*) settings {
  if (!settings) {
    [NSException raise:@"No (valid) servers provided. Please check your config file." format:@"servers is nil"];
    
    return;
  }
  
  if (action < 0) {
    [NSException raise:@"Invalid action, must be bigger than 1." format:@"action is %i",action];
  }
  
  if (action == 0) {
    Shutdown = true;
    return;
  }
  
  int category = (action - 1) / 3;
  int specificAction = action - (category * 3);
  
  if (category < settings.NasServers.count) {
    Server *server =[settings.NasServers objectAtIndex:category];
    NasAction nasAction = (NasAction)specificAction;
    Nas *nas = (Nas *)server;
    
    switch (nasAction) {
      case boot:
        [nas BootNas];
        
        for (int i = 0; i < nas.BootDuration; i++) {
          [Helpers loadBar:i n:nas.BootDuration r:100 w:70];
          [NSThread sleepForTimeInterval:0.5f];
        }
        
        [nas MountVolume];
        break;
        
      case halt:
        [nas UmountVolume];
        [nas ShutdownNas];
        break;
        
      case sshNas:
        [nas InteractiveSshSession];
        break;
    }
  }
  else if (category < settings.NasServers.count + settings.RpiServers.count){
    Server *server =[settings.RpiServers objectAtIndex:(category - settings.NasServers.count)];
    RaspberryAction raspiAction = (RaspberryAction)specificAction;
    Raspberry *raspi = (Raspberry *)server;
    
    switch (raspiAction) {
      case restartServer:
        [raspi RestartServer];
        break;
        
      case restartAirplay:
        [raspi RestartAirPlay];
        break;
        
      case sshPi:
        [raspi InteractiveSshSession];
        break;
    }
  }
  else {
    GeneralAction genAction = (GeneralAction)(action - ((settings.NasServers.count + settings.RpiServers.count) * 3));
    switch (genAction) {
      case restoreDefaults:
        [settings RestoreDefaults];
        break;
        
      case editConfig:
        [settings EditConfig];
        break;
        
      case exitApp:
        Shutdown = true;
        break;
    }
  }
}

+ (int) aquireUserInput {
  char option[3];
  int convertedOption = -1;
  
  printf("\nYour Choice: ");
  fgets(option, 4, stdin);
  if (sscanf(option, "%i", &convertedOption) == 1) {
    return convertedOption;
  }
  else {
    return -1;
  }
}

+ (BOOL) shutdownApp {
  return Shutdown;
}

@end
