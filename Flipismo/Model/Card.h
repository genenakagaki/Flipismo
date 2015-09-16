//
//  Card.h
//  Flipismo
//
//  Created by User on 9/9/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString* contents;

@property (nonatomic, getter = isChosen)  BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)match:(NSArray *)card;

@end
