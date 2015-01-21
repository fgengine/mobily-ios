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

#import "MobilyContext.h"
#import "MobilyApplication.h"
#import "MobilyWindow.h"
#import "MobilyController.h"
#import "MobilyControllerNavigation.h"
#import "MobilyControllerView.h"
#import "MobilyControllerDynamicsDrawer.h"
#import "MobilyControllerSlideMenu.h"
#import "MobilyViewImage.h"
#import "MobilyViewTable.h"

/*--------------------------------------------------*/

@interface ExampleApplication : MobilyApplication

@property(nonatomic, readwrite, weak) MobilyWindow* window;
@property(nonatomic, readwrite, weak) MobilyControllerSlideMenu* slideView;
@property(nonatomic, readwrite, weak) MobilyControllerView* navMainView;
@property(nonatomic, readwrite, weak) MobilyControllerView* mainView;

@end

/*--------------------------------------------------*/

@interface ExampleControllerMain : MobilyControllerView < UITableViewDataSource, UITableViewDelegate >

@property(nonatomic, readwrite, weak) IBOutlet MobilyViewTable* viewTable;
@property(nonatomic, readwrite, strong) NSArray* dataSource;

@end

/*--------------------------------------------------*/

@interface ExampleControllerMainCell : MobilyViewTableCellSwipe

@property(nonatomic, readwrite, weak) IBOutlet UILabel* viewTitle;

@end

/*--------------------------------------------------*/
