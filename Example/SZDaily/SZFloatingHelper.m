//
//  SZFloatingHelper.m
//  SZDaily_Example
//
//  Created by hsz on 2020/11/23.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZFloatingHelper.h"
#import <objc/runtime.h>
#import <Aspects/Aspects.h>

/*
 浮窗AOP无侵入添加
 */

void swizzleClassMethod(Class cls, SEL origSelector, SEL newSelector)
{
    if (!cls) return;
    Method originalMethod = class_getClassMethod(cls, origSelector);
    Method swizzledMethod = class_getClassMethod(cls, newSelector);
    
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    if (class_addMethod(metacls,
                        origSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* swizzing super class method, added if not exist */
        class_replaceMethod(metacls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(metacls,
                            newSelector,
                            class_replaceMethod(metacls,
                                                origSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}

void swizzleInstanceMethod(Class cls, SEL origSelector, SEL newSelector)
{
    if (!cls) {
        return;
    }
    /* if current class not exist selector, then get super*/
    Method originalMethod = class_getInstanceMethod(cls, origSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, newSelector);
    
    /* add selector if not exist, implement append with method */
    if (class_addMethod(cls,
                        origSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* replace class instance method, added if selector not exist */
        /* for class cluster , it always add new selector here */
        class_replaceMethod(cls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(cls,
                            newSelector,
                            class_replaceMethod(cls,
                                                origSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}

@implementation NSObject(Swizzle)
+ (void)swizzleClassMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    swizzleClassMethod(self.class, origSelector, newSelector);
}

- (void)swizzleInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    swizzleInstanceMethod(self.class, origSelector, newSelector);
}
@end

@interface SZFloatingHelper ()

@end

@implementation SZFloatingHelper

static NSArray *viewControllers;// 需要AOP的控制器
static SZFloatingHelper *helper;

+ (instancetype)shareHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[SZFloatingHelper alloc] init];
    });
    return helper;
}

+ (void)load {
    viewControllers = @[@"SZViewController", @"SZAutoTableHeaderHeightViewController"];
    
    /*
     方案1：aspect hook UIViewController的viewWillAppear：方法
     方案2：替换对应类的viewWillAppear：
     方案3：遍历查询到需要监控的UIScrollView，设置代理为当前浮窗类，浮窗类实现UIScrollViewDelegate对应方法
     */
//    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> userInfo){
//        NSString *vcs = NSStringFromClass([userInfo.instance class]);
//        if ([viewControllers containsObject:vcs]) {
//            [[SZFloatingHelper shareHelper] viewWillAppear:vcs];
//        }
//    } error:nil];
    
    NSArray *selectors = @[@"scrollViewWillBeginDragging:",
                           @"scrollViewDidEndDecelerating:",
                           @"scrollViewDidEndScrollingAnimation:",
                           @"scrollViewDidEndDragging:willDecelerate:",
                           @"viewWillAppear:"];
    
    for (NSString *vcs in viewControllers) {
        Class vcClass = NSClassFromString(vcs);
        if (!vcClass) continue;
        
        Protocol *protocal = objc_getProtocol("UIScrollViewDelegate");
        if (!class_conformsToProtocol(vcClass, protocal)) {
            class_addProtocol(vcClass, protocal);
            NSLog(@"%@ addDelegate", vcs);
        }
        
        for (int i = 0; i < selectors.count; i++) {
            NSString *swizzleSELS = [NSString stringWithFormat:@"sz_%@", selectors[i]];
            SEL originSEL = NSSelectorFromString(selectors[i]);
            SEL swizzleSEL = NSSelectorFromString(swizzleSELS);
            
            swizzleInstanceMethod(vcClass, originSEL, swizzleSEL);
        }
    }
}

- (void)viewWillAppear:(NSString *)curvcs {
    NSLog(@"%s", __func__);
}

- (void)willBeginScroll:(UIViewController *)parentVC {
    NSLog(@"%s", __func__);
}

- (void)didEndScroll:(UIViewController *)parentVC {
    NSLog(@"%s", __func__);
}

@end

@implementation UIViewController(Floating)

- (void)sz_viewWillAppear:(BOOL)animated {
    if ([self canPerformAction:@selector(sz_viewWillAppear:) withSender:nil]) {
        [self sz_viewWillAppear:animated];
    }
    [[SZFloatingHelper shareHelper] viewWillAppear:NSStringFromClass(self.class)];
}

- (void)sz_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self canPerformAction:@selector(sz_scrollViewWillBeginDragging:) withSender:nil]) {
        [self sz_scrollViewWillBeginDragging:scrollView];
    }
    [[SZFloatingHelper shareHelper] willBeginScroll:self];
}

- (void)sz_scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self canPerformAction:@selector(sz_scrollViewDidEndDecelerating:) withSender:nil]) {
        [self sz_scrollViewDidEndDecelerating:scrollView];
    }
    [[SZFloatingHelper shareHelper] didEndScroll:self];
}

- (void)sz_scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self canPerformAction:@selector(sz_scrollViewDidEndScrollingAnimation:) withSender:nil]) {
        [self sz_scrollViewDidEndScrollingAnimation:scrollView];
    }
    [[SZFloatingHelper shareHelper] didEndScroll:self];
}

- (void)sz_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self canPerformAction:@selector(sz_scrollViewDidEndDragging:willDecelerate:) withSender:nil]) {
        [self sz_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    if (decelerate == NO) {
        [[SZFloatingHelper shareHelper] didEndScroll:self];
    }
}

@end
