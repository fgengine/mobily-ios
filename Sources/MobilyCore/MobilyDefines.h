/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 Mobily TEAM                   */
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
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>

/*--------------------------------------------------*/

#import <objc/runtime.h>

/*--------------------------------------------------*/

#include <tgmath.h>

/*--------------------------------------------------*/

#ifdef DEBUG
#   define MOBILY_DEBUG
#endif

/*--------------------------------------------------*/

#ifdef MOBILY_SOURCE
#   define MOBILY_REQUIRES_PROPERTY_DEFINITIONS     NS_REQUIRES_PROPERTY_DEFINITIONS
#else
#   define MOBILY_REQUIRES_PROPERTY_DEFINITIONS
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


#ifdef CGFLOAT_IS_DOUBLE
#   define MOBILY_EPSILON DBL_EPSILON
#else
#   define MOBILY_EPSILON MOBILY_EPSILON
#endif

/*--------------------------------------------------*/

#define MOBILY_COS(X) __tg_cos(__tg_promote1((X))(X))
#define MOBILY_SIN(X) __tg_sin(__tg_promote1((X))(X))
#define MOBILY_ATAN2(X, Y) __tg_atan2(__tg_promote2((X), (Y))(X), __tg_promote2((X), (Y))(Y))
#define MOBILY_POW(X, Y) __tg_pow(__tg_promote2((X), (Y))(X), __tg_promote2((X), (Y))(Y))
#define MOBILY_SQRT(X) __tg_sqrt(__tg_promote1((X))(X))
#define MOBILY_FABS(X) __tg_fabs(__tg_promote1((X))(X))
#define MOBILY_CEIL(X) __tg_ceil(__tg_promote1((X))(X))
#define MOBILY_FLOOR(X) __tg_floor(__tg_promote1((X))(X))

/*--------------------------------------------------*/
