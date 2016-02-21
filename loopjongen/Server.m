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

- (void) ExecuteCommand:(NSString*) command {
  NMSSHSession* session = [self ConnectSsh];
  NSError *err = nil;
  
  [session.channel execute:command error:&err];
  
  if (err != nil) {
    NSLog(@"Failed to execute SSH command, because: %@", [err localizedDescription]);
  }
  
  [session disconnect];
}

- (void) InteractiveSshSession {
  NSString* command = @"ssh ";
  command = [command stringByAppendingString:self.User];
  command = [command stringByAppendingString:@"@"];
  command = [command stringByAppendingString:self.Ip];
  
  system([command UTF8String]);
}

@end
