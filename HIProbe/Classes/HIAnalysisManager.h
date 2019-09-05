//
//  HAnalysisEventsHandler.h
//  HIProbe
//
//  Created by hushaohua on 9/14/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HIAnalysisManager;
@protocol HIAnalysisHandler;

@interface HIAnalysisManager : NSObject

+ (HIAnalysisManager *) sharedManager;

@property(nonatomic, strong) id<HIAnalysisHandler> handler;

@end
