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

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        }
        else {
            // get all the chosen, but not matched card
            NSMutableArray *otherChosenCards = [NSMutableArray arrayWithCapacity:self.numToMatch-1];
            for (Card *otherCard in self.cards) {
                if (!otherCard.isMatched && otherCard.isChosen) {
                    [otherChosenCards addObject:otherCard];
                }
            }
            
            if ([otherChosenCards count] == self.numToMatch-1) {
                int matchScore = [card match:otherChosenCards];
                
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    
                    for (Card *otherChosenCard in otherChosenCards) {
                        otherChosenCard.matched = YES;
                    }
                    
                    card.matched = YES;
                }
                else {
                    self.score -= MISMATCH_PENALTY;
                    
                    for (Card *otherChosenCard in otherChosenCards) {
                        otherChosenCard.chosen = NO;
                    }
                }
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

//- (void)chooseCardAtIndex:(NSUInteger)index {
//    Card *card = [self cardAtIndex:index];
//    
//    if (!self.isStarted) {
//        [self setStarted:YES];
//    }
//    
//    if (!card.isMatched) {
//        if (card.isChosen) {
//            card.chosen = NO;
//            self.lastAction = @"";
//        }
//        else {
//            int tempScore = 0;
//            
//            self.lastAction = card.contents;
//            int numSelected = 1;
//            NSLog(@"numToMatch: %d", self.numToMatch);
//            
//            for (Card *otherCard in self.cards) {
//                if (otherCard.isChosen && !otherCard.isMatched) {
//                    int matchScore = [card match:@[otherCard]];
//                    
//                    if (matchScore) {
//                        numSelected++;
//                        tempScore += matchScore;
//                    }
//                    else {
////                        tempScore = 0;
//                        
//                        self.score -= MISMATCH_PENALTY;
//                        otherCard.chosen = NO;
//                        for (Card *otherCard in self.cards) {
//                            if (otherCard.isChosen && !otherCard.isMatched) {
//                                otherCard.chosen = NO;
//                            }
//                        }
//                        
//                        self.lastAction = [NSString stringWithFormat:@"%@ %@ don't match! 2 point penalty!",
//                                           card.contents,
//                                           otherCard.contents];
//                        break;
//                    }
//                }
//            }
//            
//            NSLog(@"numSelected: %d", numSelected);
//            
//            if (numSelected == self.numToMatch) {
//                self.lastAction = [NSString stringWithFormat:@"Matched %@ ", card.contents];
//                
//                for (Card *otherCard in self.cards) {
//                    if (otherCard.isChosen && !otherCard.isMatched) {
//                        otherCard.matched = YES;
//                        card.matched = YES;
//                        
//                        self.lastAction = [self.lastAction stringByAppendingString:otherCard.contents];
//                    }
//                }
//                
//                tempScore = tempScore * MATCH_BONUS;
//                self.score += tempScore;
//
//                NSString *stringToAppend = [NSString stringWithFormat:@"for %d points.", tempScore];
//                self.lastAction = [self.lastAction stringByAppendingString:stringToAppend];
//            }
//            
//            self.score -= COST_TO_CHOOSE;
//            card.chosen = YES;
//        }
//    }
//}

// getter
- (BOOL)isStarted {
    return _started;
}

// setter
- (void)setStarted:(BOOL)started {
    _started = started;
}

@end
