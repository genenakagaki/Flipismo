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
@end

@implementation CardMatchingGame

@synthesize started = _started;
@synthesize lastAction = _lastAction;

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
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
    }
    
    [self setStarted:NO];
    self.lastAction = @"";
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int COST_TO_CHOOSE   = 1;
static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS      = 4;

int tempScore = 0;

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (!self.isStarted) {
        [self setStarted:YES];
    }
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            self.lastAction = @"";
        }
        else {
            self.lastAction = @"%d", [card contents];
            int numSelected = 1;
            NSLog(@"numToMatch: %d", self.numToMatch);
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    int matchScore = [card match:@[otherCard]];
                    
                    if (matchScore) {
                        numSelected++;
                        tempScore += matchScore;
                    }
                    else {
                        self.score -= MISMATCH_PENALTY;
                        otherCard.chosen = NO;
                        for (Card *otherCard in self.cards) {
                            if (otherCard.isChosen && !otherCard.isMatched) {
                                otherCard.chosen = NO;
                            }
                        }
                        
                        self.lastAction = @"%d %d don't match! 2 point penalty!", [card contents], [otherCard contents];
                        break;
                    }
                }
            }
            
            NSLog(@"numSelected: %d", numSelected);
            
            if (numSelected == self.numToMatch) {
                self.lastAction = @"Matched %d ", [card contents];
                
                for (Card *otherCard in self.cards) {
                    if (otherCard.isChosen && !otherCard.isMatched) {
                        self.score += tempScore * MATCH_BONUS;
                        otherCard.matched = YES;
                        card.matched = YES;
                        
                        NSString *cardContent = @"%d ", [otherCard.contents];
                        self.lastAction = [self.lastAction stringByAppendingString:cardContent];
                    }
                }
            }
            // match against other chosen cards
//            for (Card *otherCard in self.cards) {
//                if (otherCard.isChosen && !otherCard.isMatched) {
//                    int matchScore = [card match:@[otherCard]];
//                    if (matchScore) {
//                        self.score += matchScore * MATCH_BONUS;
//                        otherCard.matched = YES;
//                        card.matched = YES;
//                        
//                        matchCount++;
//                        if (matchCount == self.numToMatch) {
//                            break;
//                        }
//                    }
//                    else {
//                        self.score -= MISMATCH_PENALTY;
//                        otherCard.chosen = NO;
//                    }
////                    break; // can only choose 2 cards for now
//                }
//            }
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
