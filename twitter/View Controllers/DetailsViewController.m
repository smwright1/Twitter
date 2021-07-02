//
//  DetailsViewController.m
//  twitter
//
//  Created by Storm Wright on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIManager.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];

    self.profileImageView.image = [UIImage imageWithData:urlData];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    self.profileImageView.layer.masksToBounds = YES;
    
    
    self.nameLabel.text = self.tweet.user.name;
    self.usernameLabel.text = self.tweet.user.screenName;
    self.dateLabel.text = self.tweet.createdAtString;
    self.tweetLabel.text = self.tweet.text;
    
    self.replyButton.tintColor = [UIColor systemGrayColor];
    [self.retweetButton setTitle:[NSString stringWithFormat: @"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
    self.retweetButton.tintColor = [UIColor systemGrayColor];
    if (self.tweet.retweeted) {
        [self.retweetButton setImage: [UIImage systemImageNamed:@"arrow.2.squarepath"] forState:UIControlStateNormal];
        self.retweetButton.tintColor = [UIColor systemGreenColor];
        self.retweetButton.titleLabel.textColor = [UIColor systemGreenColor];
    }
    self.favoriteButton.tintColor = [UIColor systemGrayColor];
    [self.favoriteButton setTitle:[NSString stringWithFormat: @"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
    if (self.tweet.favorited) {
        [self.favoriteButton setImage: [UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        self.favoriteButton.tintColor = [UIColor systemRedColor];
        self.favoriteButton.titleLabel.textColor = [UIColor systemRedColor];
    }
    self.messageButton.tintColor = [UIColor systemGrayColor];
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
        [self.retweetButton setImage: [UIImage systemImageNamed:@"arrow.2.squarepath"] forState:UIControlStateNormal];
        self.retweetButton.tintColor = [UIColor systemGreenColor];
//        self.retweetButton.titleLabel.textColor = [UIColor systemGreenColor];
    }
    else {
        [self.retweetButton setImage: [UIImage systemImageNamed:@"arrow.2.squarepath"] forState:UIControlStateNormal];
        self.retweetButton.tintColor = [UIColor systemGrayColor];
    }
    [self.favoriteButton setTitle:[NSString stringWithFormat: @"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
    if (self.tweet.favorited) {
        [self.favoriteButton setImage: [UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        self.favoriteButton.tintColor = [UIColor systemRedColor];
//        self.favoriteButton.titleLabel.textColor = [UIColor systemRedColor];
    }
    else {
        [self.favoriteButton setImage: [UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        self.favoriteButton.tintColor = [UIColor systemGrayColor];
    }
}

@end
