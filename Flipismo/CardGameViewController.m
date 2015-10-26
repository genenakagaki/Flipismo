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
#import "History.h"
#import "HistoryViewController.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *redealButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
        self.game.numToMatch = 2;
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
        
        [self.resultLabel setAttributedText:[self lastAction]];
    }
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (NSAttributedString *)lastAction {
    if (!self.game.lastAction) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    History *history = self.game.lastAction;
    
    NSMutableAttributedString *result;
    result = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *card;

    for (PlayingCard *playingCard in history.cards) {
        card = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", playingCard.contents]];
        if (    [playingCard.suit isEqualToString:@"♥︎"] ||
                [playingCard.suit isEqualToString:@"♦︎"]) {
            [card addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, card.length)];
        }
        
        [result appendAttributedString:card];
    }
    
    NSAttributedString *str;
    
    if (history.score > 0) {
        str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"matches! +%d points!", history.score]];
    }
    else {
        str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"does not match! %d points!", history.score]];
    }
    
    [result appendAttributedString:str];

    
    return result;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"machismoHistory"])
    {
        // Get reference to the destination view controller
        HistoryViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.history = self.game.history;
        vc.game = @"machismo";
    }
}

@end
