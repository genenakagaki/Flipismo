//
//  PlayingCard.h
//  Flipismo
//
//  Created by User on 9/9/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSInteger rank;

@end
