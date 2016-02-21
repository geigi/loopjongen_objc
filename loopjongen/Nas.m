//
//  FreeNas.m
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import "Nas.h"
#import "statics.m"

@implementation Nas

- (void) BootNas {
  //Need WakeOnLan Library, then boot the nas via wol
  [NSException raise:@"Not implemented" format:@"Boot NAS"];
}

- (void) ShutdownNas {
  [self ExecuteCommand:@"shutdown -p now"];
}

- (void) MountVolume {
  NSMutableString* command = [NSMutableString stringWithFormat:@"osascript -e '%s'", MOUNT_VOLUME_SCRIPT];
  command =  (NSMutableString*)[command stringByReplacingOccurrencesOfString:@"Server" withString:self.ServerName];
  command =  (NSMutableString*)[command stringByReplacingOccurrencesOfString:@"VolumeName" withString:self.VolumeName];

  system([command UTF8String]);
}

- (void) UmountVolume {
  NSString* command = [NSString stringWithFormat:@"umount %@", self.MountPoint];
  system([command UTF8String]);
}

@end
