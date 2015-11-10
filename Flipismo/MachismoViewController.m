//
//  MachismoViewController.m
//  Flipismo
//
//  Created by User on 11/5/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "MachismoViewController.h"

@interface MachismoViewController ()

@end

@implementation MachismoViewController

static const CGSize CARD_SIZE = {40, 60};

- (void)log:(NSString *)string {
    NSLog(@"%@: %@", NSStringFromClass([self class]), string);
}

- (void)gameConfig {
    self.gameCardNum = 28;
    self.numToMatch  = 2;
}

- (void)gridConfig {
    self.grid.cellAspectRatio = CARD_SIZE.width / CARD_SIZE.height;
    self.grid.size = self.gameView.bounds.size;
    self.grid.minimumNumberOfCells = 28;
}

- (Deck *)createDeck {
    self.numToMatch = 2;
    
    return [[PlayingCardDeck alloc] init];
}

- (void)createCardViews {
    [self log:@"createCardViews"];
    
    super.cardViews = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.grid.minimumNumberOfCells; i++) {
        PlayingCardView *cardView = [[PlayingCardView alloc] init];
        
        UIColor *transparent = [UIColor whiteColor];
        transparent = [transparent colorWithAlphaComponent:0.0f];
        
        cardView.backgroundColor = transparent;
        
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:[self.cardViews count]];
        cardView.rank = card.rank;
        cardView.suit = card.suit;
        
        [self.gameView addSubview:cardView];
        
        [self.cardViews addObject:cardView];
    }
    
    [self log:@"createCardViews done"];
}

- (void)handleCardChoose:(Card *)cardView {
    // Get the chosen cards
    NSMutableArray *chosenCardIndices = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.cardViews count]; i++) {
        Card *card = [self.game cardAtIndex:i];
        
        if (card.isChosen) {
            [chosenCardIndices addObject:[NSNumber numberWithInteger:i]];
        }
    }
    
    [self.game chooseCardAtIndex:[self.cardViews indexOfObject:cardView]];
    
    [self animateCardFlip:(PlayingCardView *)cardView];
    
    // if previously chosen cards are not chosen anymore, flip them back
    for (int i = 0; i < [chosenCardIndices count]; i++) {
        int index = [chosenCardIndices[i] integerValue];
        Card *card = [self.game cardAtIndex:index];
        if (!card.isChosen) {
            [self animateCardFlip:[self.cardViews objectAtIndex:index]];
        }
    }
}

- (void)animateCardFlip:(PlayingCardView *)cardView {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    
    [UIView setAnimationTransition:(cardView.faceUp)?UIViewAnimationTransitionFlipFromLeft:UIViewAnimationTransitionFlipFromRight  forView:cardView cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.25];
    [UIView commitAnimations];
}

- (void)updateUI {
    [self log:@"updateUI"];
    
    int row = 0;
    int col = 0;
    for (PlayingCardView *cardView in self.cardViews) {
        col++;
        if (col >= 6) {
            col = 0;
            row++;
        }
        
        Card *card = [self.game cardAtIndex:[self.cardViews indexOfObject:cardView]];
        if (card.matched) {
            cardView.alpha = 0.3;
        }
        if (card.isChosen) {
            cardView.faceUp = YES;
        }
        else {
            cardView.faceUp = NO;
        }
    }
    
    super.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
