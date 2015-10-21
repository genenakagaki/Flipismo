//
//  History.m
//  Flipismo
//
//  Created by User on 10/21/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "History.h"

@implementation History

@synthesize cards = _cards;
@synthesize score = _score;

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

- (void)setScore:(NSInteger)score {
    _score = score;
}

@end
