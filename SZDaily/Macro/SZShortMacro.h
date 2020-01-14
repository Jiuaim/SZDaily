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

#define UIColorHexA(_hex_, a) \
        UIColorRGBA((((_hex_) & 0xFF0000) >> 16), (((_hex_) & 0xFF00) >> 8), ((_hex_) & 0xFF), a)
#define UIColorHex(_hex_)   UIColorHexA(_hex_, 1.0)

#endif /* SZShortMacro_h */
