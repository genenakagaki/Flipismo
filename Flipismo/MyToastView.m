//
//  MyToastView.m
//  Flipismo
//
//  Created by User on 11/11/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "MyToastView.h"

@interface MyToastView()

@property (nonatomic)NSString *text;

@end

@implementation MyToastView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *transparent = [UIColor whiteColor];
        transparent = [transparent colorWithAlphaComponent:0.0];
        self.backgroundColor = transparent;
        self.alpha = 0;
    }
    return self;
}

- (void)showToast:(NSString *)text {
    self.text = text;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // dont draw if toast is showing
    if (self.alpha == 0) {
        // rounded rect
        UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                               cornerRadius:10];
        [roundedRect addClip];
        [[UIColor whiteColor] setFill];
        UIRectFill(self.bounds);
        
        UIFont* font = [UIFont fontWithName:@"Arial" size:20];
        UIColor* textColor = [UIColor blackColor];
        NSDictionary* stringAttrs = @{NSFontAttributeName : font,
                                      NSForegroundColorAttributeName: textColor };
        
        NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:self.text attributes:stringAttrs];
        
        [attrStr drawAtPoint:CGPointMake((self.frame.size.width - attrStr.size.width) /2,
                                         8)];
        
        [self animateShowToast];
        [self performSelector:@selector(animateHideToast)
                   withObject:nil
                   afterDelay:1.5];
    }
}

- (void)animateShowToast {
    [UIView animateWithDuration: 0.3
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = 0.8;
                     }
                     completion:nil];
}

- (void)animateHideToast {
    [UIView animateWithDuration: 0.3
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:nil];
}

@end
