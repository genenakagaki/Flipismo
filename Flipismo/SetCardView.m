//
//  PlayingCardView.m
//  SuperCard
//
//  Created by Sameh Fakhouri on 10/14/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation SetCardView

#pragma mark - Properties

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.80

- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) {
        _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    }
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (void)setShape:(NSString *)shape {
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading {
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setNum:(NSInteger)num {
    _num = num;
    [self setNeedsDisplay];
}

- (void)setGameCardIndex:(NSInteger)gameCardIndex {
    _gameCardIndex = gameCardIndex;
    [self setNeedsDisplay];
}

- (void)setIsChosen:(BOOL)isChosen {
    _isChosen = isChosen;
    [self setNeedsDisplay];
}

#pragma mark - Gesture Recognizers

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1.0;
    }
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor
{
    return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius
{
    return CORNER_RADIUS * [self cornerScaleFactor];
}

- (CGFloat)cornerOffset
{
    return [self cornerRadius] / 3.0;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    
    NSLog(@"is");
    if (self.isChosen) {
        [[UIColor redColor] setStroke];
        roundedRect.lineWidth = 4.0;
        
        NSLog(@"ischosen");
    }
    else {
        [[UIColor blackColor] setStroke];
        NSLog(@"ischosen not");
    }

    [roundedRect stroke];
    
    CGRect shapeBounds = CGRectMake(self.bounds.origin.x,
                                   self.bounds.origin.y,
                                   self.bounds.size.width/3,
                                   self.bounds.size.height);
    
    NSMutableArray *shapeBoundsArr = [[NSMutableArray alloc] init];
    
    // Get positions for each shape in card and draw
    if (self.num == 1 ) {
        shapeBounds.origin.x = shapeBounds.origin.x + shapeBounds.size.width;
        MyCGRect *shapeBoundsObj = [[MyCGRect alloc] initWithCGRect:shapeBounds];
        
        [shapeBoundsArr addObject:shapeBoundsObj];
        
        [self drawCardContentWith:shapeBoundsArr];
    }
    else if (self.num == 2) {
        shapeBounds.origin.x = shapeBounds.origin.x + shapeBounds.size.width/2;
        MyCGRect *shapeBoundsObj = [[MyCGRect alloc] initWithCGRect:shapeBounds];
        [shapeBoundsArr addObject:shapeBoundsObj];
        
        shapeBounds.origin.x = shapeBounds.origin.x + shapeBounds.size.width;
        shapeBoundsObj = [[MyCGRect alloc] initWithCGRect:shapeBounds];
        [shapeBoundsArr addObject:shapeBoundsObj];
        
        [self drawCardContentWith:shapeBoundsArr];
    }
    else if (self.num == 3) {
        MyCGRect *shapeBoundsObj = [[MyCGRect alloc] initWithCGRect:shapeBounds];
        [shapeBoundsArr addObject:shapeBoundsObj];
        
        shapeBounds.origin.x = shapeBounds.origin.x + shapeBounds.size.width;
        shapeBoundsObj = [[MyCGRect alloc] initWithCGRect:shapeBounds];
        [shapeBoundsArr addObject:shapeBoundsObj];
        
        shapeBounds.origin.x = shapeBounds.origin.x + shapeBounds.size.width;
        shapeBoundsObj = [[MyCGRect alloc] initWithCGRect:shapeBounds];
        [shapeBoundsArr addObject:shapeBoundsObj];
        
        [self drawCardContentWith:shapeBoundsArr];
    }
    
    NSLog(@"%f: %f", self.bounds.size.width, self.bounds.size.height);
}

- (void)drawCardContentWith:(NSArray *)shapeBoundsArr {
    if ([self.shape isEqualToString:@"diamond"]) {
        for (int i = 0; i < self.num; i++) {
            [self drawDiamondIn:[shapeBoundsArr objectAtIndex:i]];
        }
    }
    else if ([self.shape isEqualToString:@"oval"] ) {
        for (int i = 0; i < self.num; i++) {
            [self drawOvalIn:[shapeBoundsArr objectAtIndex:i]];
        }
    }
    else if ([self.shape isEqualToString:@"squiggle"]) {
        for (int i = 0; i < self.num; i++) {
            [self drawSquiggleIn:[shapeBoundsArr objectAtIndex:i]];
        }
    }
}

- (void)drawDiamondIn:(MyCGRect *)boundsObj {
    CGRect bounds = boundsObj.cgRect;
    
    CGRect rect = CGRectInset(bounds,
                              bounds.size.width * (1.0 - self.faceCardScaleFactor),
                              bounds.size.height * (1.0 - self.faceCardScaleFactor));
    
    UIBezierPath *p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(rect.origin.x + rect.size.width/2,
                               rect.origin.y)];
    [p addLineToPoint:CGPointMake(rect.origin.x + rect.size.width,
                                  rect.origin.y + rect.size.height/2)];
    [p addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2,
                                  rect.origin.y + rect.size.height)];
    [p addLineToPoint:CGPointMake(rect.origin.x,
                                  rect.origin.y + rect.size.height/2)];
    [p closePath];
    
    [self setColorAndShading];
    
    [p stroke];
    [p fill];
}

