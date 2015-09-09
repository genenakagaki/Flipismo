//
//  PlayingCard.m
//  Flipismo
//
//  Created by User on 9/9/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents {
    NSArray *rankStrings = @[@"?", @"A" ,@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit {
    if ([@[@"♥︎", @"♦︎", @"♣️", @"♠️"] containsObject:suit]) {
        _suit = suit;
    }
}

@end
