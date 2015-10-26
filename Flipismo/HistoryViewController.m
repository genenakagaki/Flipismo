//
//  HistoryViewController.m
//  Flipismo
//
//  Created by User on 10/19/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "HistoryViewController.h"
#import "PlayingCard.h"
#import "SetCard.h"
#import "History.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyView;

@end

@implementation HistoryViewController

@synthesize history = _history;
@synthesize game = _game;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableAttributedString *historyStr = [[NSMutableAttributedString alloc] init];
    
    if ([_game isEqualToString:@"machismo"]) {
        for (History *h in _history) {
            [historyStr appendAttributedString:[self machismoHistoryToString:h]];
        }
    }
    else if ([_game isEqualToString:@"set"]) {
        for (History *h in _history) {
            [historyStr appendAttributedString:[self setHistoryToString:h]];
        }
    }
    
    [self.historyView setAttributedText:historyStr];
}

- (NSAttributedString *)machismoHistoryToString:(History *)history {
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
    
    str = [[NSAttributedString alloc] initWithString:@"\n"];
    
    [result appendAttributedString:str];
    
    return result;
}

- (NSAttributedString *)contentOfSetCard:(SetCard *)card {
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

- (NSAttributedString *)setHistoryToString:(History *)history {
    
    NSMutableAttributedString *result;
    result = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *card;
    
    for (SetCard *setCard in history.cards) {
        card = [self contentOfSetCard:setCard];
        
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
    
    str = [[NSAttributedString alloc] initWithString:@"\n"];
    
    [result appendAttributedString:str];
    
    
    return result;
}

@end
