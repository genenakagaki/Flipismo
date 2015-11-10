//
//  TestViewContoller.m
//  Flipismo
//
//  Created by User on 11/2/15.
//  Copyright (c) 2015 Lehman College. All rights reserved.
//

#import "TestViewContoller.h"
#import "SetCardView.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "Config.h"

@interface TestViewContoller ()
@property (nonatomic, strong) Deck *deck;
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;
@end

@implementation TestViewContoller

- (Deck *)deck {
    if (!_deck){
        _deck = [[SetCardDeck alloc] init];
    }
    
    return _deck;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)drawRandomPlayingCard {
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        self.setCardView.shape   = setCard.shape;
        self.setCardView.color   = setCard.color;
        self.setCardView.shading = setCard.shading;
        self.setCardView.num     = setCard.num;
    }
}

- (IBAction)swipe:(id)sender {
    NSLog(@"Swiped");
    
    if (!self.setCardView.faceUp) {
        [self drawRandomPlayingCard];
    }
    self.setCardView.faceUp = !self.setCardView.faceUp;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.setCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]
                                                initWithTarget:self.setCardView
                                                action:@selector(pinchGestureRecognizer)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
