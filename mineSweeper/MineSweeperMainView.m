/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
// MineSweeperMainView.h-     MineSweeper                                      //
//                   Source file containing minesweeper view imlementation.    //
//  Language:        Objective-C 2.0                                           //
//  Platform:        Mac OS X                                                  //
//                                                                             //
//  Author:          Rupan Talwar, SUID: 402408828 , Syracuse University       //
//                   (315)751-2860, rutalwar@syr.edu                           //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////

#import "MineSweeperMainView.h"
#import "ViewController.h"

@interface MineSweeperMainView ()
@end

//------------------------------------------------------------------------------
// MineSweeper implementation
//------------------------------------------------------------------------------
@implementation MineSweeperMainView

@synthesize dw, dh, row, col, x, y,myArray;

- (id)initWithFrame:(CGRect)frame {
    return self = [super initWithFrame:frame];
}

//------------------------------------------------------------------------------
// Creating object of grid and then calling resetgame
//------------------------------------------------------------------------------
-(void) addNewInstance
{
    myArray=[[NSMutableArray alloc]init];
    grid *gridPointer;
    int k=0;
    for(int i=1;i<17 ;i++){
        for( int j =0 ; j < 16 ; j++){
            gridPointer = [[grid alloc]init];
            gridPointer.rowValue = i;
            gridPointer.colValue = j;
            gridPointer.kValue = k;
            [myArray addObject:gridPointer];
            k++;
        }
    }
    [self resetGame];
    UITapGestureRecognizer *tapDoubleGR = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(tapDoubleHandler:)];
    tapDoubleGR.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapDoubleGR];
    UITapGestureRecognizer *tapSingleGR = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(tapSingleHandler:)];
    // set appropriate GR attributes
    tapSingleGR.numberOfTapsRequired = 1;
    // prevent single tap recognition on double-tap
    [tapSingleGR requireGestureRecognizerToFail: tapDoubleGR];
    [self addGestureRecognizer:tapSingleGR];
}

//------------------------------------------------------------------------------
// reseting game values for new game
//------------------------------------------------------------------------------
- (void)resetGame
{
    int k =0;
    grid *gridPointer;
    for(int i=1;i< 17 ;i++){
        for( int j =0 ; j < 16 ; j++){
            gridPointer= [ myArray objectAtIndex:k];
            gridPointer.mineNumbers = 0;
            gridPointer.mine = FALSE;
            gridPointer.opened = false;
            gridPointer.flag = FALSE;
            gridPointer.visited =false;
            k++;
        }
    }
    totalScoretobecounted = 0;
    placedMineCount= 0;
    gameOver = false;
    [self placeMines]; // calling mine placing
    [self mineNumbersCount]; // calling counting mine number
}

//------------------------------------------------------------------------------
// Calling after button is clicked
//------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if(buttonIndex == 1){
            // resetting game
            [self resetGame];
            [self setNeedsDisplay];
        }else{
            // shutting down game
            exit(0);
        }
}

//------------------------------------------------------------------------------
// Drawing horizontal and vertical grid
//------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect
{
    // obtain graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    // shrink into upper left quadrant
    CGContextScaleCTM( context, 1,1);
    // get view's location and size
    CGRect bounds = [self bounds];
    // w = width of view (in points)
    CGFloat w = CGRectGetWidth( bounds );
    // h = height of view (in points)
    CGFloat h = CGRectGetHeight ( bounds );
    // dw = width of cell (in points)
    dw = w/16.0f;
    // dh = height of cell (in points)
    dh = (h-30)/16.0f;
   // NSLog( @"view (width,height) = (%g,%g)", w, h );
   // NSLog( @"cell (width,height) = (%g,%g)", dw, dh );

    // begin collecting drawing operations
    CGContextBeginPath( context );
    UIRectFrame( bounds );
    // draw horizontal grid line
    for ( int i = 1;  i <= 16;  ++i )
    {
        CGContextMoveToPoint( context, 0, i*dh );
        CGContextAddLineToPoint( context, w, i*dh );
    }
    // draw vertical grid line
    for ( int i = 1;  i <= 16;  ++i )
    {
        CGContextMoveToPoint( context, i*dw, 35);
        CGContextAddLineToPoint( context, i*dw, h);
    }
    // use gray as stroke color
    [[UIColor whiteColor] setStroke];
    // execute collected drawing ops
    CGContextDrawPath( context, kCGPathStroke );
    [self gameState]; // calling state of game
}

