//
//  Menu.h
//  loopjongen
//
//  Created by Julian Geywitz on 25/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@interface Menu : NSObject

+ (void) printMenu:(Settings*) settings;
+ (void) executeAction:(int)action settings:(Settings*) settings;
+ (int) aquireUserInput;
+ (BOOL) shutdownApp;

@end
