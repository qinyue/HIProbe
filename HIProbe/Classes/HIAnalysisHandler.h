//
//  HAnalysisProtocol.h
//  HIProbe
//
//  Created by hushaohua on 9/14/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HIAnalysisHandler <NSObject>

- (void) beginNotePage:(NSString *)pageId;
- (void) endNotePage:(NSString *)pageId;

- (void) noteEvent:(NSString *)eventId;
- (void) noteEvent:(NSString *)eventId userInfo:(NSDictionary *)userInfo;
- (void) noteEvent:(NSString *)eventId patameter:(NSString *)patameter;

@end
