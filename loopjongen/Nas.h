//
//  FreeNas.h
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import "Server.h"

@interface Nas : Server

@property (strong, nonatomic) NSString *MacAdress;
@property int BootDuration;
@property NSString *Protocol;
@property NSString *VolumeName;
@property NSString *MountPoint;

- (void) BootNas;
- (void) ShutdownNas;

@end

@protocol Nas;