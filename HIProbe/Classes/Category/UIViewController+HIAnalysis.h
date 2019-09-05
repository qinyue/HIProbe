//
//  HIAnalysisMethodInjection.h
//  HIProbe
//
//  Created by hushaohua on 9/4/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HIAnalysis)

- (void) analysisViewWillAppear:(BOOL)animated;
- (void) analysisViewWillDisappear:(BOOL)animated;

@end
