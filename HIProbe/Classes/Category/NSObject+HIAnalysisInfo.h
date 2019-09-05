//
//  NSObject+HAnalysisInfo.h
//  HIProbe
//
//  Created by hushaohua on 9/17/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HIAnalysisInfo)

@property(copy, nonatomic) NSString* analysisEventID;
@property(strong, nonatomic) NSDictionary* analysisUserInfo;

@end
