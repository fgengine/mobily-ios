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

#import "DemoDataScrollViewController.h"

/*--------------------------------------------------*/

@implementation DemoDataScrollViewController

- (void)setup {
    [super setup];
    
    self.title = @"DataScrollView";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.dataRootListContainer = [[MobilyDataVerticalListContainer alloc] init];
    self.dataListContainer1 = [[MobilyDataVerticalListContainer alloc] init];
    self.dataListContainer2 = [[MobilyDataVerticalListContainer alloc] init];
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for(NSUInteger i = 0; i < 21; i++) {
        MobilyDataItem* hItem = [MobilyDataItem dataItemWithIdentifier:@"Static" data:[NSString stringWithFormat:@"S1 #%d", (int)i]];
        if((i % 4) == 0) {
            hItem.allowsSnapToEdge = YES;
            hItem.zOrder = 1.0f;
        }
        [_dataListContainer1 appendItem:hItem];
        
        MobilyDataItem* svItem = [MobilyDataItem dataItemWithIdentifier:@"Swipe" data:[NSString stringWithFormat:@"S2 #%d", (int)i]];
        if((i % 4) == 0) {
            svItem.allowsSnapToEdge = YES;
            svItem.zOrder = 1.0f;
        }
        [_dataListContainer2 appendItem:svItem];
    }
    [_dataRootListContainer appendContainer:_dataListContainer1];
    [_dataRootListContainer appendContainer:_dataListContainer2];
    
    [_dataScrollView registerIdentifier:@"Static" withViewClass:[DemoDataScrollViewItemView class]];
    [_dataScrollView registerIdentifier:@"Swipe" withViewClass:[DemoDataScrollViewItemSwipeView class]];

    [_dataScrollView setPullToRefreshView:[[MobilyDataScrollRefreshView alloc] init]];
    [_dataScrollView setPullToRefreshHeight:64.0f];
    [_dataScrollView setPullToLoadView:[[MobilyDataScrollRefreshView alloc] init]];
    [_dataScrollView setPullToLoadHeight:64.0f];
    [_dataScrollView registerEventWithBlock:^id(id sender, id object) {
        [_dataScrollView hidePullToRefreshAnimated:YES complete:nil];
        return nil;
    } forKey:MobilyDataScrollViewTriggeredPullToRefresh];
    
    [_dataScrollView registerEventWithBlock:^id(id sender, id object) {
        [_dataScrollView hidePullToLoadAnimated:YES complete:nil];
        return nil;
    } forKey:MobilyDataScrollViewTriggeredPullToLoad];

    [_dataScrollView setContainer:_dataRootListContainer];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoDataScrollViewItemView

+ (CGSize)sizeForItem:(id< MobilyDataItem >)item availableSize:(CGSize)size {
    if(size.width < size.height) {
        return CGSizeMake(size.width, 50.0f);
    }
    return CGSizeMake(50.0f, size.height);
}

- (void)prepareForUse {
    [super prepareForUse];
    
    self.rootView.backgroundColor = (self.item.allowsSnapToEdge) ? [UIColor blueColor] : [UIColor greenColor];
    _textView.text = self.item.data;
}

- (void)prepareForUnuse {
    [super prepareForUnuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self updateColors];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self updateColors];
}

- (void)updateColors {
    if(self.selected == YES) {
        _textView.backgroundColor = [UIColor redColor];
    } else if(self.highlighted == YES) {
        _textView.backgroundColor = [UIColor orangeColor];
    } else {
        _textView.backgroundColor = [UIColor clearColor];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoDataScrollViewItemSwipeView

+ (CGSize)sizeForItem:(id< MobilyDataItem >)item availableSize:(CGSize)size {
    if(size.width < size.height) {
        return CGSizeMake(size.width, 50.0f);
    }
    return CGSizeMake(50.0f, size.height);
}

- (void)prepareForUse {
    [super prepareForUse];
    
    self.rootView.backgroundColor = (self.item.allowsSnapToEdge) ? [UIColor blueColor] : [UIColor greenColor];
    _textView.text = self.item.data;
}

- (void)prepareForUnuse {
    [super prepareForUnuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self updateColors];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self updateColors];
}

- (void)updateColors {
    if(self.selected == YES) {
        _textView.backgroundColor = [UIColor redColor];
    } else if(self.highlighted == YES) {
        _textView.backgroundColor = [UIColor orangeColor];
    } else {
        _textView.backgroundColor = [UIColor clearColor];
    }
}

@end

/*--------------------------------------------------*/
