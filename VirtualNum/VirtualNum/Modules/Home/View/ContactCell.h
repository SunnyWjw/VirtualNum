//
//  ContactCell.h
//  Ltalk
//  Copyright (c) 2015年 Ltalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UIButton *callButton;

@property (weak, nonatomic) IBOutlet UIImageView *isRegistered;

@end
