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

@interface DemoTablesController : MobilyViewController < UITableViewDataSource, UITableViewDelegate >

@property(nonatomic, readwrite, strong) NSArray* dataSource;
@property(nonatomic, readwrite, weak) IBOutlet MobilyTableView* tableView;

@end

/*--------------------------------------------------*/

@class DemoTablesModel;

@interface DemoTablesCell : MobilyTableCell

@property(nonatomic, readwrite, weak) DemoTablesModel* model;
@property(nonatomic, readwrite, weak) IBOutlet UILabel* textView;

@end

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, DemoTablesType) {
    DemoTablesType500px,
};

@interface DemoTablesModel : MobilyModel

@property(nonatomic, readwrite, assign) DemoTablesType type;
@property(nonatomic, readwrite, strong) NSString* title;

- (instancetype)initWithType:(DemoTablesType)type title:(NSString*)title NS_DESIGNATED_INITIALIZER;

@end

/*--------------------------------------------------*/