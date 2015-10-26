//
//  History.h
//  Flipismo
//
//  Created by User on 10/21/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface History : NSObject

@property (nonatomic) NSMutableArray *cards;
@property (nonatomic) NSInteger score;

- (void) setScore:(NSInteger)score;

@end
