/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//  ViewController.h- MineSweeper                                              //
//                   Source file containing ViewController implementation.     //
//  Language:        Objective-C 2.0                                           //
//  Platform:        Mac OS X                                                  //
//                                                                             //
//  Author:          Rupan Talwar, SUID: 402408828 , Syracuse University       //
//                   (315)751-2860, rutalwar@syr.edu                           //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////
#import "ViewController.h"
#import "MineSweeperMainView.h"
#import "grid.h"

@interface ViewController ()
@property (strong,nonatomic) IBOutlet MineSweeperMainView *mainView;
@end

//------------------------------------------------------------------------------
// View Controller implenetation
//------------------------------------------------------------------------------
@implementation ViewController
@synthesize mainView;

//------------------------------------------------------------------------------
// view Did load call
//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    //setting backgroundcolor
    [self.mainView setBackgroundColor: [UIColor lightGrayColor]];
    // calling to inisiate objects and do initialization for that
    [mainView addNewInstance];
    
}

//------------------------------------------------------------------------------
// Dispose of any resources that can be recreated.
//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
