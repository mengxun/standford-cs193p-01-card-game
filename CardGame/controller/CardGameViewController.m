//
//  CardGameViewController.m
//  CardGame
//
//  Created by Henry on 1/26/13.
//  Copyright (c) 2013 Henry. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "QuartzCore/QuartzCore.h"

@interface CardGameViewController()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipResultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cardMatchNumberSegmentedControll;
@property (strong, nonatomic) UIImage *cardBackImage;

@end

@implementation CardGameViewController
@synthesize cardButtons = _cardButtons;

-(UIImage*) cardBackImage{
    if(!_cardBackImage){
        _cardBackImage = [UIImage imageNamed:@"steve-jobs.png"];
    }
    return _cardBackImage;
}

-(CardMatchingGame*) game{
    if(!_game){
        _game = [[CardMatchingGame alloc]initWithWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc]init] withMatchCardNumber:self.cardMatchNumberSegmentedControll.selectedSegmentIndex+2];
    }
    return _game;
}

-(void) setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    [self updateUI];    
}

-(NSArray*) cardButtons{
    return _cardButtons;
}


- (void)setFlipCount:(int)flipCount{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %i",self.flipCount];
}

+ (NSString*) getFlipResultString:(CardMatchingGame*)game{
    NSString *lastFlipResult = @"";
    
    if(game.pointsEarnInLastOperation == FLIP_PENALTY ){
        
        Card *flippedCard = [game.cardsInlastOperation lastObject];
        lastFlipResult = [@"Flipped up " stringByAppendingString:flippedCard.contents];
        
    }else if(game.pointsEarnInLastOperation > 0){
        
        lastFlipResult = @"Matched ";
        for(Card *matchedCard in game.cardsInlastOperation){
            lastFlipResult = [lastFlipResult stringByAppendingString:matchedCard.contents];
            if(![[game.cardsInlastOperation lastObject] isEqual:matchedCard]){
                lastFlipResult = [lastFlipResult stringByAppendingString:@" & "];
            }
        }
        lastFlipResult = [lastFlipResult stringByAppendingString:[NSString stringWithFormat:@" for %d points", game.pointsEarnInLastOperation]];
        
        
    }else if(game.pointsEarnInLastOperation < 0){
        
        for(Card *matchedCard in game.cardsInlastOperation){
            lastFlipResult = [lastFlipResult stringByAppendingString:matchedCard.contents];
            if(![[game.cardsInlastOperation lastObject] isEqual:matchedCard]){
                lastFlipResult = [lastFlipResult stringByAppendingString:@" & "];
            }
        }
        lastFlipResult = [lastFlipResult stringByAppendingString:@" don't mach!"];
        lastFlipResult = [lastFlipResult stringByAppendingString:[NSString stringWithFormat:@" %d points penalty!", abs(game.pointsEarnInLastOperation)]];
        
        
    }
    
    return lastFlipResult;
}

- (void)updateUI{
    
    for(UIButton *button in self.cardButtons){
        Card *card = [self.game cardAtIndex: [self.cardButtons indexOfObject:button]];
        [button setTitle:card.contents forState:UIControlStateSelected];
        [button setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        [button setTitle:card.contents forState:UIControlStateNormal ];
        [button setImageEdgeInsets:UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5)];
        [button setImage:card.isFaceup? nil : self.cardBackImage forState:UIControlStateNormal];

        if(button.selected != card.isFaceup){
            [UIView beginAnimations:@"flipbutton" context:NULL];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:button cache:YES];
            [UIView commitAnimations];
        }
        
        button.selected = card.isFaceup;
        button.enabled = !card.isUnplayable;
        button.alpha = card.isUnplayable ? 0.3 : 1;

    }
    self.scoreLabel.text = [NSString stringWithFormat:@"score:%d",self.game.score];
    
    self.lastFlipResultLabel.text = [CardGameViewController getFlipResultString:self.game];

    self.cardMatchNumberSegmentedControll.enabled = self.game.score ? NO : YES;
    
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self updateUI];
    self.flipCount++;
    
}

- (IBAction)dealButtonClicked:(id)sender {
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
}

@end