//------------------------------------------------------------------------------
// Display state of game
//------------------------------------------------------------------------------
-(void) gameState
{
    // looping through all cell to get the state of game and checking its state accordingly
    int currentScoreCount = 0;
    int k =0;
    for(int i=1;i<17 ;i++){
        for( int j=0 ; j< 16 ; j++){
            grid *gridPointer= [ myArray objectAtIndex:k];
            if( gameOver) // gameover condition
            {
                if( gridPointer.mine)
                {
                    CGPoint xy = { (gridPointer.colValue)*dw, gridPointer.rowValue*dh };
                    CGRect mineImage = CGRectMake(xy.x,xy.y,dw,dh);
                    UIImage *img = [UIImage imageNamed:@"mine"];
                    [img drawInRect:mineImage  ];
                }
                if(gridPointer.mine == false && gridPointer.opened== TRUE )
                {
                    if(gridPointer.mineNumbers == 0){
                        CGPoint xy = { (gridPointer.colValue)*dw, (gridPointer.rowValue)*dh };
                        CGRect mineImage = CGRectMake(xy.x+0.9,xy.y+0.9,dw-1.8,dh-1.8);
                        UIImage *img = [UIImage imageNamed:@"WhiteImage"];
                        [img drawInRect:mineImage  ];
                    }else{
                        UIFont *font = [UIFont systemFontOfSize: .75*dh];
                        int mineNum = gridPointer.mineNumbers;
                        NSString *s = [NSString stringWithFormat:@"%d",mineNum];
                        CGPoint xy = { (gridPointer.colValue+0.17)*dw, (gridPointer.rowValue)*dh };
                        [s drawAtPoint: xy withFont: font];
                    }
                }
            }else if(gridPointer.flag){ // flag condition
              
                CGPoint xy = { (gridPointer.colValue)*dw, (gridPointer.rowValue)*dh };
                CGRect mineImage = CGRectMake(xy.x,xy.y,dw,dh);
                UIImage *img = [UIImage imageNamed:@"flagImage"];
                [img drawInRect:mineImage  ];
                
            }else if(gridPointer.mine == false && gridPointer.opened== TRUE ){
                // displaying opened grid if grid has not mine in it.
                currentScoreCount++;
                if(gridPointer.mineNumbers == 0){
                    CGPoint xy = { (gridPointer.colValue)*dw, (gridPointer.rowValue)*dh };
                    CGRect mineImage = CGRectMake(xy.x+0.9,xy.y+0.9,dw-1.8,dh-1.8);
                    UIImage *img = [UIImage imageNamed:@"WhiteImage"];
                    [img drawInRect:mineImage  ];
                }else{
                    UIFont *font = [UIFont systemFontOfSize: .75*dh];
                    int mineNum = gridPointer.mineNumbers;
                    NSString *s = [NSString stringWithFormat:@"%d",mineNum];
                    CGPoint xy = { (gridPointer.colValue+0.17)*dw, (gridPointer.rowValue)*dh };
                    [s drawAtPoint: xy withFont: font];
                }
            }
            k++;
        }
        
    }
    // Alerting if game is over
    if(gameOver){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over!!" message:@"You Loose \n Want to restart?" delegate:self cancelButtonTitle:@"Stop Game" otherButtonTitles:@"New Game",nil];
        [alert show];
    }
    
   // NSLog(@"currentScoreCount %d = ",  currentScoreCount);
   
    // Alerting win state
   if(currentScoreCount == totalScoretobecounted){
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over!!" message:@"You Win \n Want to restart?" delegate:self cancelButtonTitle:@"Stop Game" otherButtonTitles:@"New Game",nil];
      [alert show];
    }
}

