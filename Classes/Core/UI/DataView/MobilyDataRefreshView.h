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

#import "MobilyData.h"

/*--------------------------------------------------*/

@class MobilyDataView;

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyDataRefreshViewType) {
    MobilyDataRefreshViewTypeTop,
    MobilyDataRefreshViewTypeBottom,
    MobilyDataRefreshViewTypeLeft,
    MobilyDataRefreshViewTypeRight
};

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyDataRefreshViewState) {
    MobilyDataRefreshViewStateIdle,
    MobilyDataRefreshViewStatePull,
    MobilyDataRefreshViewStateRelease,
    MobilyDataRefreshViewStateLoading,
    MobilyDataRefreshViewStateDisable
};

/*----------------------------------------------*/

@interface MobilyDataRefreshView : UIView< MobilyBuilderObject >

@property(nonatomic, readwrite, assign) MobilyDataRefreshViewType type;
@property(nonatomic, readonly, weak) MobilyDataView* view;
@property(nonatomic, readonly, weak) NSLayoutConstraint* constraintOffset;
@property(nonatomic, readonly, weak) NSLayoutConstraint* constraintSize;
@property(nonatomic, readonly, assign) MobilyDataRefreshViewState state;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat size;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat threshold;

- (void)setup NS_REQUIRES_SUPER;

- (void)didIdle;
- (void)didPull;
- (void)didRelease;
- (void)didLoading;

@end

/*--------------------------------------------------*/
