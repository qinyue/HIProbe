//
//  HAnalysisEventsHandler.m
//  HIProbe
//
//  Created by hushaohua on 9/14/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import "HIAnalysisManager.h"
#import "HIAnalysisHandler.h"

static HIAnalysisManager* stManager = nil;
@implementation HIAnalysisManager

+ (HIAnalysisManager *) sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stManager = [[HIAnalysisManager alloc] init];
    });
    return stManager;
}

@end
