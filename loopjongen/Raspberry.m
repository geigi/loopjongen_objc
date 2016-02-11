//
//  Raspberry.m
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import "Raspberry.h"
#import "Server.h"
#import <NMSSH/NMSSH.h>

@implementation Raspberry

- (void) RestartServer {
  [self ExecuteCommand:@"sudo reboot"];
}

- (void) RestartAirPlay {
  [self ExecuteCommand:@"sudo /etc/init.d/shairport-sync stop;sudo /etc/init.d/shairport-sync start"];
}

@end
