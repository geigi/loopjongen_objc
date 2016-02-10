//
//  Settings.h
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Nas.h"
#import "Raspberry.h"
#import "JSONModel.h"

@interface Settings : JSONModel

@property (strong, nonatomic) NSMutableArray<Nas> *NasServers;
@property (strong, nonatomic) NSMutableArray<Raspberry> *RpiServers;


- (id)initWithJson:(BOOL)load;

- (void) EditConfig;
- (void)RestoreDefaults;


@end
