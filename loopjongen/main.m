//
//  main.m
//  loopjongen
//
//  Created by Julian Geywitz on 07/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "stdio.h"
#import "Menu.h"
#import "Helpers.h"

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    Settings* settings = [[Settings alloc] initWithJson:true];
    
    while (![Menu shutdownApp]) {
      @try {
        [Menu printMenu:settings];
      
        int action = [Menu aquireUserInput];
      
        if (action > -1)
          [Menu executeAction:action settings:settings];
      }
      @catch (NSException* ex){
        NSString* message = [NSString stringWithFormat:@"Error: %@\n%@",[ex name], [ex reason]];
        [Helpers AppError:message];
      }
    }
    
  }
    return 0;
}
