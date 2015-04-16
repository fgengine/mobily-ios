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

#import <Mobily/MobilyButton.h>
#import <Mobily/MobilyCG.h>

/*--------------------------------------------------*/

@interface MobilyButton () {
    __weak UILabel* _titleLabel;
    __weak UIImageView* _imageView;
}

@end

/*--------------------------------------------------*/

@implementation MobilyButton

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

#pragma mark Init / Free

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _titleLabel = self.titleLabel;
    _imageView = self.imageView;
}

- (void)dealloc {
    self.objectName = nil;
    self.objectParent = nil;
    self.objectChilds = nil;
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    if(_objectChilds.count > 0) {
        return [_objectChilds unionWithArrays:self.subviews, nil];
    }
    return self.subviews;
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andAddingObject:objectChild];
        [self addSubview:(UIView*)objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild];
        [self removeSubview:(UIView*)objectChild];
    }
}

- (void)willLoadObjectChilds {
}

- (void)didLoadObjectChilds {
}

- (id< MobilyBuilderObject >)objectForName:(NSString*)name {
    return [MobilyBuilderForm object:self forName:name];
}

- (id< MobilyBuilderObject >)objectForSelector:(SEL)selector {
    return [MobilyBuilderForm object:self forSelector:selector];
}

#pragma mark Property

- (void)setImageAlignment:(MobilyButtonImageAlignment)imageAlignment {
    if(_imageAlignment != imageAlignment) {
        _imageAlignment = imageAlignment;
        [self setNeedsLayout];
    }
}

#pragma mark UIButton

- (CGSize)sizeThatFits:(CGSize __unused)size {
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    CGSize result = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    CGSize imageSize = CGSizeZero;
    NSString* title = self.currentTitle;
    if(title != nil) {
        titleSize = [title implicitSizeWithFont:_titleLabel.font lineBreakMode:_titleLabel.lineBreakMode];
        titleSize.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right;
        titleSize.height += self.titleEdgeInsets.top + self.titleEdgeInsets.bottom;
    }
    UIImage* image = self.currentImage;
    if(image != nil) {
        imageSize = image.size;
        imageSize.width += self.imageEdgeInsets.left + self.imageEdgeInsets.right;
        imageSize.height += self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
    }
    switch(_imageAlignment) {
        case MobilyButtonImageAlignmentLeft:
        case MobilyButtonImageAlignmentRight:
            result.width += imageSize.width + titleSize.width;
            result.height += MAX(imageSize.height, titleSize.height);
            break;
        case MobilyButtonImageAlignmentTop:
        case MobilyButtonImageAlignmentBottom:
            result.width += MAX(imageSize.width, titleSize.width);
            result.height += imageSize.height + titleSize.height;
            break;
    }
    result.width += self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    result.height += self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    return result;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect result = contentRect;
    UIImage* image = self.currentImage;
    if(image != nil) {
        CGSize imageSize = image.size;
        imageSize.width += self.imageEdgeInsets.left + self.imageEdgeInsets.right;
        imageSize.height += self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
        CGRect imageRect = CGRectZero;
        CGRect titleRect = CGRectZero;
        switch(_imageAlignment) {
            case MobilyButtonImageAlignmentLeft: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.width, CGRectMinXEdge); break;
            case MobilyButtonImageAlignmentRight: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.width, CGRectMaxXEdge); break;
            case MobilyButtonImageAlignmentTop: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.height, CGRectMinYEdge); break;
            case MobilyButtonImageAlignmentBottom: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.height, CGRectMaxYEdge); break;
        }
        titleRect = UIEdgeInsetsInsetRect(titleRect, [self titleEdgeInsets]);
        result = titleRect;
    }
    return result;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect result = CGRectZero;
    UIImage* image = self.currentImage;
    if(image != nil) {
        CGSize imageSize = image.size;
        imageSize.width += self.imageEdgeInsets.left + self.imageEdgeInsets.right;
        imageSize.height += self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
        CGRect imageRect = CGRectZero;
        CGRect titleRect = CGRectZero;
        switch(_imageAlignment) {
            case MobilyButtonImageAlignmentLeft: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.width, CGRectMinXEdge); break;
            case MobilyButtonImageAlignmentRight: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.width, CGRectMaxXEdge); break;
            case MobilyButtonImageAlignmentTop: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.height, CGRectMinYEdge); break;
            case MobilyButtonImageAlignmentBottom: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.height, CGRectMaxYEdge); break;
        }
        imageRect = UIEdgeInsetsInsetRect(imageRect, self.imageEdgeInsets);
        imageRect = CGRectMakeCenterPoint(CGRectGetCenterPoint(imageRect), imageSize.width, imageSize.height);
        result = imageRect;
    }
    return result;
}

@end

/*--------------------------------------------------*/
