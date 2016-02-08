//
//  Settings.h
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Nas.h"
#import "Server.h"
#import "JSONModel.h"

@interface Settings : JSONModel

@property (strong, nonatomic) NSMutableArray<Server> *Servers;

@end
