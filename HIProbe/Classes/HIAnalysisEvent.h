//
//  HIAnalysisEvent.h
//  Analysis
//
//  Created by hushaohua on 9/2/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIAnalysisEvent : NSObject{
    NSString* _IDSelectorName;
    NSString* _userInfoSelectorName;
}

@property(nonatomic, copy) NSString* eventID;
@property(nonatomic, strong) id userInfo;

- (NSDictionary *) attributes;

@end
