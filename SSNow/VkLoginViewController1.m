//
//  VkLoginViewController1.m
//  SSNow
//
//  Created by itisioslab on 22.08.14.
//  Copyright (c) 2014 kpfu.itisioslab. All rights reserved.
//

#import "VkLoginViewController1.h"
@interface VkLoginViewController1 ()

@end

@implementation VkLoginViewController1
@synthesize authView, indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    authView.hidden = YES;
    NSString *authString = @"http://api.vkontakte.ru/oauth/authorize?client_id=4517157&scope=friends,photos,groups&redirect_uri=http://api.vkontakte.ru/blank.html&display=touch&response_type=token";
    NSURL *authURL = [[NSURL alloc] initWithString:authString];
    NSURLRequest *authRequest = [[NSURLRequest alloc] initWithURL:authURL];
    [authView loadRequest:authRequest];

}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([authView.request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound) {
        //authView.hidden = YES;
        NSString *secret = [authView.request.URL.absoluteString getStringBetweenString:@"access_token" andString:@"&"]; //извлекаем из ответа token
        [[NSUserDefaults standardUserDefaults] setObject:secret forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        NSData *str = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://api.vk.com/method/users.get?user_id=27122641&v=5.24&access_token=e900817c077972e733cdf4706a7e6103ff27ed303fa6cf4750b1f011836e5b83b2f61746880cb0aba390e"]];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:str options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"User_name: %@", [[[dict objectForKey:@"response"]objectAtIndex:0]objectForKey:@"first_name"]);
        [self performSegueWithIdentifier:@"segueAfterLogin" sender:self];
        
    } else if ([authView.request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound) {
        authView.hidden = YES;
        NSLog(@"%@", authView.request.URL.absoluteString); //выводим ошибку
    } else {
        authView.hidden = NO; //показываем окно авторизации
    }
    [indicator stopAnimating];
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
