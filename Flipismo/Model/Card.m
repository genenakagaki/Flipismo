//
//  Card.m
//  Flipismo
//
//  Created by User on 9/9/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

@synthesize contents = _contents;

- (NSString *)contents {
    return _contents;
}

- (void)setContents:(NSString *)contents {
    _contents = contents;
}

@synthesize chosen  = _chosen;
@synthesize matched = _matched;

- (BOOL)isChosen {
    return _chosen;
}

- (void)setChosen:(BOOL)chosen {
    _chosen = chosen;
}

- (BOOL)isMatched {
    return _matched;
}

- (void)setMatched:(BOOL)matched {
    _matched = matched;
}

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
            break;
        }
    }
    
    return score;
}


@end
