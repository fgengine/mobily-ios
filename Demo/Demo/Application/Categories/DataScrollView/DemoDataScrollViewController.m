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
    
    self.dataRootListContainer = [MobilyDataVerticalListContainer new];
    self.dataListContainer1 = [MobilyDataVerticalFlowContainer new];
    self.dataListContainer2 = [MobilyDataVerticalFlowContainer new];
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem addLeftBarFixedSpace:-16.0f animated:NO];
    [self.navigationItem addLeftBarButtonNormalImage:[UIImage imageNamed:@"menu-back.png"] target:self action:@selector(pressedBack) animated:NO];
    
    for(NSUInteger i = 0; i < 400; i++) {
        MobilyDataItem* hItem = [MobilyDataItem dataItemWithIdentifier:DemoDataScrollViewItemView.className data:[NSString stringWithFormat:@"S1 #%d", (int)i]];
        if((i % 4) == 0) {
            hItem.allowsSnapToEdge = YES;
            hItem.zOrder = 1.0f;
        }
        [_dataListContainer1 appendItem:hItem];
        
        MobilyDataItem* svItem = [MobilyDataItem dataItemWithIdentifier:DemoDataScrollViewItemSwipeView.className data:[NSString stringWithFormat:@"S2 #%d", (int)i]];
        if((i % 4) == 0) {
            svItem.allowsSnapToEdge = YES;
            svItem.zOrder = 1.0f;
        }
        [_dataListContainer2 appendItem:svItem];
    }
    [_dataRootListContainer appendContainer:_dataListContainer1];
    [_dataRootListContainer appendContainer:_dataListContainer2];
    
    [_dataScrollView registerIdentifier:DemoDataScrollViewItemView.className withViewClass:DemoDataScrollViewItemView.class];
    [_dataScrollView registerIdentifier:DemoDataScrollViewItemSwipeView.className withViewClass:DemoDataScrollViewItemSwipeView.class];

    [_dataScrollView setPullToRefreshView:[MobilyDataScrollRefreshView new]];
    [_dataScrollView setPullToRefreshHeight:64.0f];
    [_dataScrollView setPullToLoadView:[MobilyDataScrollRefreshView new]];
    [_dataScrollView setPullToLoadHeight:64.0f];
    [_dataScrollView registerEventWithBlock:^id(id sender, id object) {
        [_dataScrollView hidePullToRefreshAnimated:YES complete:nil];
        return nil;
    } forKey:MobilyDataScrollViewPullToRefreshTriggered];
    
    [_dataScrollView registerEventWithBlock:^id(id sender, id object) {
        [_dataScrollView hidePullToLoadAnimated:YES complete:nil];
        return nil;
    } forKey:MobilyDataScrollViewPullToLoadTriggered];

    [_dataScrollView setContainer:_dataRootListContainer];
}

#pragma mark Action

- (IBAction)pressedBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoDataScrollViewItemView

+ (CGSize)sizeForItem:(id< MobilyDataItem >)item availableSize:(CGSize)size {
    return CGSizeMake(50.0f, 50.0f);
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
    return CGSizeMake(50.0f, 50.0f);
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
