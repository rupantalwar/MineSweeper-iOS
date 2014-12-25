/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//  grid.m-     MineSweeper                                                    //
//              Source file containing Grid Implementation.                    //
//  Language:        Objective-C 2.0                                           //
//  Platform:        Mac OS X                                                  //
//                                                                             //
//  Author:          Rupan Talwar, SUID: 402408828 , Syracuse University       //
//                   (315)751-2860, rutalwar@syr.edu                           //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////
#import "grid.h"

//------------------------------------------------------------------------------
// grid implementation
//------------------------------------------------------------------------------

@implementation grid

@synthesize mineNumbers,mine,rowValue,colValue,opened,flag,visited;

//------------------------------------------------------------------------------
// grid init
//------------------------------------------------------------------------------
-(id) init
{
    self = [super init];
    mineNumbers = 0;
    mine = false;
    opened = false;
    flag = false;
    visited =false;
    return self;
}

@end
