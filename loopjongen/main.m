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
  
  NSString* path = @"~/.loopjongen";
  
  if ([fileManager fileExistsAtPath:path]){
    NSString* json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSError* err = nil;
    
    settings = [[Settings alloc] initWithString:json error:&err];
  }
  
  return nil;
}

void SaveSettings(Settings* settings) {
  NSString* json = [settings toJSONString];
  NSString* path = NSHomeDirectory();
  path = [path stringByAppendingString:@"/.loopjongen"];
  
  [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
  
  NSError* err = nil;
  [json writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
  NSLog([err localizedDescription]);
}

void executeAction(int action, Settings *servers) {
  // for 1-3, first element, for 4-6 second, ...
  // devide action by 3 and use result as index
  /* if (!servers) {
   [NSException raise:@"No (valid) servers provided. Please check your config file." format:@"servers is nil"];
   
   return;
   } */
  
  if (action < 1) {
    [NSException raise:@"Invalid action, must be bigger than 1." format:@"action is %i",action];
  }
  
  int category = action / 3;
  int specificAction = action - (category * 3);
  
  if (category <= servers.Servers.count) {
    Server *server =[servers.Servers objectAtIndex:category];
    if ([server isKindOfClass:[Nas class]]) {
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
          //[nas SshSession];
          break;
      }
    }
    else if ([server isKindOfClass:[Raspberry class]]) {
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
          //[raspi SshSession];
          break;
      }
    }
    else {
      [NSException raise:@"Invalid object in Servers list" format:@"%@",[servers.Servers objectAtIndex:category]];
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
  
  /* if (!servers) {
    [NSException raise:@"No (valid) servers provided. Please check your config file." format:@"servers is nil"];
    
    return;
  } */
  
  int menuEntry = 1;
  
  // foreach element in servers
  // if NAS, insert below
  
  printf(ANSI_COLOR_RED "NAS" ANSI_COLOR_RESET "\n");
  printf(ANSI_COLOR_GREEN "Server-IP: " "\n");
  printf(ANSI_COLOR_GREEN "Server-MAC: " "\n");
  printf(ANSI_COLOR_GREEN "User: " "\n");
  printf(ANSI_COLOR_GREEN "Volume to mount: " "\n");
  printf(ANSI_COLOR_GREEN "Mountpoint: " "\n" ANSI_COLOR_RESET);
  printf("1. boot & mount" "\n");
  printf("2. unmount & shutdown" "\n");
  printf("3. SSH" "\n");
  
  printf("\n");
  
  // if Raspi, insert below
  
  printf(ANSI_COLOR_RED "RASPBERRY PI" ANSI_COLOR_RESET "\n");
  printf(ANSI_COLOR_GREEN "Server-IP: " "\n");
  printf(ANSI_COLOR_GREEN "User: " "\n" ANSI_COLOR_RESET);
  printf("4. restart Pi" "\n");
  printf("5. restart AirPlay" "\n");
  printf("6. SSH" "\n");
  
  printf("\n");
  
  // at the end
  
  printf(ANSI_COLOR_RED "GENERAL" ANSI_COLOR_RESET "\n");
  printf("7. edit config" "\n");
  printf("8. restore default settings" "\n");
  printf(ANSI_COLOR_MAGENTA "9. EXIT" "\n" ANSI_COLOR_RESET);
}

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    //printWelcome(nil);
    Settings* s = [[Settings alloc] init];
    
    s.Servers = [[NSMutableArray<Server> alloc] initWithObjects:[[Nas alloc] init],[[Raspberry alloc] init],nil];
    
    ((Nas*)s.Servers[0]).MacAdress = @"test";
    
    SaveSettings(s);
  }
    return 0;
}
