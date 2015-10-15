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
    
    // first loop checks if all values are same
    for (SetCard *otherCard in otherCards) {
        if (![self.shape isEqualToString:otherCard.shape]) {
            
            // if there are different values, check if every values are different
            if ([self hasDifferentShapes:otherCards]) {
                return 0;
            }
            break;
        }
    }
    
    for (SetCard *otherCard in otherCards) {
        if (self.shading != otherCard.shading) {
            if ([self hasDifferentShadings:otherCards]) {
                return 0;
            }
            break;
        }
    }
    
    
    
    return score;
}

- (BOOL)hasDifferentShapes:(NSArray *)otherCards {
    for (SetCard *otherCard in otherCards) {
        if ([self.shape isEqualToString:otherCard.shape]) {
            return NO;
        }
    }
    
    SetCard *firstCard = [otherCards 0];
    for (int i = 1; i < [otherCards count]; i ++) {
        if ([self.shape isEqualToString:[otherCards i].shape]) {
            return NO;
        }
    }

    return YES;
}

- (BOOL)hasDifferentColors:(NSArray *)otherCards {
    for (SetCard *otherCard in otherCards) {
        if ([self.color isEqual:otherCard.color]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)hasDifferentShadings:(NSArray *)otherCards {
    for (SetCard *otherCard in otherCards) {
        if (self.shading == otherCard.shading) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)hasDifferentNumbers:(NSArray *)otherCards {
    for (SetCard *otherCard in otherCards) {
        if (self.num == otherCard.num) {
            return NO;
        }
    }
    return YES;
}


- (NSArray *)validShapes {
    return @[@"▲", @"⬤", @"◼"];
}



@end
