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
#define MOBILY_SOURCE
/*--------------------------------------------------*/

#import <MobilyStyle.h>

/*--------------------------------------------------*/

@interface MobilyStyle ()

@property(nonatomic, readonly, copy) MobilyStyleBlock block;

+ (NSMutableDictionary*)_registeredStyles;

- (void)_applyWithTarget:(id)target;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStyle

#pragma mark Synthesize

@synthesize name = _name;
@synthesize parent = _parent;
@synthesize block = _block;

#pragma mark Init / Free

+ (instancetype)styleWithName:(NSString*)name {
    return [self.class _registeredStyles][name];
}

+ (instancetype)styleWithName:(NSString*)name block:(MobilyStyleBlock)block {
    return [[self alloc] initWithName:name block:block];
}

+ (instancetype)styleWithName:(NSString*)name parent:(MobilyStyle*)parent block:(MobilyStyleBlock)block {
    return [[self alloc] initWithName:name parent:parent block:block];
}

- (instancetype)initWithName:(NSString*)name block:(MobilyStyleBlock)block {
    return [self initWithName:name parent:nil block:block];
}

- (instancetype)initWithName:(NSString*)name parent:(MobilyStyle*)parent block:(MobilyStyleBlock)block {
    self = [super init];
    if(self != nil) {
        _name = name;
        _parent = parent;
        _block = block;
        [self setup];
    }
    return self;
}

- (void)setup {
    if(_name.length > 0) {
        [self.class _registeredStyles][_name] = self;
    }
}

#pragma mark Public

+ (void)unregisterStyleWithName:(NSString*)name {
    [[self.class _registeredStyles] removeObjectForKey:name];
}

#pragma mark Private

+ (NSMutableDictionary*)_registeredStyles {
    static NSMutableDictionary* styles = nil;
    if(styles == nil) {
        styles = [NSMutableDictionary dictionary];
    }
    return styles;
}

- (void)_applyWithTarget:(id)target {
    if(_parent != nil) {
        [_parent _applyWithTarget:target];
    }
    if(_block != nil) {
        _block(target);
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#import <objc/runtime.h>

/*--------------------------------------------------*/

static char const* const MobilyStyleKey = "mobilyStyle";

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIResponder (MobilyStyle)

- (void)setMobilyStyle:(MobilyStyle*)mobilyStyle {
    MobilyStyle* currentStyle = objc_getAssociatedObject(self, MobilyStyleKey);
    if(currentStyle != mobilyStyle) {
        objc_setAssociatedObject(self, MobilyStyleKey, mobilyStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if(mobilyStyle != nil) {
            [mobilyStyle _applyWithTarget:self];
        }
    }
}

- (MobilyStyle*)mobilyStyle {
    return objc_getAssociatedObject(self, MobilyStyleKey);
}

- (void)applyMobilyStyleWithName:(NSString*)styleName {
    self.mobilyStyle = [MobilyStyle styleWithName:styleName];
}

- (void)applyMobilyStyle:(MobilyStyle*)style {
    self.mobilyStyle = style;
}

@end

/*--------------------------------------------------*/
