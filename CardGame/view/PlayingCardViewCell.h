//
//  PlayingCardViewCell.h
//  CardGame
//
//  Created by Henry on 2/18/13.
//  Copyright (c) 2013 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardViewCell : UICollectionViewCell
@property (nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) BOOL faceup;
@end
