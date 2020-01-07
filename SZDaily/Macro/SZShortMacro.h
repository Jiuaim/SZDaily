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


#endif /* SZShortMacro_h */
