    //
//  CardGameViewController.h
//  Flipismo
//
//  Created by User on 9/10/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grid.h"
#import "CardMatchingGame.h"
#import "Card.h"
#import "Deck.h"
#import "MyCGPoint.h"
#import "MyToastView.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) NSUInteger gameCardNum;
@property (nonatomic) NSUInteger numToMatch;
@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (void)animateCardMovement:(UIView *)cardView
                    toPoint:(CGPoint)point
                  withDelay:(float)delay;

// ABSTRACT METHODS
- (void)gridConfig;
- (Deck *)createDeck;
- (void)createCardViews;
- (void)handleCardChoose:(UIView *)cardView;
- (void)updateUI;

@end
