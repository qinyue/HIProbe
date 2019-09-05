//
//  HIAnalysisMethodInjection.m
//  HIProbe
//
//  Created by hushaohua on 11/14/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import "HIAnalysisMethodInjection.h"
#import <objc/runtime.h>
#import <NSObject+HIAnalysisInfo.h>
#import "HIAnalysisManager.h"
#import "HIAnalysisEvent.h"
#import "HIAnalysisHandler.h"

@interface HIAnalysisEvent (Plist)

@property(nonatomic, copy) NSString* IDSelectorName;
@property(nonatomic, copy) NSString* userInfoSelectorName;

@end

@implementation HIAnalysisEvent(Plist)

- (void) setIDSelectorName:(NSString *)IDSelectorName{
    if (_IDSelectorName != IDSelectorName){
        _IDSelectorName = IDSelectorName;
    }
}

- (void) setUserInfoSelectorName:(NSString *)userInfoSelectorName{
    if (_userInfoSelectorName != userInfoSelectorName){
        _userInfoSelectorName = userInfoSelectorName;
    }
}

- (NSString *) userInfoSelectorName{
    return _userInfoSelectorName;
}

- (NSString *) IDSelectorName{
    return _IDSelectorName;
}

+ (id) eventWithControlEventItem:(id)info{
    
    HIAnalysisEvent* event = [[HIAnalysisEvent alloc] init];
    
    if ([info isKindOfClass:[NSString class]]){
        [event setIDsWithKey:info];
    }else if ([info isKindOfClass:[NSDictionary class]]){
        [event setIDsWithKey:info[@"ID"]];
        [event setUserInfosWithKey:info[@"UserInfo"]];
    }
    return event;
}

- (void) setIDsWithKey:(NSString *)key{
    self.IDSelectorName = [[self class] selectorNameForKey:key];
    if (!self.IDSelectorName){
        self.eventID = key;
    }
}

- (void) setUserInfosWithKey:(NSString *)key{
    self.userInfoSelectorName = [[self class] selectorNameForKey:key];
    if (!self.userInfoSelectorName){
        self.userInfo = key;
    }
}

+ (BOOL) isControlEventItem:(id)info matchToSelector:(SEL)selector inClass:(Class)class{
    if ([info isKindOfClass:[NSString class]]){
        return [[self class] isKey:info matchToSelector:selector inClass:class];
    }else if ([info isKindOfClass:[NSDictionary class]]){
        NSString* IDString = [info objectForKey:@"ID"];
        NSString* userInfoString = [info objectForKey:@"UserInfo"];
        
        return [[self class] isKey:IDString matchToSelector:selector inClass:class] && [[self class] isKey:userInfoString matchToSelector:selector inClass:class];
    }
    return NO;
}

+ (BOOL) isKey:(NSString *)keyName matchToSelector:(SEL)selector inClass:(Class)class{
    NSString* injectSelectorName = [[self class] selectorNameForKey:keyName];
    if (injectSelectorName){
        SEL injectSelector = NSSelectorFromString(injectSelectorName);
        Method injectMethod = class_getInstanceMethod(class, injectSelector);
        Method method = class_getInstanceMethod(class, selector);
        if (!injectMethod || !method){
            return NO;
        }
        
        if (method_getNumberOfArguments(injectMethod) != method_getNumberOfArguments(method)){
            return NO;
        }
    }
    
    return YES;
}

+ (NSString *) selectorNameForKey:(NSString *)key{
    if ([key hasPrefix:@"["]
        && [key hasSuffix:@"]"]){
        return [key substringWithRange:NSMakeRange(1, key.length - 2)];
    }
    return nil;
}

@end


typedef NS_ENUM(NSInteger, HAnalysisDataType){
    HAnalysisDataTypeUnsupported
    , HAnalysisDataTypeId
    , HAnalysisDataTypeVoid
    , HAnalysisDataTypeInt
};

void performEventSelectorWithoutArg(HIAnalysisEvent* event, id target){
    if (event.IDSelectorName){
        SEL selector = NSSelectorFromString(event.IDSelectorName);
        IMP imp = class_getMethodImplementation([target class], selector);
        event.eventID = ((NSString*(*)(id, SEL))imp)(target, selector);
    }
    
    if (event.eventID && event.userInfoSelectorName){
        SEL selector = NSSelectorFromString(event.userInfoSelectorName);
        if (selector){
            IMP imp = class_getMethodImplementation([target class], selector);
            event.userInfo = ((NSString*(*)(id, SEL))imp)(target, selector);
        }
    }
}

void performEventSelectorWith1Arg(HIAnalysisEvent* event, id target, void* arg0){
    if (event.IDSelectorName){
        SEL selector = NSSelectorFromString(event.IDSelectorName);
        IMP imp = class_getMethodImplementation([target class], selector);
        event.eventID = ((NSString*(*)(id, SEL, void*))imp)(target, selector, arg0);
    }
    
    if (event.eventID && event.userInfoSelectorName){
        SEL selector = NSSelectorFromString(event.userInfoSelectorName);
        IMP imp = class_getMethodImplementation([target class], selector);
        event.userInfo = ((NSString*(*)(id, SEL, void*))imp)(target, selector, arg0);
    }
}

