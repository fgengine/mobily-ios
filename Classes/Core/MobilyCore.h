/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 fgengine(Alexander Trifonov)  */
/*                                                  */
/* Permission is hereby granted, free of charge,    */
/* to any person obtaining a copy of this software  */
/* and associated documentation files               */
/* (the "Software"), to deal in the Software        */
/* without restriction, including without           */
/* limitation the rights to use, copy, modify,      */
/* merge, publish, distribute, sublicense,          */
/* and/or sell copies of the Software, and to       */
/* permit persons to whom the Software is furnished */
/* to do so, subject to the following conditions:   */
/*                                                  */
/* The above copyright notice and this permission   */
/* notice shall be included in all copies or        */
/* substantial portions of the Software.            */
/*                                                  */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT        */
/* WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,        */
/* INCLUDING BUT NOT LIMITED TO THE WARRANTIES      */
/* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR     */
/* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   */
/* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR   */
/* ANY CLAIM, DAMAGES OR OTHER LIABILITY,           */
/* WHETHER IN AN ACTION OF CONTRACT, TORT OR        */
/* OTHERWISE, ARISING FROM, OUT OF OR IN            */
/* CONNECTION WITH THE SOFTWARE OR THE USE OR       */
/* OTHER DEALINGS IN THE SOFTWARE.                  */
/*                                                  */
/*--------------------------------------------------*/

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>

/*--------------------------------------------------*/

#import <objc/runtime.h>

/*--------------------------------------------------*/

#ifdef DEBUG
#   define MOBILY_DEBUG
#endif

/*--------------------------------------------------*/

#define MOBILY_DEBUG_LEVEL_ERROR                    0x01
#define MOBILY_DEBUG_LEVEL_WARNING                  0x02
#define MOBILY_DEBUG_LEVEL_INFO                     0x04
#define MOBILY_DEBUG_LEVEL_ALL                      (MOBILY_DEBUG_LEVEL_ERROR | MOBILY_DEBUG_LEVEL_WARNING | MOBILY_DEBUG_LEVEL_INFO)

/*--------------------------------------------------*/

#ifndef MOBILY_DEBUG_LEVEL
#   define MOBILY_DEBUG_LEVEL                       (MOBILY_DEBUG_LEVEL_ERROR | MOBILY_DEBUG_LEVEL_WARNING | MOBILY_DEBUG_LEVEL_INFO)
#endif

/*--------------------------------------------------*/

#if TARGET_IPHONE_SIMULATOR
#   define MOBILY_SIMULATOR
#else
#   define MOBILY_DEVICE
#endif

/*--------------------------------------------------*/

#if __has_feature(objc_arc)
#   define MOBILY_SAFE_AUTORELEASE(object)          object
#   define MOBILY_SAFE_RETAIN(object)               object
#   define MOBILY_SAFE_RELEASE(object)              object = nil
#   define MOBILY_SAFE_BRIDGE(class, object)        (__bridge class)object
#   define MOBILY_SAFE_DEALLOC                      /**/
#   define MOBILY_WEAK                              __weak
#   define MOBILY_UNSAFE                            __unsafe_unretained
#else
#   define MOBILY_SAFE_AUTORELEASE(object)          [object autorelease]
#   define MOBILY_SAFE_RETAIN(object)               [object retain]
#   define MOBILY_SAFE_RELEASE(object)              [object release]; object = nil
#   define MOBILY_SAFE_BRIDGE(class, object)        (class)object
#   define MOBILY_SAFE_DEALLOC                      [super dealloc]
#   define MOBILY_WEAK                              /**/
#   define MOBILY_UNSAFE                            __unsafe_unretained
#endif
#define MOBILY_SAFE_SETTER(object, value)           MOBILY_SAFE_RELEASE(object); object = MOBILY_SAFE_RETAIN(value)

/*--------------------------------------------------*/

#define MOBILY_SWAP(v1, v2)                         { id t = v1; v1 = v2; v2 = t; }
#define MOBILY_SWAP_SAFE(v1, v2)                    { id t = MOBILY_SAFE_RETAIN(v1); v1 = v2; v2 = t; MOBILY_SAFE_RELEASE(t); }

/*--------------------------------------------------*/
