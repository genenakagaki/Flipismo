//
//  CardGameViewController.m
//  Flipismo
//
//  Created by User on 9/10/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()

- (IBAction)touchDealButton:(UIButton *)sender;

@end

@implementation CardGameViewController

static const CGPoint gatherPoint = {100, 100};

static const CGPoint dealPoint = {0, -200};

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [self log:@"viewDidAppear"];
    
    [super viewDidAppear:animated];
    
    _grid = nil;
    
    [self dealCardsFromPoint:[[MyCGPoint alloc] initWithPoint:dealPoint]];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self log:@"didRotateFromInterfaceOrientation"];
    _grid = nil;
    
    [self gatherCardsToPoint:gatherPoint];
    
    MyCGPoint *point = [[MyCGPoint alloc] initWithPoint:gatherPoint];
    
    [self performSelector:@selector(dealCardsFromPoint:)
               withObject:point
               afterDelay:1];
}

- (void)log:(NSString *)string {
    NSLog(@"%@: %@", NSStringFromClass([self class]), string);
}

- (CardMatchingGame *)game {
    if (!_game) {
        [self gameConfig];
        
        _game = [[CardMatchingGame alloc] initWithCardCount:self.gameCardNum
                                                  usingDeck:[self createDeck]];
        [self createCardViews];
        
        MyCGPoint *dealPointObj = [[MyCGPoint alloc] initWithPoint:dealPoint];
        
        [self dealCardsFromPoint:dealPointObj];
        
        self.game.numToMatch = self.numToMatch;
    }
    return _game;
}

- (Grid *)grid {
    if (!_grid) {
        _grid = [[Grid alloc] init];
        [self gridConfig];
    }
    
    return _grid;
}

// ABSTRACT METHOD
- (void)gameConfig {};

// ABSTRACT METHOD
- (void)gridConfig {}

// ABSTRACT METHOD
- (Deck *)createDeck {
    return nil;
}

// ABSTRACT METHOD
- (void)createCardViews {
}

- (void)gatherCardsToPoint:(CGPoint)point {
    [self log:@"gatherCardsToPoint" ];
    
    float delay = 0.01;
    
    for (int i = 0; i < [self.cardViews count]; i++) {
        UIView *cardView = [self.cardViews objectAtIndex:i];
        
        [self animateCardMovement:cardView
                          toPoint:point
                        withDelay:delay * i];
    }
}

- (void)dealCardsFromPoint:(MyCGPoint *)pointObj {
    [self log:@"dealCards" ];
    
    CGPoint point = pointObj.cgPoint;

    float delay = 0.1;

    int row = 0;
    int col = 0;
    for (int i = 0; i < [self.cardViews count]; i++) {
        
        UIView *cardView = [self.cardViews objectAtIndex:i];
        
        CGRect cell = [self.grid frameOfCellAtRow:row inColumn:col];
        
        CGSize cardSize = CGSizeMake(cell.size.width - 8, cell.size.height - 8);
        
        CGRect frame = CGRectMake(point.x - cardSize.width/2,
                                  point.y - cardSize.height/2,
                                  cardSize.width,
                                  cardSize.height);
        cardView.frame = frame;
        
        [self animateCardMovement:cardView
                          toPoint:[self.grid centerOfCellAtRow:row inColumn:col]
                        withDelay:delay * i];
        
        col++;
        if (col >= self.grid.columnCount) {
            col = 0;
            row++;
        }
    }
}

- (IBAction)touchDealButton:(UIButton *)sender {
    [self log:@"touchDealButton" ];
    
    [self gatherCardsToPoint:CGPointMake(-200, 100)];
    
    _game = nil;
    
    [self updateUI];
}

- (void)animateCardMovement:(UIView *)cardView
                       toPoint:(CGPoint)point
                     withDelay:(float)delay {
    [UIView animateWithDuration:0.5
                          delay: delay
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         cardView.center = point;
                     }
                     completion:nil];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    [self log:@"tap" ];
    
    CGPoint tapLocation = [sender locationInView:self.gameView];
    for (UIView *cardView in self.cardViews) {
        // if tap location is contained in a cardView
        if (CGRectContainsPoint([cardView frame], tapLocation)) {
            [self handleCardChoose:cardView];
        }
    }
    
    [self updateUI];
}

// ABSTRACT METHOD
- (void)handleCardChoose:(UIView *)cardView {}

// ABSTRACT METHOD
- (void)updateUI {}

@end
