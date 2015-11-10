//
//  MyCGPoint.h
//  Flipismo
//
//  Created by User on 11/9/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCGPoint : NSObject

- (instancetype)initWithPoint:(CGPoint)cgPoint;

@property (nonatomic) CGPoint cgPoint;

@end
