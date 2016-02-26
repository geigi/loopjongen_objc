//
//  Settings.m
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"
#import "Raspberry.h"
#import "statics.m"

@implementation Settings
- (void) EditConfig {
  system("nano ~/.loopjongen");
  
  Settings* newSettings = [self LoadSettings];
  
  self.NasServers = newSettings.NasServers;
  self.RpiServers = newSettings.RpiServers;
}

- (void) RestoreDefaults {
  BOOL validAnswer = false;
  
  while (!validAnswer) {
    system("clear");
    
    printf("Do you really want to restore your settings? (y/n)" "\n");
    char answer = getchar();
    
    switch (answer) {
      case 'y':
        validAnswer = true;
        break;
        
      case 'n':
        return;
        break;
    }
  }
  
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  
  NSString *path = NSHomeDirectory();
  path = [path stringByAppendingString:@"/.loopjongen"];
  
  if (![fileManager fileExistsAtPath:path]){
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
  }
  
  NSError* err;
  NSString* content = [[NSString alloc] initWithUTF8String:DEFAULT_CONFIG];
  
  
  BOOL writeSucess = [content writeToFile:path atomically:YES encoding:NSStringEncodingConversionAllowLossy error:&err];
  if (!writeSucess)
    [NSException raise:@"Could not write default settings file." format:@"%@", [err localizedDescription]];

  Settings* defaultSettings = [self LoadSettings];
  
  self.NasServers = defaultSettings.NasServers;
  self.RpiServers = defaultSettings.RpiServers;
}

- (Settings*) LoadSettings {
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
      printf("JSON parse failed. Reason: %s\nPress enter to edit your settings file now.", [[err localizedDescription] UTF8String]);
      getchar();
      system("nano ~/.loopjongen");
      
      settings = [self LoadSettings];
      //[NSException raise:@"JSON parse failed." format:@"%@", [err localizedDescription]];
    }
  }
  else {
    [self RestoreDefaults];
    printf("No settings file was present.\nPress enter to edit the default configuration now");
    getchar();
    
    system("nano ~/.loopjongen");
    
    settings = [self LoadSettings];
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

- (id)init {
  return [self initWithJson:false];
}

- (id)initWithJson:(BOOL)load {
  if (!(self = [super init]))
    return nil;
  
  if (load)
    return [self LoadSettings];
  else
    return self;
}

@end
