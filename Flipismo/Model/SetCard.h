//
//  SetCard.h
//  Flipismo
//
//  Created by User on 10/14/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "Card.h"

@interface SetCard : NSObject

@property (strong, nonatomic) NSString *shape;
@property (nonatomic) UIColor *color;
@property (nonatomic) NSInteger shading;
@property (nonatomic) NSInteger num;

+ (NSArray *)validShapes;
+ (NSUInteger)maxRank;

@end