- (void)drawOvalIn:(MyCGRect *)boundsObj {
    CGRect bounds = boundsObj.cgRect;
    
    CGRect rect = CGRectInset(bounds,
                              bounds.size.width * (1.0 - self.faceCardScaleFactor),
                              bounds.size.height * (1.0 - self.faceCardScaleFactor));
    
    UIBezierPath *oval = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:30];
    
    [self setColorAndShading];
    
    [oval stroke];
    [oval fill];
}

- (void)drawSquiggleIn:(MyCGRect *)boundsObj {
    CGRect bounds = boundsObj.cgRect;
    
    CGRect rect = CGRectInset(bounds,
                              bounds.size.width * (1.0 - self.faceCardScaleFactor),
                              bounds.size.height * (1.0 - self.faceCardScaleFactor));
    
    int width = rect.size.width;
    int height = rect.size.height;
    
    CGPoint center = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2);
    UIBezierPath *squiggle = [UIBezierPath bezierPath];
    
    [squiggle moveToPoint:CGPointMake(center.x - width/3, center.y - (height * 2)/5)];
    
    [squiggle addQuadCurveToPoint:CGPointMake(center.x + width/3, center.y)
                     controlPoint:CGPointMake(center.x + (width * 3)/5, center.y - (height * 2)/5)];
    
    [squiggle addCurveToPoint:CGPointMake(center.x + width/3, center.y + (height * 2)/5)
                controlPoint1:CGPointMake(center.x + width/6, center.y + height/5)
                controlPoint2:CGPointMake(center.x + width/2, center.y + height/3)];
    
    [squiggle addQuadCurveToPoint:CGPointMake(center.x - width/3, center.y)
                     controlPoint:CGPointMake(center.x - (width * 3)/5, center.y + (height * 2)/5)];
    
    [squiggle addCurveToPoint:CGPointMake(center.x - width/3, center.y - (height * 2)/5)
                controlPoint1:CGPointMake(center.x - width/6, center.y - height/5)
                controlPoint2:CGPointMake(center.x - width/2, center.y - height/3)];
    
    [self setColorAndShading];
    
    [squiggle stroke];
    [squiggle fill];
}

- (float)angleToRadians:(int)angle {
    return (3.14 * (angle))/ 180;
}

- (void)setColorAndShading {
    // Color
    UIColor *color = [UIColor redColor];
    if ([self.color isEqualToString:@"red"]) {
        color = [UIColor redColor];
    }
    else if ([self.color isEqualToString:@"green"]) {
        color = [UIColor greenColor];
    }
    else if ([self.color isEqualToString:@"purple"]) {
        color = [UIColor purpleColor];
    }
    
    // Shading
    if ([self.shading isEqualToString:@"filled"]) {
        [color setStroke];
        [color setFill];
    }
    else if ([self.shading isEqualToString:@"shaded"]) {
        [color setStroke];
        
        color = [color colorWithAlphaComponent:0.3f];
        [color setFill];
        
    }
    else if ([self.shading isEqualToString:@"outlined"]) {
        [color setStroke];
        [[UIColor whiteColor] setFill];
        
    }
}


