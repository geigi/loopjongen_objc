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

void AppError(NSString *err) {
  system("clear");
  
  printf(ANSI_COLOR_RED "%s\n" ANSI_COLOR_RESET, [err UTF8String]);
  printf("Press any key to return to the main menu");
  getchar();
}

void loadBar(int x, int n, int r, int w)
{
  // Only update r times.
  if ( x % (n/r) != 0 ) return;
  
  // Calculuate the ratio of complete-to-incomplete.
  float ratio = x/(float)n;
  int   c     = ratio * w;
  
  // Show the percentage complete.
  printf("%3d%% [", (int)(ratio*100) );
                 
  // Show the load bar.
  for (int x=0; x<c; x++)
  printf("=");

  for (int x=c; x<w; x++)
  printf(" ");

  // ANSI Control codes to go back to the
  // previous line and clear it.
  // printf("]\n33[F33[J");
  printf("]\r"); // Move to the first column
  fflush(stdout);
}

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
        [nas BootNas];
        
        for (int i = 0; i < nas.BootDuration; i++) {
          loadBar(i, nas.BootDuration, 100, 70);
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
  else if (category < servers.NasServers.count + servers.RpiServers.count){
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
        [raspi InteractiveSshSession];
        break;
    }
  }
  else {
    GeneralAction genAction = (GeneralAction)(action - ((servers.NasServers.count + servers.RpiServers.count) * 3));
    switch (genAction) {
      case restoreDefaults:
        [servers RestoreDefaults];
        break;
        
      case editConfig:
        [servers EditConfig];
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
      @try {
        printWelcome(settings);
      
        int action = aquireUserInput();
      
        if (action > -1)
          executeAction(action, settings);
      }
      @catch (NSException* ex){
        NSString* message = [NSString stringWithFormat:@"Error: %@\n%@",[ex name], [ex reason]];
        AppError(message);
      }
    }
    
  }
    return 0;
}
