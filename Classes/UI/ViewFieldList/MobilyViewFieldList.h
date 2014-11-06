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

#import "MobilyViewFieldText.h"

/*--------------------------------------------------*/

@class MobilyViewFieldListItem;

/*--------------------------------------------------*/

@interface MobilyViewFieldList : MobilyViewFieldText< MobilyBuilderObject >

@property(nonatomic, readwrite, strong) NSArray* items;
@property(nonatomic, readwrite, strong) MobilyViewFieldListItem* selectedItem;

- (void)setSelectedItem:(MobilyViewFieldListItem*)selectedItem animated:(BOOL)animated;

@end

/*--------------------------------------------------*/

@interface MobilyViewFieldListItem : NSObject

@property(nonatomic, readwrite, strong) NSString* title;
@property(nonatomic, readwrite, strong) UIFont* font;
@property(nonatomic, readwrite, strong) UIColor* color;
@property(nonatomic, readwrite, strong) id value;

- (id)initWithTitle:(NSString*)title value:(id)value;
- (id)initWithTitle:(NSString*)title color:(UIColor*)color value:(id)value;
- (id)initWithTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color value:(id)value;

@end

/*--------------------------------------------------*/
