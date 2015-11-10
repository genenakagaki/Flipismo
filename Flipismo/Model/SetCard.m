//
//  SetCard.m
//  Flipismo
//
//  Created by User on 10/14/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    NSMutableArray *cardProperties = [[NSMutableArray alloc] init];
    
    [cardProperties addObject:self.shape];
    for (SetCard *otherCard in otherCards) {
        [cardProperties addObject:otherCard.shape];
    }
    
    NSLog(@"shape");
    if (![self isSame:cardProperties]) {
        if (![self isDifferentForEach:cardProperties]) {
            NSLog(@"Shape is wrong");
            return score;
        }
    }
    
    [cardProperties removeAllObjects];
    [cardProperties addObject:self.color];
    for (SetCard *otherCard in otherCards) {
        [cardProperties addObject:otherCard.color];
    }
    
    NSLog(@"color");
    if (![self isSame:cardProperties]) {
        if (![self isDifferentForEach:cardProperties]) {
            NSLog(@"Color is wrong");
            return score;
        }
    }
    
    [cardProperties removeAllObjects];
    [cardProperties addObject:[NSString stringWithFormat:@"%d", (int)self.shading]];
    for (SetCard *otherCard in otherCards) {
        [cardProperties addObject:[NSString stringWithFormat:@"%d", (int)otherCard.shading]];
    }
    
    NSLog(@"shading");
    if (![self isSame:cardProperties]) {
        if (![self isDifferentForEach:cardProperties]) {
            NSLog(@"Shading is wrong");
            return score;
        }
    }
    
    [cardProperties removeAllObjects];
    [cardProperties addObject:[NSString stringWithFormat:@"%d", (int)self.num]];
    for (SetCard *otherCard in otherCards) {
        [cardProperties addObject:[NSString stringWithFormat:@"%d", (int)otherCard.num]];
    }
    
    NSLog(@"number");
    if (![self isSame:cardProperties]) {
        if (![self isDifferentForEach:cardProperties]) {
            return score;
        }
    }
    
    score = 3;
    return score;
}

- (BOOL)isSame:(NSArray *)cardProperties {
    NSLog(@"in isSame");

    for (int i = 1; i < [cardProperties count]; i++) {
        // compare first card property to all the other
        NSLog(@"cardProp 0: %@", cardProperties[0]);
        NSLog(@"cardProp %d: %@", i, cardProperties[i]);
        if (![cardProperties[0] isEqualToString:cardProperties[i]]) {
            NSLog(@"isSame NO");
            return NO;
        }
    }
    
    NSLog(@"isSame YES");
    return YES;
}

- (BOOL)isDifferentForEach:(NSArray *)cardProperties {
    NSLog(@"is in different");
    int length = [cardProperties count];
    for (int i = 0; i < length; i++) {
        for (int j = i+1; j < length; j++) {
            if ([cardProperties[i] isEqualToString:cardProperties[j]]) {
                NSLog(@"isDifferent NO");
                return NO;
            }
        }
    }
    
    NSLog(@"isDifferent YES");
    return YES;
}


+ (NSArray *)validShapes {
    return @[@"▲", @"●", @"◼︎"];
}

+ (NSArray *)validColors {
    return @[@"red", @"green", @"blue"];
}

+ (NSArray *)validShading {
    return @[@"filled", @"shaded", @"outlined"];
}

+ (NSUInteger)maxNum {
    return 3;
}


@end
