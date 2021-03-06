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

#import <MobilyCore/MobilyUI.h>

/*--------------------------------------------------*/

typedef void(^MobilyStyleBlock)(id target);

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyStyle : NSObject< MobilyObject >

@property(nonatomic, readonly, strong) NSString* name;
@property(nonatomic, readonly, strong) MobilyStyle* parent;

+ (instancetype)styleWithName:(NSString*)name;
+ (instancetype)styleWithName:(NSString*)name block:(MobilyStyleBlock)block;
+ (instancetype)styleWithName:(NSString*)name parent:(MobilyStyle*)parent block:(MobilyStyleBlock)block;

- (instancetype)initWithName:(NSString*)name block:(MobilyStyleBlock)block;
- (instancetype)initWithName:(NSString*)name parent:(MobilyStyle*)parent block:(MobilyStyleBlock)block;

- (void)setup NS_REQUIRES_SUPER;

+ (void)unregisterStyleWithName:(NSString*)name;

@end

/*--------------------------------------------------*/

@interface UIResponder (MobilyStyle)

@property(nonatomic, readwrite, strong) IBInspectable MobilyStyle* moStyle;
@property(nonatomic, readwrite, strong) IBInspectable NSString* moStyleName;

@end

/*--------------------------------------------------*/
