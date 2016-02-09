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

@implementation Settings
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

- (id)init {
  return [self initWithJson:false];
}

- (id)initWithJson:(BOOL)load {
  if (!(self = [super init]))
    return nil;
  
  if (load)
    return LoadSettings();
  else
    return self;
}

@end
