//
//  TweetCell.m
//  twitter
//
//  Created by Storm Wright on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)didTapFavorite:(id)sender {
    self.tweet.favorited = !self.tweet.favorited;
    if (self.tweet.favorited) {
        self.tweet.favoriteCount += 1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error) {
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else {
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }
    else {
        self.tweet.favoriteCount -= 1;
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error) {
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else {
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
    }
    [self refreshData];
}

- (IBAction)didTapRetweet:(id)sender {
    self.tweet.retweeted = !self.tweet.retweeted;
    if (self.tweet.retweeted) {
        self.tweet.retweetCount += 1;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error) {
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else {
                 NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
             }
         }];
    }
    else {
        self.tweet.retweetCount -= 1;
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error) {
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else {
                 NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
             }
         }];
    }
    [self refreshData];
}

-(void)refreshData{
    [self.retweetButton setTitle:[NSString stringWithFormat: @"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
    if (self.tweet.retweeted) {
        self.retweetButton.tintColor = [UIColor systemGreenColor];
        self.retweetButton.titleLabel.textColor = [UIColor systemGreenColor];
        self.favoriteButton.titleLabel.textColor = [UIColor systemRedColor];
    }
    else {
        self.retweetButton.tintColor = [UIColor systemGrayColor];
        self.retweetButton.titleLabel.textColor = [UIColor systemGrayColor];
        
    }
    [self.favoriteButton setTitle:[NSString stringWithFormat: @"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
    if (self.tweet.favorited) {
        [self.favoriteButton setImage: [UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        self.favoriteButton.tintColor = [UIColor systemRedColor];
        self.favoriteButton.titleLabel.textColor = [UIColor systemRedColor];
        // try tying to state of button
    }
    else {
        [self.favoriteButton setImage: [UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        self.favoriteButton.tintColor = [UIColor systemGrayColor];
        self.favoriteButton.titleLabel.textColor = [UIColor systemGrayColor];
    }
}

@end
