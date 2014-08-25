//
//  DataViewController.m
//  SSNow
//
//  Created by itisioslab on 21.08.14.
//  Copyright (c) 2014 kpfu.itisioslab. All rights reserved.
//

#import "DataViewController.h"
#import "VkLoginViewController1.h"
@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"first_name"];
    NSString *lastname = [[NSUserDefaults standardUserDefaults]objectForKey:@"last_name"];
   NSString *onlinestr = [[NSUserDefaults standardUserDefaults]objectForKey:@"online"];
    self.namelabel.text = [NSString stringWithFormat:@"%@ %@",name,lastname];
    self.labelForStatus.text = onlinestr;
    self.UserPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"photo_50"]]]];

    self.namelabel.numberOfLines = 0;
    [self.namelabel sizeToFit];
    NSLog(@"I'm here");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

@end
