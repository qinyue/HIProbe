//
//  NSObject+HAnalysisInfo.m
//  HIProbe
//
//  Created by hushaohua on 9/17/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import "NSObject+HIAnalysisInfo.h"
#import <objc/runtime.h>

static char* stPropertyAnalysisUserInfo;
static char* stPropertyAnalysisEventID;

@implementation NSObject (HIAnalysisInfo)

- (NSDictionary *) analysisUserInfo{
    return objc_getAssociatedObject(self, &stPropertyAnalysisUserInfo);
}

- (void) setAnalysisUserInfo:(NSDictionary *)analysisUserInfo{
    NSDictionary* userInfo = [self analysisUserInfo];
    if (userInfo != analysisUserInfo){
        objc_setAssociatedObject(self, &stPropertyAnalysisUserInfo, analysisUserInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (NSString *) analysisEventID{
    return objc_getAssociatedObject(self, &stPropertyAnalysisEventID);
}

- (void) setAnalysisEventID:(NSString *)analysisEventID{
    NSString* eventId = [self analysisEventID];
    if (eventId != analysisEventID){
        objc_setAssociatedObject(self, &stPropertyAnalysisEventID, analysisEventID, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

@end