//- (void)drawCorners
//{
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//    
//    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
//    
//    NSString *cornerTextString = [NSString stringWithFormat:@"%@\n%@",
//                                  [self rankAsString],
//                                  self.suit];
//    
//    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:cornerTextString
//                                                                     attributes:@{NSFontAttributeName : cornerFont,
//                                                                                  NSParagraphStyleAttributeName : paragraphStyle}];
//    
//    CGRect textBounds;
//    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
//    textBounds.size = [cornerText size];
//    [cornerText drawInRect:textBounds];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
//    CGContextRotateCTM(context, M_PI);
//    
//    [cornerText drawInRect:textBounds];
//}

#pragma mark - Pips

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270


//- (void)drawPips
//{
//    if ((self.rank == 1) ||
//        (self.rank == 3) ||
//        (self.rank == 5) ||
//        (self.rank == 9)) {
//        
//        [self drawPipsWithHorizontalOffset:0
//                            verticalOffset:0
//                        mirroredVertically:NO];
//        
//    }
//    
//    if ((self.rank == 6) ||
//        (self.rank == 7) ||
//        (self.rank == 8)) {
//        
//        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
//                            verticalOffset:0
//                        mirroredVertically:NO];
//        
//    }
//    
//    if ((self.rank == 2) ||
//        (self.rank == 3) ||
//        (self.rank == 7) ||
//        (self.rank == 8) ||
//        (self.rank == 10)) {
//        
//        [self drawPipsWithHorizontalOffset:0
//                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
//                        mirroredVertically:(self.rank != 7)];
//        
//    }
//    
//    if ((self.rank == 4) ||
//        (self.rank == 5) ||
//        (self.rank == 6) ||
//        (self.rank == 7) ||
//        (self.rank == 8) ||
//        (self.rank == 9) ||
//        (self.rank == 10)) {
//        
//        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
//                            verticalOffset:PIP_VOFFSET3_PERCENTAGE
//                        mirroredVertically:YES];
//        
//    }
//    
//    if ((self.rank == 9) ||
//        (self.rank == 10)) {
//        
//        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
//                            verticalOffset:PIP_VOFFSET1_PERCENTAGE
//                        mirroredVertically:YES];
//        
//    }
//}
//
//- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
//                      verticalOffset:(CGFloat)voffset
//                  mirroredVertically:(BOOL)mirroredVertically
//{
//    [self drawPipsWithHorizontalOffset:hoffset
//                        verticalOffset:voffset
//                            upsideDown:NO];
//    
//    if (mirroredVertically) {
//        [self drawPipsWithHorizontalOffset:hoffset
//                            verticalOffset:voffset
//                                upsideDown:YES];
//    }
//}


#define PIP_FONT_SCALE_FACTOR 0.012

//- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
//                      verticalOffset:(CGFloat)voffset
//                          upsideDown:(BOOL)upsideDown
//{
//    if (upsideDown) {
//        [self pushContextAndRotateUpsideDown];
//    }
//    
//    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
//    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
//    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit
//                                                                         attributes:@{NSFontAttributeName : pipFont}];
//    CGSize pipSize = [attributedSuit size];
//    CGPoint pipOrigin = CGPointMake(middle.x - pipSize.width/2.0  - hoffset*self.bounds.size.width,
//                                    middle.y - pipSize.height/2.0 - voffset*self.bounds.size.height);
//    [attributedSuit drawAtPoint:pipOrigin];
//    
//    if (hoffset) {
//        pipOrigin.x += hoffset * 2.0 * self.bounds.size.width;
//        [attributedSuit drawAtPoint:pipOrigin];
//    }
//    
//    if (upsideDown) {
//        [self popContext];
//    }
//}

- (void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
