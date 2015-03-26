/*--------------------------------------------------*/

#import "___FILEBASENAME___.h"

/*--------------------------------------------------*/

@interface ___FILEBASENAMEASIDENTIFIER___ ()

@property(nonatomic, readwrite, weak) IBOutlet MobilyDataView* dataView;
@property(nonatomic, readwrite, strong) MobilyDataContainer* dataContainer;

@end

/*--------------------------------------------------*/

@implementation ___FILEBASENAMEASIDENTIFIER___

#pragma mark Init / Free

- (void)setup {
    [super setup];
}

#pragma mark Load / Unload

- (void)viewDidLoad {
    [super viewDidLoad];
	 
    // Do any additional setup after loading the view.
    // [_dataView registerIdentifier:<#(NSString *)#> withViewClass:<#(__unsafe_unretained Class)#>];
    // [_dataView registerEventWithTarget:<#(id)#> action:<#(SEL)#> forIdentifier:<#(NSString *)#> forKey:<#(id)#>];
    _dataView.container = _dataContainer;
}

#pragma mark Update / Clear

- (void)update {
    [super update];
    
    // update screen data
}

- (void)clear {
	// clear all data
	
	[super clear];
}

#pragma mark Public

#pragma mark Private

#pragma mark Actions

@end

/*--------------------------------------------------*/