void performEventSelectorWith2Args(HIAnalysisEvent* event, id target, void* arg0, void* arg1){
    if (event.IDSelectorName){
        SEL selector = NSSelectorFromString(event.IDSelectorName);
        IMP imp = class_getMethodImplementation([target class], selector);
        event.eventID = ((NSString*(*)(id, SEL, void*, void*))imp)(target, selector, arg0, arg1);
    }
    
    if (event.eventID && event.userInfoSelectorName){
        SEL selector = NSSelectorFromString(event.userInfoSelectorName);
        if (selector){
            IMP imp = class_getMethodImplementation([target class], selector);
            event.userInfo = ((NSString*(*)(id, SEL, void*, void*))imp)(target, selector, arg0, arg1);
        }
    }
}

HAnalysisDataType getAnalysisDataType(const char *type){
    HAnalysisDataType dataType = HAnalysisDataTypeUnsupported;
    if (type) {
        switch (type[0]) {
            case _C_ID:
                dataType = HAnalysisDataTypeId;
                break;
            case _C_CHR: // char
            case _C_UCHR: // unsigned char
            case _C_SHT: // short
            case _C_USHT: // unsigned short
            case _C_INT: // int
            case _C_UINT: // unsigned int
            case _C_LNG: // long
            case _C_ULNG: // unsigned long
            case _C_LNG_LNG: // long long
            case _C_ULNG_LNG: // unsigned long long
            case _C_FLT: // float
            case _C_DBL: // double
            case _C_BOOL: //bool TODO:
                dataType = HAnalysisDataTypeInt;
                break;
            case _C_VOID:
                dataType = HAnalysisDataTypeVoid;
                break;
            default:
                break;
        }
    }
    return dataType;
}

@interface HIAnalysisMethodInjection ()

@property(nonatomic, strong) NSDictionary* eventMappings;

@end


@implementation HIAnalysisMethodInjection

- (id) initWithEventMapping:(NSDictionary *)mapping{
    self = [super init];
    if (self){
        self.eventMappings = mapping;
    }
    return self;
}

#pragma mark -

- (void) startInject{
    [self.eventMappings enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self swizzingClass:key eventMapping:obj];
    }];
}

- (void) swizzingClass:(NSString *)className eventMapping:(NSDictionary *)mappings{
    NSDictionary* customEvents = mappings[@"ControlEvents"];
    __weak typeof(self) weakSelf = self;
    [customEvents enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [weakSelf swizzingMethod:key toImp:obj inclass:className];
    }];
}


- (BOOL) swizzingMethod:(NSString *)methodName toImp:(NSDictionary *)impDict inclass:(NSString *)className{
    
    SEL selector = NSSelectorFromString(methodName);
    Class class = NSClassFromString(className);
    
    if (![HIAnalysisEvent isControlEventItem:impDict matchToSelector:selector inClass:class]){
        return NO;
    }
    
    Method method = class_getInstanceMethod(class, selector);
    int argsCount = method_getNumberOfArguments(method);
    switch (argsCount) {
        case 2:
            [self swizzingMethodWithoutArgs:methodName toImp:impDict inclass:className];
            break;
        case 3:
            [self swizzingMethodWith1Arg:methodName toImp:impDict inclass:className];
            break;
        case 4:
            [self swizzingMethodWith2Arg:methodName toImp:impDict inclass:className];
            break;
            
        default:
            return NO;
    }
    return YES;
}

#pragma mark - one argument

- (BOOL) swizzingMethodWith2Arg:(NSString *)methodName toImp:(NSDictionary *)impDict inclass:(NSString *)className{
    
    SEL selector = NSSelectorFromString(methodName);
    Class class = NSClassFromString(className);
    Method method = class_getInstanceMethod(class, selector);
    IMP imp = class_getMethodImplementation(class, selector);
    char* type = method_copyReturnType(method);
    HAnalysisDataType returnType = getAnalysisDataType(type);
    free(type);

    __weak typeof(self) weakSelf = self;
    
    switch (returnType) {
        case HAnalysisDataTypeVoid:{
            void(^block)(id object, void* arg, void* arg1) = ^(id object, void* arg, void* arg1) {
                HIAnalysisEvent* event = [HIAnalysisEvent eventWithControlEventItem:impDict];
                performEventSelectorWith2Args(event, object, arg, arg1);
                [weakSelf noteEvent:event];
                ((void(*)(id, SEL, void*, void*))imp)(object, selector, arg, arg1);
            };
            method_setImplementation(method, imp_implementationWithBlock(block));
        }
            break;
        case HAnalysisDataTypeInt:{
            long(^block)(id object, void* arg, void* arg1) = ^long(id object, void* arg, void* arg1) {
                HIAnalysisEvent* event = [HIAnalysisEvent eventWithControlEventItem:impDict];
                performEventSelectorWith2Args(event, object, arg, arg1);
                [weakSelf noteEvent:event];
                return ((long(*)(id, SEL, void*, void*))imp)(object, selector, arg, arg1);
            };
            method_setImplementation(method, imp_implementationWithBlock(block));
        }
            break;
        case HAnalysisDataTypeId:{
            id(^block)(id object, void* arg, void* arg1) = ^id(id object, void* arg, void* arg1) {
                HIAnalysisEvent* event = [HIAnalysisEvent eventWithControlEventItem:impDict];
                performEventSelectorWith2Args(event, object, arg, arg1);
                [weakSelf noteEvent:event];
                return ((id(*)(id, SEL, void*, void*))imp)(object, selector, arg, arg1);
            };
            method_setImplementation(method, imp_implementationWithBlock(block));
        }
            break;
            
        default:
            return NO;
    }
    
    return YES;
}

