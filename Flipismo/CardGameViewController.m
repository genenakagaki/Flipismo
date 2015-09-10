//
//  CardGameViewController.m
//  Flipismo
//
//  Created by User on 9/10/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;

@property (strong, nonatomic) PlayingCardDeck *playingCardDeck;
@property (nonatomic) int cardCount;

//@property (nonatomic) NSArray *shownCards;

@end

@implementation CardGameViewController

//#define NUM_PLAYING_CARDS = 52;
const int NUM_PLAYING_CARDS = 52;

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (PlayingCardDeck *)playingCardDeck {
    if (!_playingCardDeck) {
        // lazy instantiation
        _playingCardDeck = [[PlayingCardDeck alloc] init];
        
        self.cardCount = NUM_PLAYING_CARDS;
        
//        self.shownCards = [[NSArray alloc] init];
    }
    return _playingCardDeck;
}

- (void)setCardCount:(int)cardCount {
    _cardCount = cardCount;
}

- (IBAction)touchCardButton:(UIButton *)sender {
    if (self.cardCount >= 0) {
        Card *card;
        
        if ([sender.currentTitle length]) {
            self.cardCount--;
            
            [sender setBackgroundImage:[UIImage imageNamed:@"cardback"] forState:UIControlStateNormal];
            [sender setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            card = [self.playingCardDeck drawRandomCard];
            
            [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"] forState:UIControlStateNormal];
            [sender setTitle:card.contents forState:UIControlStateNormal];
        }
        
        self.flipCount++;
    }
}

@end
