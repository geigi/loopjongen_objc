//
//  main.m
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "stdio.h"
#import "statics.m"
#import "Settings.h"
#import "Enums.m"
#import "Raspberry.h"
#import "Nas.h"
#import "Server.h"

BOOL Shutdown = false;

int aquireUserInput() {
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

void executeAction(int action, Settings *servers) {
   if (!servers) {
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
  
  if (category < servers.NasServers.count) {
    Server *server =[servers.NasServers objectAtIndex:category];
    NasAction nasAction = (NasAction)specificAction;
    Nas *nas = (Nas *)server;
    
    switch (nasAction) {
      case boot:
        //[nas BootNas];
        NSLog(@"Boot Nas");
        break;
        
      case halt:
        //[nas ShutdownNas];
        NSLog(@"Shutdown Nas");
        break;
        
      case sshNas:
        //[nas SshSession];
        NSLog(@"SSH Nas");
        break;
    }
  }
  else if (category < servers.NasServers.count + servers.RpiServers.count){
    Server *server =[servers.RpiServers objectAtIndex:(category - servers.NasServers.count)];
    RaspberryAction raspiAction = (RaspberryAction)specificAction;
    Raspberry *raspi = (Raspberry *)server;
    
    switch (raspiAction) {
      case restartServer:
        //[raspi RestartServer];
        NSLog(@"Restart Rpi");
        break;
        
      case restartAirplay:
        //[raspi RestartAirPlay];
        NSLog(@"Restart Airplay");
        break;
        
      case sshPi:
        //[raspi SshSession];
        NSLog(@"ssh Rpi");
        break;
    }
  }
  else {
    GeneralAction genAction = (GeneralAction)(action - ((servers.NasServers.count + servers.RpiServers.count) * 3));
    switch (genAction) {
      case restoreDefaults:
        NSLog(@"Restore Defaults");
        break;
        
      case editConfig:
        NSLog(@"Edit Config");
        break;
        
      case exitApp:
        Shutdown = true;
        break;
    }
  }
}

void printWelcome(Settings *servers) {
  printf("Server Manager %s\n", VERSION);
  printf("\n");
  
  if (!servers) {
    [NSException raise:@"No (valid) servers provided. Please check your config file." format:@"servers is nil"];
    
    return;
  }
  
  int menuEntry = 1;
  
  // foreach element in servers
  // for NAS, insert below
  printf(ANSI_COLOR_RED "NAS" ANSI_COLOR_RESET "\n");
  
  for (Nas *server in servers.NasServers) {
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
  for (Raspberry *server in servers.RpiServers) {
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

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    Settings* settings = [[Settings alloc] initWithJson:true];
    
    while (!Shutdown) {
      printWelcome(settings);
      
      int action = aquireUserInput();
      
      if (action > -1)
        executeAction(action, settings);
    }
    
  }
    return 0;
}
