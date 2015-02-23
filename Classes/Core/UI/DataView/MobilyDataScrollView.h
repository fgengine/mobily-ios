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

#import "MobilyData.h"
#import "MobilyBuilder.h"

/*--------------------------------------------------*/

typedef NS_OPTIONS(NSUInteger, MobilyDataScrollViewPosition) {
    MobilyDataScrollViewPositionNone = 0,
    MobilyDataScrollViewPositionTop = 1 << 0,
    MobilyDataScrollViewPositionCenteredVertically = 1 << 1,
    MobilyDataScrollViewPositionBottom = 1 << 2,
    MobilyDataScrollViewPositionLeft = 1 << 3,
    MobilyDataScrollViewPositionCenteredHorizontally = 1 << 4,
    MobilyDataScrollViewPositionRight = 1 << 5
};

/*--------------------------------------------------*/

@protocol MobilyDataScrollRefreshView;

/*--------------------------------------------------*/

@interface MobilyDataScrollView : UIScrollView< MobilyDataWidget, MobilyBuilderObject >

@property(nonatomic, readwrite, assign) BOOL bouncesTop;
@property(nonatomic, readwrite, assign) BOOL bouncesLeft;
@property(nonatomic, readwrite, assign) BOOL bouncesRight;
@property(nonatomic, readwrite, assign) BOOL bouncesBottom;

@property(nonatomic, readwrite, strong) IBOutlet UIView< MobilyDataScrollRefreshView >* pullToRefreshView;
@property(nonatomic, readwrite, assign) CGFloat pullToRefreshHeight;

@property(nonatomic, readwrite, strong) IBOutlet UIView< MobilyDataScrollRefreshView >* pullToLoadView;
@property(nonatomic, readwrite, assign) CGFloat pullToLoadHeight;

- (void)scrollToItem:(id< MobilyDataItem >)item scrollPosition:(MobilyDataScrollViewPosition)scrollPosition animated:(BOOL)animated;

- (void)updateSuperviewConstraints;

- (void)showPullToRefreshAnimated:(BOOL)animated complete:(MobilyDataWidgetCompleteBlock)complete;
- (void)hidePullToRefreshAnimated:(BOOL)animated complete:(MobilyDataWidgetCompleteBlock)complete;

- (void)showPullToLoadAnimated:(BOOL)animated complete:(MobilyDataWidgetCompleteBlock)complete;
- (void)hidePullToLoadAnimated:(BOOL)animated complete:(MobilyDataWidgetCompleteBlock)complete;

@end

/*--------------------------------------------------*/

extern NSString* MobilyDataScrollViewPullToRefreshTriggered;
extern NSString* MobilyDataScrollViewPullToLoadTriggered;

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyDataScrollRefreshViewState) {
    MobilyDataScrollRefreshViewStateIdle = 0,
    MobilyDataScrollRefreshViewStatePull,
    MobilyDataScrollRefreshViewStateRelease,
    MobilyDataScrollRefreshViewStateLoading
};

/*--------------------------------------------------*/

@protocol MobilyDataScrollRefreshView < MobilyObject >

@property(nonatomic, readwrite, weak) UIView< MobilyDataWidget >* widget;
@property(nonatomic, readwrite, assign) MobilyDataScrollRefreshViewState state;

- (void)didIdle;
- (void)didPull;
- (void)didRelease;
- (void)didLoading;

@end

/*----------------------------------------------*/

@interface MobilyDataScrollRefreshView : UIView< MobilyDataScrollRefreshView, MobilyBuilderObject >



@end

/*--------------------------------------------------*/
