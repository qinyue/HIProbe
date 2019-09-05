//
//  HIAnalysisMethodInjection.h
//  HIProbe
//
//  Created by hushaohua on 11/14/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIAnalysisMethodInjection : NSObject

- (id) initWithEventMapping:(NSDictionary *)mapping;

- (void) startInject;

@end
