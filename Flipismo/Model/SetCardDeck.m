//
//  SetCardDeck.m
//  Flipismo
//
//  Created by User on 10/19/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init {
    self = [super init];
    
    if (self) {
        for (NSString *shape in [SetCard validShapes]) {
            for (NSArray *color in [SetCard validColors]) {
                for (NSArray *shading in [SetCard validShading]) {
                    for (NSUInteger num = 1; num <= [SetCard maxNum]; num++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.shape = shape;
                        card.color = (NSString *)color;
                        card.shading = (NSString *)shading;
                        card.num = num;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
