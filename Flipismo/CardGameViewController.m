//
//  CardGameViewController.m
//  Flipismo
//
//  Created by User on 9/10/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"
#import "History.h"
#import "HistoryViewController.h"
#import "PlayingCardView.h"
#import "Grid.h"

@interface CardGameViewController ()
@property (nonatomic) NSString *className;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (weak, nonatomic) IBOutlet UIView *gameView;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (IBAction)touchDealButton:(UIButton *)sender;

@end

@implementation CardGameViewController

static const CGSize CARD_SIZE = {40, 60};

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"%@: %@", [self className], @"didRotateFromInterfaceOrientation");
    _grid = nil;
    [self dealCards];
}

- (NSString *)className {
    return NSStringFromClass([self class]);
}

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.grid.minimumNumberOfCells
                                                  usingDeck:[self createDeck]];
        [self createCardViews];
        
        self.game.numToMatch = 2;
    }
    return _game;
}

- (Grid *)grid {
    if (!_grid) {
        _grid = [[Grid alloc] init];
        _grid.cellAspectRatio = CARD_SIZE.width / CARD_SIZE.height;
        _grid.size = self.gameView.bounds.size;
        _grid.minimumNumberOfCells = 28;
    }
    
    return _grid;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (void)createCardViews {
    NSLog(@"%@: %@", [self className], @"createCardViews");
    
    self.cardViews = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.grid.minimumNumberOfCells; i++) {
        PlayingCardView *cardView = [[PlayingCardView alloc] init];
        
        UIColor *transparent = [UIColor whiteColor];
        transparent = [transparent colorWithAlphaComponent:0.0f];
        cardView.backgroundColor = transparent;
        
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:[self.cardViews count]];
        cardView.rank = card.rank;
        cardView.suit = card.suit;
        
        [self.gameView addSubview:cardView];
        
        [self.cardViews addObject:cardView];
    }
    
    [self dealCards];
    
    NSLog(@"%@: %@", [self className], @"createCardViews done");
}

- (void)dealCards {
    NSLog(@"%@: %@", [self className], @"dealCards");
    
    float delay = 0.1;
    
    int row = 0;
    int col = 0;
    for (int i = 0; i < [self.cardViews count]; i++) {
        
        PlayingCardView *cardView = [self.cardViews objectAtIndex:i];
        
        CGRect cell = [self.grid frameOfCellAtRow:row inColumn:col];
        CGRect frame = CGRectMake(0, 0, cell.size.width-8, cell.size.height-8);
        cardView.frame = frame;
        
        
        [self animateCardTranslation:cardView
                             toPoint:[self.grid centerOfCellAtRow:row inColumn:col]
                           withDelay:delay * i];
        
        col++;
        if (col >= self.grid.columnCount) {
            col = 0;
            row++;
        }
    }
}

- (IBAction)touchDealButton:(UIButton *)sender {
    NSLog(@"%@: %@", [self className], @"touchDealButton");
    _game = nil;
    
    [self updateUI];
}

- (void)animateCardTranslation:(PlayingCardView *)cardView
                       toPoint:(CGPoint)point
                     withDelay:(float)delay {
    [UIView animateWithDuration:1.0
                          delay: delay
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         cardView.center = point;
                     }
                     completion:nil];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    NSLog(@"%@: %@", [self className], @"tap");
    
    CGPoint tapLocation = [sender locationInView:self.gameView];
    for (PlayingCardView *cardView in self.cardViews) {
        if (CGRectContainsPoint([cardView frame], tapLocation)) {
            [self.game chooseCardAtIndex:[self.cardViews indexOfObject:cardView]];
            
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:nil context:context];
            
            [UIView setAnimationTransition:(cardView.faceUp)?UIViewAnimationTransitionFlipFromLeft:UIViewAnimationTransitionFlipFromRight  forView:cardView cache:YES];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.25];
            [UIView commitAnimations];
        }
        
    }
    
    [self updateUI];
}

- (void)animateFlip {
    
}

-(void)updateUI {
    NSLog(@"%@: %@", [self className], @"updateUI");
    
    int row = 0;
    int col = 0;
    for (PlayingCardView *cardView in self.cardViews) {
        col++;
        if (col >= 6) {
            col = 0;
            row++;
        }
        
        Card *card = [self.game cardAtIndex:[self.cardViews indexOfObject:cardView]];
        if (card.matched) {
            cardView.alpha = 0.3;
        }
        if (card.isChosen) {
            cardView.faceUp = YES;
        }
        else {
            cardView.faceUp = NO;
        }
    }
    
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
