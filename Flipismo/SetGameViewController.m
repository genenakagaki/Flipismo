//
//  CardGameViewController.m
//  Flipismo
//
//  Created by User on 9/10/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"
#import "History.h"

@interface SetGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *redealButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation SetGameViewController

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
        self.game.numToMatch = 3;
    }
    return _game;
}

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (IBAction)touchRedealButton:(UIButton *)sender {
    _game = nil;
    
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];

    [self game];
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
        
        [cardButton setAttributedTitle:[self contentOf:(SetCard *)card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
    
    [self.resultLabel setAttributedText:[self lastAction]];
    
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    if (card.isChosen) {
        if (!card.isMatched) {
            return [UIImage imageNamed:@"setCard"];
        }
    }
    
    return [UIImage imageNamed:@"cardfront"];
}

- (NSAttributedString *)contentOf:(SetCard *)card {
    UIColor *color = [UIColor blueColor];
    
    if ([card.color isEqualToString:@"red"]) {
        color = [UIColor redColor];
    }
    else if ([card.color isEqualToString:@"green"]) {
        color = [UIColor greenColor];
    }
    
    NSMutableAttributedString *shape;
    shape = [[NSMutableAttributedString alloc] initWithString:card.shape];
    
    if ([card.shading isEqualToString:@"filled"]) {
        [shape addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, shape.length)];
    }
    else if ([card.shading isEqualToString:@"shaded"]) {
        color = [color colorWithAlphaComponent:0.2f];
        [shape addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, shape.length)];
    }
    else if ([card.shading isEqualToString:@"outlined"]) {
        [shape addAttribute:NSStrokeColorAttributeName value:color range:NSMakeRange(0, shape.length)];
        [shape addAttribute:NSStrokeWidthAttributeName value:@5 range:NSMakeRange(0, shape.length)];
    }
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < card.num; i++) {
        [result appendAttributedString:shape];
    }
    
    return result;
}

- (NSAttributedString *)lastAction {
    if (!self.game.lastAction) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    History *history = self.game.lastAction;
    
    NSMutableAttributedString *result;
    result = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *card;
    
    for (SetCard *setCard in history.cards) {
        card = [self contentOf:setCard];
    
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
    if ([[segue identifier] isEqualToString:@"setHistory"])
    {
        // Get reference to the destination view controller
        HistoryViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.history = self.game.history;
        vc.game = @"set";
    }
}

@end