#pragma mark - one argument

- (BOOL) swizzingMethodWith1Arg:(NSString *)methodName toImp:(NSDictionary *)impDict inclass:(NSString *)className{
    
    SEL selector = NSSelectorFromString(methodName);
    Class class = NSClassFromString(className);
    Method method = class_getInstanceMethod(class, selector);
    IMP imp = class_getMethodImplementation(class, selector);
    char* type = method_copyReturnType(method);
    HAnalysisDataType returnType = getAnalysisDataType(type);
    free(type);
    __weak typeof(self) weakSelf = self;
    switch (returnType) {
        case HAnalysisDataTypeVoid:{
            void(^block)(id object, void* arg) = ^(id object, void* arg) {
                HIAnalysisEvent* event = [HIAnalysisEvent eventWithControlEventItem:impDict];
                performEventSelectorWith1Arg(event, object, arg);
                [weakSelf noteEvent:event];
                ((void(*)(id, SEL, void*))imp)(object, selector, arg);
            };
            method_setImplementation(method, imp_implementationWithBlock(block));
        }
            break;
        case HAnalysisDataTypeInt:{
            long(^block)(id object, void* arg) = ^long(id object, void* arg) {
                HIAnalysisEvent* event = [HIAnalysisEvent eventWithControlEventItem:impDict];
                performEventSelectorWith1Arg(event, object, arg);
                [weakSelf noteEvent:event];
                return ((long(*)(id, SEL, void* arg))imp)(object, selector, arg);
            };
            method_setImplementation(method, imp_implementationWithBlock(block));
        }
            break;
        case HAnalysisDataTypeId:{
            id(^block)(id object, void* arg) = ^id(id object, void* arg) {
                HIAnalysisEvent* event = [HIAnalysisEvent eventWithControlEventItem:impDict];
                performEventSelectorWith1Arg(event, object, arg);
                [weakSelf noteEvent:event];
                return ((id(*)(id, SEL, void* arg))imp)(object, selector, arg);
            };
            method_setImplementation(method, imp_implementationWithBlock(block));
        }
            break;
            
        default:
            return NO;
    }
    
    return YES;
}

#pragma mark - no argment

- (BOOL) swizzingMethodWithoutArgs:(NSString *)methodName toImp:(NSDictionary *)impDict inclass:(NSString *)className{
    
    SEL selector = NSSelectorFromString(methodName);
    Class class = NSClassFromString(className);
    Method method = class_getInstanceMethod(class, selector);
    IMP imp = class_getMethodImplementation(class, selector);
    char* type = method_copyReturnType(method);
    HAnalysisDataType returnType = getAnalysisDataType(type);
    free(type);

    __weak typeof(self) weakSelf = self;
    switch (returnType) {
        case HAnalysisDataTypeVoid:{
            void(^block)(id object) = ^(id object) {
                HIAnalysisEvent* event = [HIAnalysisEvent eventWithControlEventItem:impDict];
                performEventSelectorWithoutArg(event, object);
                [weakSelf noteEvent:event];
                ((void(*)(id, SEL))imp)(object, selector);
            };
            method_setImplementation(method, imp_implementationWithBlock(block));
        }
            break;
        case HAnalysisDataTypeInt:{
            long(^block)(id object) = ^long(id object) {
                HIAnalysisEvent* event = [HIAnalysisEvent eventWithControlEventItem:impDict];
                performEventSelectorWithoutArg(event, object);
                [weakSelf noteEvent:event];
                return ((long(*)(id, SEL))imp)(object, selector);
            };
            method_setImplementation(method, imp_implementationWithBlock(block));
        }
            break;
        case HAnalysisDataTypeId:{
            id(^block)(id object) = ^id(id object) {
                HIAnalysisEvent* event = [HIAnalysisEvent eventWithControlEventItem:impDict];
                performEventSelectorWithoutArg(event, object);
                [weakSelf noteEvent:event];
                return ((id(*)(id, SEL))imp)(object, selector);
            };
            method_setImplementation(method, imp_implementationWithBlock(block));
        }
            break;
            
        default:
            return NO;
    }
    
    return YES;
}

#pragma mark - 

- (void) noteEvent:(HIAnalysisEvent *)event{
    [[HIAnalysisManager sharedManager].handler noteEvent:event.eventID userInfo:event.attributes];
}

@end

