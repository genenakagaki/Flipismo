//
//  CardGameViewController.m
//  Flipismo
//
//  Created by User on 9/10/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "SetGameViewController.h"

@interface SetGameViewController ()

@property (nonatomic) int gameCardIndex;

@property (weak, nonatomic) IBOutlet UIButton *deal3Button;

- (IBAction)touchCheatButton:(id)sender;

@property (nonatomic)MyToastView *toast;

@end

@implementation SetGameViewController

@synthesize toast = _toast;

static const CGSize CARD_SIZE = {60, 40};

static const int CARD_COUNT = 81;

- (void)log:(NSString *)string {
    NSLog(@"%@: %@", NSStringFromClass([self class]), string);
}

- (MyToastView *)toast {
    if (!_toast) {
        _toast = [[MyToastView alloc]
                  initWithFrame:CGRectMake(40,
                                           self.view.frame.size.height - 140,
                                           self.view.frame.size.width - 80,
                                           40)];
        [self.view addSubview:_toast];
    }
    
    return _toast;
}

- (void)gameConfig {
    self.gameCardNum = 81;
    self.numToMatch  = 3;
    
    self.gameCardIndex = 0;
}

- (void)gridConfig {
    self.grid.cellAspectRatio = CARD_SIZE.width / CARD_SIZE.height;
    self.grid.size = self.gameView.bounds.size;
    self.grid.minimumNumberOfCells = 28;
}

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (void)createCardViews {
    [self log:@"createCardViews"];
    
    super.cardViews = [[NSMutableArray alloc] init];
    
    int startingCardCount = 12;
    
    for (int i = 0; i < startingCardCount; i++) {
        [self createCardView];
    }
    
    [self log:@"createCardViews done"];
}

- (void)createCardView {
    if (self.gameCardIndex >= CARD_COUNT) {
        [self.toast showToast:@"No more cards in deck"];
        
        return;
    }
    
    SetCardView *cardView = [[SetCardView alloc] init];
    
    UIColor *transparent = [UIColor whiteColor];
    transparent = [transparent colorWithAlphaComponent:0.0f];
    
    cardView.backgroundColor = transparent;
    
    SetCard *card = (SetCard *)[self.game cardAtIndex:self.gameCardIndex];
    cardView.shape   = card.shape;
    cardView.color   = card.color;
    cardView.shading = card.shading;
    cardView.num     = card.num;
    cardView.gameCardIndex = self.gameCardIndex;
    
    self.gameCardIndex ++;
    
    [self.gameView addSubview:cardView];
    
    [self.cardViews addObject:cardView];
}

- (void)handleCardChoose:(SetCardView *)cardView {
    [self.game chooseCardAtIndex:cardView.gameCardIndex];
    
    // TODO: highlight
}

- (IBAction)touchDealThree:(UIButton *)sender {
    NSMutableArray *cardArr = [[NSMutableArray alloc] init];
    for (SetCardView *cardView in self.cardViews) {
        [cardArr addObject:[self.game cardAtIndex:cardView.gameCardIndex]];
    }
    
    NSArray *matches = [self.game getIndiciesOfMatches:cardArr];
    
    
    
    int updateIndex = 0;
    
    for (int i = 0; i < 3; i ++) {
        if ([self.cardViews count] < [self.grid minimumNumberOfCells]) {
            [self createCardView];
            
            if (updateIndex == 0) {
                updateIndex = [self.cardViews count] -1;
            }
        }
    }
    
    if (updateIndex == CARD_COUNT -1) {
        return;
    }
    
    if (updateIndex == 0) {
        [self.toast showToast:@"Display card limit reached"];
    }
    else if ([matches count] > 0) {
        [self.toast showToast:@"Missed matches: -2pts"];
        [self.game addScore:-2];
    }
    
    [self updateCardsFrom:updateIndex];
    
    [self updateUI];
}

- (IBAction)touchCheatButton:(id)sender {
    NSMutableArray *cardArr = [[NSMutableArray alloc] init];
    for (SetCardView *cardView in self.cardViews) {
        [cardArr addObject:[self.game cardAtIndex:cardView.gameCardIndex]];
    }
    
    NSArray *matches = [self.game getIndiciesOfMatches:cardArr];
    
    if ([matches count] > 0) {
        [self.toast showToast:@"You are cheating..."];
        
        for (NSNumber *cardIndex in matches) {
            SetCardView *cardView = [self.cardViews objectAtIndex:[cardIndex intValue]];
            cardView.isChosen = YES;
        }
    }
    else {
        [self.toast showToast:@"No more matches"];
    }
}

- (void)updateCardsFrom:(int)index {
    
    if (index == 0) {
        return;
    }
    
    CGPoint point = CGPointMake(0, -200);
    
    int delay = 0.02;
    
    for (int i = index; i < [self.cardViews count]; i++) {
        
        UIView *cardView = [self.cardViews objectAtIndex:i];
        
        int row = i / [self.grid columnCount];
        int col = (i % [self.grid columnCount]);
        
        CGRect cell = [self.grid frameOfCellAtRow:row inColumn:col];
        
        CGSize cardSize = CGSizeMake(cell.size.width - 8, cell.size.height - 8);
        
        CGRect frame = CGRectMake(point.x - cardSize.width/2,
                                  point.y - cardSize.height/2,
                                  cardSize.width,
                                  cardSize.height);
        cardView.frame = frame;
        
        [self animateCardMovement:cardView
                          toPoint:[self.grid centerOfCellAtRow:row inColumn:col]
                        withDelay:delay * i];
        
        col++;
        if (col >= self.grid.columnCount) {
            col = 0;
            row++;
        }
    }
}

- (void)updateUI {
    [self log:@"updateUI" ];
    
    NSMutableArray *cardViewsToRemove = [[NSMutableArray alloc] init];
    
    int row = 0;
    int col = 0;
    for (SetCardView *cardView in self.cardViews) {
        col++;
        if (col >= 6) {
            col = 0;
            row++;
        }
        
        Card *card = [self.game cardAtIndex:cardView.gameCardIndex];
        if (card.matched) {
            [super animateCardMovement:cardView
                               toPoint:CGPointMake(-200, 200)
                             withDelay:0.1f];

            [cardViewsToRemove addObject:cardView];
        }
        
        if (card.isChosen) {
            cardView.isChosen = YES;
        }
        else {
            cardView.isChosen = NO;
        }
    }
    
    for (SetCardView *cardView in cardViewsToRemove) {
        [self.cardViews removeObject:cardView];
    }

    [self cleanCardLayout];
    
    super.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)cleanCardLayout {
    
    float delay = 0.1;
    for (int i = 0; i < [self.cardViews count]; i++) {
        
        UIView *cardView = [self.cardViews objectAtIndex:i];
        
        int row = i / [self.grid columnCount];
        int col = (i % [self.grid columnCount]);
        
        [self animateCardMovement:cardView
                          toPoint:[self.grid centerOfCellAtRow:row inColumn:col]
                        withDelay:delay * i];
        
        col++;
        if (col >= self.grid.columnCount) {
            col = 0;
            row++;
        }
    }
}

@end
