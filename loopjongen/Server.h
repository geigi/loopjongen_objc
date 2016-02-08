//
//  Server.h
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Server : JSONModel

@property NSString *Ip;
@property NSString *ServerName;
@property NSString *User;

- (void) SshSession;

@end

@protocol Server;