//------------------------------------------------------------------------------
// After single tap
//------------------------------------------------------------------------------
- (void) tapSingleHandler: (UITapGestureRecognizer *) sender
{
    if ( sender.state == UIGestureRecognizerStateEnded )
    {
        CGPoint xy;
        xy = [sender locationInView: self];
        row = xy.x / dw;
        col = xy.y / dh;
        int k =0;
        for(int i=1;i< 17 ;i++){
            for( int j =0 ; j < 16 ; j++){
                grid *gridPointer= [ myArray objectAtIndex:k];
                if (gridPointer.colValue == self.row && gridPointer.rowValue==self.col) {
                   if(!gridPointer.opened){ // stopping to display flag on open cell
                        if(!gridPointer.flag){ // checking is flag set or not
                           gridPointer.flag = TRUE;
                        }else{ //clearing flagset
                            gridPointer.flag = false;
                        }
                    }
                }
                k++;
            }
        }
        [self setNeedsDisplay];
    }
}

//------------------------------------------------------------------------------
// After double tap
//------------------------------------------------------------------------------
- (void) tapDoubleHandler: (UITapGestureRecognizer *) sender
{
    CGPoint xy;
    xy = [sender locationInView: self];
    row = xy.x / dw;
    col = xy.y / dh;
    int k =0;
    for(int i=1 ;i< 17 ;i++){
        for( int j =0 ; j < 16 ; j++){
            grid *gridPointer= [ myArray objectAtIndex:k];
            if (gridPointer.colValue == self.row && gridPointer.rowValue==self.col) {
                
                if(gridPointer.flag){ // if flag has been set returning
                    return;
                }
                if(!gridPointer.visited){ // opening grid
                  gridPointer.opened = TRUE;
                
                if(gridPointer.mine == true){ // chechking mine is clicked
                    gameOver = true;
                }else{
                    // calling recursively to open grid if mineNumber count as zero
                    if(gridPointer.mineNumbers == 0){
                        [self recursivelyOpen:gridPointer];
                    }
                }
             }
            }
            k++;
        }
    }
    [self setNeedsDisplay];
}

//------------------------------------------------------------------------------
// Recursively Opening the grid based on calling upperleft, upper, upperright
// left,right ,lowerleft, lower, lower right cell
//------------------------------------------------------------------------------
-(void) recursivelyOpen:(grid *) gridPoint
{
    // base case
    if(gridPoint.mineNumbers != 0 || gridPoint.visited == true){
        gridPoint.opened = true; // opening nearby element
        return;
    }
    // marking grid as visited
    gridPoint.visited = true;
    // marking grid open as true
    gridPoint.opened = true;
    
    if(!(gridPoint.kValue >=0 && gridPoint.kValue <= 15)){
        if(!((gridPoint.kValue % 16) ==0)){
        grid *gridPointerUL= [ myArray objectAtIndex:((gridPoint.kValue)-17)];
        [self recursivelyOpen:gridPointerUL];
        }
        grid *gridPointerU= [ myArray objectAtIndex:((gridPoint.kValue)-16)];
        [self recursivelyOpen:gridPointerU];

        if(!(((gridPoint.kValue+1) %16) == 0)){
        grid *gridPointerUR= [ myArray objectAtIndex:((gridPoint.kValue)-15)];
        [self recursivelyOpen:gridPointerUR];
        }
    }
   if(!((gridPoint.kValue % 16) == 0)){
        grid *gridPointerL= [ myArray objectAtIndex:((gridPoint.kValue)-1)];
        [self recursivelyOpen:gridPointerL];
    }
   if(!(((gridPoint.kValue+1)%16) == 0)){
            grid *gridPointerR= [ myArray objectAtIndex:((gridPoint.kValue)+1)];
            [self recursivelyOpen:gridPointerR];
    }
    if(!(gridPoint.kValue >=240 && gridPoint.kValue <= 255)){

        if(!((gridPoint.kValue %16) == 0)){
            grid *gridPointerLowL= [ myArray objectAtIndex:((gridPoint.kValue)+15)];
            [self recursivelyOpen:gridPointerLowL];
        }
        grid *gridPointerLow= [ myArray objectAtIndex:((gridPoint.kValue)+16)];
        [self recursivelyOpen:gridPointerLow];

        if(!(((gridPoint.kValue+1)%16) == 0)){
        grid *gridPointerLowR= [ myArray objectAtIndex:((gridPoint.kValue)+17)];
        [self recursivelyOpen:gridPointerLowR];
        }
    }
}

