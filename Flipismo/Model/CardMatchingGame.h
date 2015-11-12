//
//  CardMatchingGame.h
//  Flipismo
//
//  Created by User on 9/16/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"
#import "History.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (NSArray *)getIndiciesOfMatches:(NSArray *)cardsToCheck;
- (void)addScore:(NSInteger)score;

@property (nonatomic, getter = isStarted) BOOL started;
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSMutableArray *history;
@property (nonatomic) NSInteger numToMatch;
@property (nonatomic) History *lastAction;

@end
