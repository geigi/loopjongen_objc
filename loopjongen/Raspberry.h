//
//  Raspberry.h
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import "Server.h"

@interface Raspberry : Server

- (void) RestartServer;
- (void) RestartAirPlay;



@end

@protocol Raspberry;