//------------------------------------------------------------------------------
// Counting near by mineNumbers and updating grid mineNumber
//------------------------------------------------------------------------------
-(void)mineNumbersCount
{
    int k =0;
    int mineCount;
    grid *gridPointerUL;
    grid *gridPointerU;
    grid *gridPointerUR;
    grid *gridPointerL;
    grid *gridPointerR;
    grid *gridPointerLowL;
    grid *gridPointerLow;
    grid *gridPointerLowR;
    grid *gridPointer;

    for(int i=0;i< 16 ;i++){
        for( int j =0 ; j < 16 ; j++){
            gridPointer= [ myArray objectAtIndex:k];
            mineCount =0;
            if(i!=0){
                if(j!=0){
                gridPointerUL= [ myArray objectAtIndex:(k-17)];
                    if(gridPointerUL.mine){
                        mineCount++;
                    }
                }
                if(j!=15){
                gridPointerUR= [ myArray objectAtIndex:(k-15)];
                    if(gridPointerUR.mine){
                        mineCount++;
                    }
                }
                gridPointerU= [ myArray objectAtIndex:(k-16)];
                if(gridPointerU.mine){
                    mineCount++;
                }
            }
            if(j!=0){
                gridPointerL= [ myArray objectAtIndex:(k-1)];
                if(gridPointerL.mine){
                    mineCount++;
                }
            }
            if(j!=15){
              gridPointerR= [ myArray objectAtIndex:(k+1)];
               if(gridPointerR.mine){
                  mineCount++;
              }
            }
            if(i!=15){
                if(j!=0){
                gridPointerLowL= [ myArray objectAtIndex:(k+15)];
                    if(gridPointerLowL.mine){
                        mineCount++;
                    }
                }
                gridPointerLow= [ myArray objectAtIndex:(k+16)];
                if(gridPointerLow.mine){
                    mineCount++;
                }
                if(j!=15){
                    gridPointerLowR= [ myArray objectAtIndex:(k+17)];
                    if(gridPointerLowR.mine){
                    mineCount++;
                    }
                }
            }
            gridPointer.mineNumbers = mineCount;
           k++;
        }
    }
}

//------------------------------------------------------------------------------
// Placing Mine and updating total score to be counted for wining the game
//------------------------------------------------------------------------------
-(void)placeMines
{
    int bombsCounter = NUMBEROFMINES;
    while(bombsCounter > 0){
        int randomNumber = arc4random_uniform((16 * 16) - 1);
        int rowCount = (randomNumber / 16);
        int columnCount = randomNumber % 16;
        int k=0;
        grid *gridPointer;
        for(int i=1;i< 17 ;i++){
            for( int j =0 ; j < 16 ; j++){
                gridPointer = [ myArray objectAtIndex:k];
              
                  //NSLog(@" i am here grid k= %d x= %d",gridPointer.rowValue,gridPointer.colValue);
                
                if(gridPointer.rowValue == rowCount && gridPointer.colValue == columnCount){
                    gridPointer.mine = true;
                    gridPointer.mineNumbers = 15;
                }
                k++;
            }
        }
        bombsCounter--;
    }
    
    grid *gridPointer;
    int k=0;
    for(int i=1;i< 17 ;i++){
        for( int j =0 ; j < 16 ; j++){
            gridPointer = [ myArray objectAtIndex:k];
            if(gridPointer.mine){
                placedMineCount++;
            }
            k++;
        }
    }
    
    totalScoretobecounted = 256-placedMineCount;
    //NSLog(@"totalScoret %d = ",placedMineCount );
    //NSLog(@"totalScoretobecounted %d = ",totalScoretobecounted );
}

@end
