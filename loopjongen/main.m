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

Settings* LoadSettings() {
  Settings* settings = nil;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString* path = NSHomeDirectory();
  path = [path stringByAppendingString:@"/.loopjongen"];
  
  if ([fileManager fileExistsAtPath:path]){
    NSError* err = nil;
    NSString* json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    if (json == nil) {
      [NSException raise:@"JSON read failed." format:@"%@", [err localizedDescription]];
    }
    
    settings = [[Settings alloc] initWithString:json error:&err];
    
    if (settings == nil) {
      [NSException raise:@"JSON parse failed." format:@"%@", [err localizedDescription]];
    }
  }
  else {
    //write default settings to disk and parse it
    //show warning to adapt settings first
  }
  
  return settings;
}

//Propably never used
void SaveSettings(Settings* settings) {
  NSString* json = [settings toJSONString];
  NSString* path = NSHomeDirectory();
  path = [path stringByAppendingString:@"/.loopjongen"];
  
  [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
  
  NSError* err = nil;
  [json writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
  NSLog(@"%@", [err localizedDescription]);
}

void executeAction(int action, Settings *servers) {
   if (!servers) {
   [NSException raise:@"No (valid) servers provided. Please check your config file." format:@"servers is nil"];
   
   return;
   }
  
  if (action < 1) {
    [NSException raise:@"Invalid action, must be bigger than 1." format:@"action is %i",action];
  }
  
  int category = action / 3;
  int specificAction = action - (category * 3);
  
  if (category <= servers.NasServers.count) {
    Server *server =[servers.NasServers objectAtIndex:category];
    NasAction nasAction = (NasAction)specificAction;
    Nas *nas = (Nas *)server;
    
    switch (nasAction) {
      case boot:
        [nas BootNas];
        break;
        
      case halt:
        [nas ShutdownNas];
        break;
        
      case sshNas:
        [nas SshSession];
        break;
    }
  }
  else if (category <= servers.NasServers.count + servers.RpiServers.count){
    Server *server =[servers.RpiServers objectAtIndex:(category - servers.NasServers.count)];
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
        [raspi SshSession];
        break;
    }
  }
  else {
    //if bigger than servers
    //1
    //edit config file
    //2
    //restore default settings
    //3
    //exit application
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
    Settings* settings = LoadSettings();
    printWelcome(settings);
  }
    return 0;
}
