//
//  HIAnalysisMethodInjection.m
//  HIProbe
//
//  Created by hushaohua on 9/4/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import "UIViewController+HIAnalysis.h"
#import "HIAnalysisManager.h"
#import "HIAnalysisEventsLibrary.h"
#import "NSObject+HIHook.h"
#import "HIAnalysisEvent.h"
#import "HIAnalysisHandler.h"

@implementation UIViewController (HIAnalysis)

+ (void) load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        [NSObject swizzlingSelector:@selector(viewDidLoad) toSelector:@selector(analysisViewDidLoad) inClass:class];
        [NSObject swizzlingSelector:@selector(viewWillAppear:) toSelector:@selector(analysisViewWillAppear:) inClass:class];
        [NSObject swizzlingSelector:@selector(viewWillDisappear:) toSelector:@selector(analysisViewWillDisappear:) inClass:class];
    });
}

- (void) analysisViewDidLoad{
    
    [self noteEventForCreate];
    [self analysisViewDidLoad];
}

- (void) analysisViewWillAppear:(BOOL)animated{
    [[HIAnalysisManager sharedManager].handler beginNotePage:[self eventPageID]];
    [self noteEventForAppear];
    [self analysisViewWillAppear:animated];
}

- (void) noteEventForCreate{
    HIAnalysisEvent* analysisEvent = [[HIAnalysisEventsLibrary mainLibrary] eventForPageCreateCountOfTarget:self];
    [[HIAnalysisManager sharedManager].handler noteEvent:analysisEvent.eventID userInfo:analysisEvent.attributes];
}

- (void) noteEventForAppear{
    HIAnalysisEvent* analysisEvent = [[HIAnalysisEventsLibrary mainLibrary] eventForPageAppearCountOfTarget:self];
    [[HIAnalysisManager sharedManager].handler noteEvent:analysisEvent.eventID userInfo:analysisEvent.attributes];
}

- (void) analysisViewWillDisappear:(BOOL)animated{
    [[HIAnalysisManager sharedManager].handler endNotePage:[self eventPageID]];
    [self analysisViewWillDisappear:animated];
}

- (NSString *)eventPageID{
    return [[HIAnalysisEventsLibrary mainLibrary] eventPageIDForTarget:self];
}

@end
