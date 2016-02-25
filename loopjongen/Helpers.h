//
//  Helpers.h
//  loopjongen
//
//  Created by Julian Geywitz on 25/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helpers : NSObject

+ (void) AppError:(NSString*) err;
+ (void) loadBar:(int)x n:(int)n r:(int)r w:(int)w;

@end
