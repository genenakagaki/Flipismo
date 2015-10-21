//
//  CardMatchingGame.m
//  Flipismo
//
//  Created by User on 9/16/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, readwrite) NSMutableArray *history;

@end

@implementation CardMatchingGame

@synthesize started = _started;
@synthesize lastAction = _lastAction;

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)history {
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    self = [super init]; // super's designated initializer
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }
            else {
                self = nil;
                break;
            }
        }
        
        [self.history removeAllObjects];
    }
    
    [self setStarted:NO];
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int COST_TO_CHOOSE   = 1;
static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS      = 4;

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        }
        else {
            
            // get all the chosen, but not matched card
            NSMutableArray *otherChosenCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (!otherCard.isMatched && otherCard.isChosen) {
                    [otherChosenCards addObject:otherCard];
                }
            }
            
            if ([otherChosenCards count] == self.numToMatch-1) {
                _lastAction = [[History alloc] init];
                int matchScore = [card match:otherChosenCards];
                
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    
                    [_lastAction setScore:matchScore * MATCH_BONUS];
                    
                    [_lastAction.cards addObject:card];
                    
                    for (Card *otherChosenCard in otherChosenCards) {
                        [_lastAction.cards addObject:otherChosenCard];
                        otherChosenCard.matched = YES;
                    }
                    
                    [self.history addObject:self.lastAction];
                    
                    card.matched = YES;
                }
                else {
                    self.score -= MISMATCH_PENALTY;
                    
                    [_lastAction setScore:-MISMATCH_PENALTY];
                    
                    [_lastAction.cards addObject:card];

                    for (Card *otherChosenCard in otherChosenCards) {
                        [_lastAction.cards addObject:otherChosenCard];
                        otherChosenCard.chosen = NO;
                    }
                    
                    [self.history addObject:self.lastAction];
                }
            }
            else {
                _lastAction = nil;
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

// getter
- (BOOL)isStarted {
    return _started;
}

// setter
- (void)setStarted:(BOOL)started {
    _started = started;
}

@end
