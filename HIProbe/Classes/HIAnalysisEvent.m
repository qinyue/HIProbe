//
//  HIAnalysisEvent.m
//  Analysis
//
//  Created by hushaohua on 9/2/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import "HIAnalysisEvent.h"

@implementation HIAnalysisEvent

- (NSDictionary *) attributes{
    if ([self.userInfo isKindOfClass:[NSDictionary class]]){
        return self.userInfo;
    }else if (self.userInfo){
        return @{@"components" : self.userInfo};
    }else{
        return nil;
    }
}

@end
