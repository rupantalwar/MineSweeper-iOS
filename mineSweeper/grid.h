/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//  grid.h-     MineSweeper                                                    //
//              Source file containing Grid Interface.                         //
//  Language:        Objective-C 2.0                                           //
//  Platform:        Mac OS X                                                  //
//                                                                             //
//  Author:          Rupan Talwar, SUID: 402408828 , Syracuse University       //
//                   (315)751-2860, rutalwar@syr.edu                           //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
//------------------------------------------------------------------------------
// Defining interface grid which holds value for per cell of minesweeper
//------------------------------------------------------------------------------
@interface grid : NSObject

@property (nonatomic,readwrite) int rowValue; // store row Value
@property (nonatomic,readwrite) int colValue; // store col Value
@property (nonatomic,readwrite) int kValue; // to get index of an array
@property (nonatomic,readwrite) bool opened; // to check cell is open or not
@property (nonatomic,readwrite) bool mine; // to check mine is present or not
@property (nonatomic,readwrite) bool visited; // to check grid has been visited
@property (nonatomic,readwrite) int mineNumbers; //counting surrounding minenumber
@property (nonatomic,readwrite) bool flag; // to check flag is set or not
-(id) init;

@end
