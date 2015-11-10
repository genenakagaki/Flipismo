//
//  PlayingCard.m
//  Flipismo
//
//  Created by User on 9/9/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
//    using introspection
//    if ([otherCards count] == 1) {
//        id card = [otherCards firstObject];
//        if ([card isKindOfClass:[PlayingCard class]]) {
//            PlayingCard *otherPlayingCard = (PlayingCard *)card;
//            if (otherPlayingCard.rank == self.rank) {
//                score = 4;
//                NSLog(@"rank matched");
//            }
//            else if ([otherPlayingCard.suit isEqualToString:self.suit]) {
//                score = 1;
//                NSLog(@"suit matched");
//            }
//        }
//    }
    
    for (PlayingCard *otherCard in otherCards) {
        if (otherCard.rank == self.rank) {
            score = 4;
            NSLog(@"rank matched");
        }
        else if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
            NSLog(@"suit matched");
        }
    }
    
    return score;
}

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits {
    return @[@"♥", @"♦", @"♣", @"♠"];
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A" ,@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [[self rankStrings] count]-1;
}

- (void)setRank:(NSInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
