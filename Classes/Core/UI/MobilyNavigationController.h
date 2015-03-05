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

#import "MobilyBuilder.h"
#import "MobilyTransitionController.h"

/*--------------------------------------------------*/

@interface MobilyNavigationController : UINavigationController< MobilyBuilderObject >

@property(nonatomic, readonly, assign, getter=isAppeared) BOOL appeared;
@property(nonatomic, readwrite, strong) MobilyTransitionController* transitionModal;
@property(nonatomic, readwrite, strong) MobilyTransitionController* transitionNavigation;

@property(nonatomic, readwrite, strong) id< MobilyEvent > eventDidLoad;
@property(nonatomic, readwrite, strong) id< MobilyEvent > eventDidUnload;
@property(nonatomic, readwrite, strong) id< MobilyEvent > eventWillAppear;
@property(nonatomic, readwrite, strong) id< MobilyEvent > eventDidAppear;
@property(nonatomic, readwrite, strong) id< MobilyEvent > eventWillDisappear;
@property(nonatomic, readwrite, strong) id< MobilyEvent > eventDidDisappear;

- (void)setNeedUpdate;
- (void)update;
- (void)clear;

@end

/*--------------------------------------------------*/
