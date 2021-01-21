//
//  SZShortMacro.h
//  Pods
//
//  Created by hsz on 2020/1/7.
//

#ifndef SZShortMacro_h
#define SZShortMacro_h


#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#ifdef DEBUG
    #define NSLog(format, ...)          printf("\n[%s] %s [第%d行]\n%s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])
#else
    #define NSLog(format, ...)
#endif


#endif /* SZShortMacro_h */
