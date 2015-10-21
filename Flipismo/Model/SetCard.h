//
//  SetCard.h
//  Flipismo
//
//  Created by User on 10/14/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *shape;
@property (nonatomic) NSString *color;
@property (nonatomic) NSString *shading;
@property (nonatomic) NSInteger num;

+ (NSArray *)validShapes;
+ (NSArray *)validColors;
+ (NSArray *)validShading;
+ (NSUInteger)maxNum;

@end
