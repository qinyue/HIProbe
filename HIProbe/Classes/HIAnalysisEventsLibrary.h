//
//  HIAnalysisEventsLibrary.h
//  Analysis
//
//  Created by hushaohua on 9/2/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HIAnalysisEvent;
@interface HIAnalysisEventsLibrary : NSObject

@property(nonatomic, readonly) NSDictionary* eventMappings;

+ (HIAnalysisEventsLibrary *) mainLibrary;

- (NSString *)eventPageIDForTarget:(id)target;

- (HIAnalysisEvent *) eventForPageAppearCountOfTarget:(id)target;
- (HIAnalysisEvent *) eventForPageCreateCountOfTarget:(id)target;

@end
