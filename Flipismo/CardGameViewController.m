//
//  CardGameViewController.m
//  Flipismo
//
//  Created by User on 9/10/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *redealButton;
@property (weak, nonatomic) IBOutlet UISwitch *matchModeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *matchModeLabel;

//@property (strong, nonatomic) PlayingCardDeck *playingCardDeck;
//@property (nonatomic) int cardCount;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
        _game.numToMatch = 2;
    }
    return _game;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchRedealButton:(UIButton *)sender {
    _game = nil;
    [self updateUI];
}

- (IBAction)touchMatchModeSwitch:(UISwitch *)sender {
    NSLog(@"gameStarted: %d", _game.started);
    if (!_game.started) {
        if ([sender isOn]) {
            _game.numToMatch = 3;
            [self.matchModeLabel setText:@"3 Card Match"];
        }
        else {
            _game.numToMatch = 2;
            [self.matchModeLabel setText:@"2 Card Match"];
        }
    }
    else {
        // disable switch when game is started
        if ([sender isOn]) {
            [sender setOn:NO];
        }
        else {
            [sender setOn:YES];
        }
    }
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

-(void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        // determine color of card
        if (card.isChosen) {
            if ([card isKindOfClass:[PlayingCard class]]) {
                PlayingCard *playingCard = (PlayingCard *)card;
                if (    [playingCard.suit isEqualToString:@"♥︎"] ||
                        [playingCard.suit isEqualToString:@"♦︎"]) {
                    [cardButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }
                else {
                    [cardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }
        }
        
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
    
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
