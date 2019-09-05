//
//  HIAnalysisEventsLibrary.m
//  Analysis
//
//  Created by hushaohua on 9/2/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import "HIAnalysisEventsLibrary.h"
#import "NSObject+HIAnalysisInfo.h"
#import "HIAnalysisMethodInjection.h"
#import "HIAnalysisEvent.h"

static HIAnalysisEventsLibrary* stAnalysisEventsLibrary = nil;

@interface HIAnalysisEventsLibrary ()

@property(nonatomic, strong) NSDictionary* eventMappings;
@property(nonatomic, strong) HIAnalysisMethodInjection* injection;

@end

@implementation HIAnalysisEventsLibrary

+ (HIAnalysisEventsLibrary *) mainLibrary{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stAnalysisEventsLibrary = [[HIAnalysisEventsLibrary alloc] init];
    });
    return stAnalysisEventsLibrary;
}

- (id) init{
    self = [super init];
    if (self){
        
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        NSArray* paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"plist" inDirectory:@"AnalysisEventMappings"];
        for (NSString* filePath in paths) {
            NSDictionary* subDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
            [dict addEntriesFromDictionary:subDict];
        }
        self.eventMappings = [NSDictionary dictionaryWithDictionary:dict];
        
        self.injection = [[HIAnalysisMethodInjection alloc] initWithEventMapping:self.eventMappings];
        [self.injection startInject];
    }
    return self;
}

- (NSDictionary *) eventMappingsForTarget:(id)target{
    return [self eventMappingsForClass:[target class]];
}

- (NSDictionary *) eventMappingsForClass:(Class)class{
    if (class && NSStringFromClass(class)){
        NSDictionary* mapping = [self.eventMappings objectForKey:NSStringFromClass(class)];
        if (mapping){
            return mapping;
        }else{
            return [self eventMappingsForClass:[class superclass]];
        }
    }
    return nil;
}

#pragma mark -

- (NSString *)eventPageIDForTarget:(id)target{
    NSString* pageID = [[self eventMappingsForTarget:target] objectForKey:@"PageID"];
    pageID = [self plistValueForKey:pageID ofTarget:target args:nil];
    return pageID;
}


- (HIAnalysisEvent *) eventForPageCreateCountOfTarget:(id)target{
    NSDictionary* mappings = [self eventMappingsForTarget:target][@"CreateCount"];
    if (mappings == nil){
        return nil;
    }
    HIAnalysisEvent* event = [[HIAnalysisEvent alloc] init];
    if ([mappings isKindOfClass:[NSString class]]){
        event.eventID = [self plistValueForKey:(NSString *)mappings ofTarget:target args:nil];
    }else if ([mappings isKindOfClass:[NSDictionary class]]){
        event.eventID = [self plistValueForKey:mappings[@"ID"] ofTarget:target args:nil];
        event.userInfo = [self plistValueForKey:mappings[@"UserInfo"] ofTarget:target args:nil];;
    }
    return event;
}

- (HIAnalysisEvent *) eventForPageAppearCountOfTarget:(id)target{

    NSDictionary* mappings = [self eventMappingsForTarget:target][@"AppearCount"];
    if (mappings == nil){
        return nil;
    }
    HIAnalysisEvent* event = [[HIAnalysisEvent alloc] init];
    if ([mappings isKindOfClass:[NSString class]]){
        event.eventID = [self plistValueForKey:(NSString *)mappings ofTarget:target args:nil];
    }else if ([mappings isKindOfClass:[NSDictionary class]]){
        event.eventID = [self plistValueForKey:mappings[@"ID"] ofTarget:target args:nil];
        event.userInfo = [self plistValueForKey:mappings[@"UserInfo"] ofTarget:target args:nil];;
    }
    return event;
}

- (NSString *) plistValueForKey:(NSString *)key ofTarget:(id)target args:(id)args{
    if ([key isKindOfClass:[NSString class]]
        && [key hasPrefix:@"["]
        && [key hasSuffix:@"]"]){
        id value = [self returnValueForAction:[key substringWithRange:NSMakeRange(1, [key length] - 2)] ofTarget:target withArgument:args];
        return value;
    }else{
        return key;
    }
}

- (id) returnValueForAction:(NSString *)actionName ofTarget:(id)target withArgument:(id)argument{
    SEL action = NSSelectorFromString(actionName);
    if ([target respondsToSelector:action]){
        NSMethodSignature* methodSignature = [[target class] instanceMethodSignatureForSelector:action];
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        invocation.selector = action;
        invocation.target = target;
        if ([actionName hasSuffix:@":"]){
            [invocation setArgument:&argument atIndex:2];
        }
        [invocation invoke];
        
        if (!strcmp(methodSignature.methodReturnType, @encode(id))){
            id __unsafe_unretained returnValue;
            [invocation getReturnValue:&returnValue];
            return returnValue;
        }
    }
    return nil;
}

@end
