//
//  Helpers.m
//  loopjongen
//
//  Created by Julian Geywitz on 25/02/16.
//  Copyright © 2016 Julian Geywitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Helpers.h"
#import "statics.m"

@implementation Helpers

+ (void) AppError:(NSString*) err {
  system("clear");
  
  printf(ANSI_COLOR_RED "%s\n" ANSI_COLOR_RESET, [err UTF8String]);
  printf("Press any key to return to the main menu");
  getchar();
}

+ (void) loadBar:(int)x n:(int)n r:(int)r w:(int)w {
  // Only update r times.
  if ( x % (n/r) != 0 ) return;
  
  // Calculuate the ratio of complete-to-incomplete.
  float ratio = x/(float)n;
  int   c     = ratio * w;
  
  // Show the percentage complete.
  printf("%3d%% [", (int)(ratio*100) );
  
  // Show the load bar.
  for (int x=0; x<c; x++)
    printf("=");
  
  for (int x=c; x<w; x++)
    printf(" ");
  
  // ANSI Control codes to go back to the
  // previous line and clear it.
  // printf("]\n33[F33[J");
  printf("]\r"); // Move to the first column
  fflush(stdout);
}

@end
