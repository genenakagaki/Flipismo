//
//  SetCard.m
//  Flipismo
//
//  Created by User on 10/14/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (void)log:(NSString *)string {
    NSLog(@"%@: %@", NSStringFromClass([self class]), string);
}

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    NSMutableArray *cardProperties = [[NSMutableArray alloc] init];
    
    [cardProperties addObject:self.shape];
    for (SetCard *otherCard in otherCards) {
        [cardProperties addObject:otherCard.shape];
    }
    
//    [self log:@"shape" ];
    if (![self isSame:cardProperties]) {
        if (![self isDifferentForEach:cardProperties]) {
//            [self log:@"Shape is wrong"];
            return score;
        }
    }
    
    [cardProperties removeAllObjects];
    [cardProperties addObject:self.color];
    for (SetCard *otherCard in otherCards) {
        [cardProperties addObject:otherCard.color];
    }
    
//    [self log:@"color" ];
    if (![self isSame:cardProperties]) {
        if (![self isDifferentForEach:cardProperties]) {
//            [self log:@"Color is wrong"];
            return score;
        }
    }
    
    [cardProperties removeAllObjects];
    [cardProperties addObject:[NSString stringWithFormat:@"%d", (int)self.shading]];
    for (SetCard *otherCard in otherCards) {
        [cardProperties addObject:[NSString stringWithFormat:@"%d", (int)otherCard.shading]];
    }
    
//    [self log:@"shading" ];
    if (![self isSame:cardProperties]) {
        if (![self isDifferentForEach:cardProperties]) {
//            [self log:@"Shading is wrong"];
            return score;
        }
    }
    
    [cardProperties removeAllObjects];
    [cardProperties addObject:[NSString stringWithFormat:@"%d", (int)self.num]];
    for (SetCard *otherCard in otherCards) {
        [cardProperties addObject:[NSString stringWithFormat:@"%d", (int)otherCard.num]];
    }
    
//    [self log:@"number" ];
    if (![self isSame:cardProperties]) {
        if (![self isDifferentForEach:cardProperties]) {
            return score;
        }
    }
    
    score = 3;
    return score;
}

- (BOOL)isSame:(NSArray *)cardProperties {
//    [self log:@"in isSame" ];

    for (int i = 1; i < [cardProperties count]; i++) {
        // compare first card property to all the other
//        [self log:[NSString stringWithFormat:@"cardProp 0: %@", cardProperties[0]]];
//        [self log:[NSString stringWithFormat:@"cardProp %d: %@", i, cardProperties[i]]];
        if (![cardProperties[0] isEqualToString:cardProperties[i]]) {
//            [self log:@"isSame NO" ];
            return NO;
        }
    }
    
//    [self log:@"isSame YES" ];
    return YES;
}

- (BOOL)isDifferentForEach:(NSArray *)cardProperties {
//    [self log:@"is in different" ];
    int length = [cardProperties count];
    for (int i = 0; i < length; i++) {
        for (int j = i+1; j < length; j++) {
            if ([cardProperties[i] isEqualToString:cardProperties[j]]) {
//                [self log:@"isDifferent NO" ];
                return NO;
            }
        }
    }
    
//    [self log:@"isDifferent YES" ];
    return YES;
}


+ (NSArray *)validShapes {
    return @[@"diamond", @"oval", @"squiggle"];
}

+ (NSArray *)validColors {
    return @[@"red", @"green", @"purple"];
}

+ (NSArray *)validShading {
    return @[@"filled", @"shaded", @"outlined"];
}

+ (NSUInteger)maxNum {
    return 3;
}


@end
