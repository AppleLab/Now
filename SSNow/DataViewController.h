//
//  DataViewController.h
//  SSNow
//
//  Created by itisioslab on 21.08.14.
//  Copyright (c) 2014 kpfu.itisioslab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *lastnamelabel;
@property (weak, nonatomic) IBOutlet UILabel *labelForStatus;

@property (weak, nonatomic) IBOutlet UIImageView *UserPhoto;

@end
