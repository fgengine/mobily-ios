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

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerView : UIView < MobilyObject >

@property(nonatomic, readwrite, strong) IBInspectable UIColor* color;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat size;
@property(nonatomic, readwrite, assign) IBInspectable BOOL hidesWhenStopped;
@property(nonatomic, readonly, assign, getter=isAnimating) BOOL animating;

- (void)setup NS_REQUIRES_SUPER;

- (void)startAnimating;
- (void)stopAnimating;

- (void)prepareAnimation NS_REQUIRES_SUPER;

@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewPlane : MobilySpinnerView
@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewCircleFlip : MobilySpinnerView
@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewBounce : MobilySpinnerView
@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewWave : MobilySpinnerView
@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewWanderingCubes : MobilySpinnerView
@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewPulse : MobilySpinnerView
@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewChasingDots : MobilySpinnerView
@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewThreeBounce : MobilySpinnerView
@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewCircle : MobilySpinnerView
@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerView9CubeGrid : MobilySpinnerView
@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewWordPress : MobilySpinnerView
@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewFadingCircle : MobilySpinnerView
@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewFadingCircleAlt : MobilySpinnerView

@property(nonatomic, readwrite, assign) IBInspectable NSUInteger numberOfCircle;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat factorCircle;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat factorRadius;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat minScale;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat minOpacity;

@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewArc : MobilySpinnerView
@end

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilySpinnerViewArcAlt : MobilySpinnerView
@end

/*--------------------------------------------------*/
