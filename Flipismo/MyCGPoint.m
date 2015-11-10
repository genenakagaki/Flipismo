//
//  MyCGPoint.m
//  Flipismo
//
//  Created by User on 11/9/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "MyCGPoint.h"

@implementation MyCGPoint

- (instancetype)initWithPoint:(CGPoint)cgPoint {
    self = [super init];
    
    if (self) {
        self.cgPoint = cgPoint;
    }
    
    return self;
}

@end
