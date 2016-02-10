//
//  Server.m
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import "Server.h"
#import <NMSSH/NMSSH.h>

@implementation Server

- (NMSSHSession*) ConnectSsh {
  NMSSHSession* session = [NMSSHSession connectToHost:self.Ip withUsername:self.User];
  
  if (session.isConnected) {
    NSString* path = NSHomeDirectory();
    path = [path stringByAppendingString:@"/.ssh/"];
    path = [path stringByAppendingString:@"id_rsa"];
    
    [session authenticateByPublicKey:nil privateKey:path andPassword:nil];
    
    if (session.isAuthorized) {
      return session;
    }
    
    else {
      [NSException raise:@"Could not authorize at SSH server. Check your public/private keys." format:@"Server: %@, User: %@", self.Ip, self.User];
      return nil;
    }
  }
  else {
    [NSException raise:@"Could not connect to SSH server." format:@"Server: %@, User: %@", self.Ip, self.User];
    return nil;
  }
}

- (void) InteractiveSshSession {
  [self ConnectSsh];
}

@end
