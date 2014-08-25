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
        authView.hidden = YES;
        NSString *secret = [authView.request.URL.absoluteString getStringBetweenString:@"access_token=" andString:@"&"]; //извлекаем из ответа token
        NSString *user_id;
        NSRange range = [authView.request.URL.absoluteString rangeOfString:@"user_id"];
        user_id = [authView.request.URL.absoluteString substringWithRange:NSMakeRange(range.location+8, authView.request.URL.absoluteString.length-range.location-8)]; //вырезаем id user-а
        NSLog(@"user_id %@ %@",user_id,secret);
        
        [[NSUserDefaults standardUserDefaults] setObject:secret forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        NSData *str = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.vk.com/method/users.get?user_id=%@&v=5.24&access_token=%@&fields=online,photo_50",user_id,secret]]];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:str options:NSJSONReadingMutableContainers error:nil];
       
        
        NSString *name = [[[dict objectForKey:@"response"]objectAtIndex:0]objectForKey:@"first_name"];
        NSLog(@"First name %@",name);
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"first_name"];//передаем Имя пользователя
        [[NSUserDefaults standardUserDefaults]  synchronize];
        
        NSString *lastname = [[[dict objectForKey:@"response"]objectAtIndex:0]objectForKey:@"last_name"];
        NSLog(@"Last name %@",lastname);
        [[NSUserDefaults standardUserDefaults] setObject:lastname forKey:@"last_name"];//передаем фамилию пользователя
        [[NSUserDefaults standardUserDefaults]  synchronize];
        
        NSNumber *online_st = [[[dict objectForKey:@"response"]objectAtIndex:0]objectForKey:@"online"];
        NSLog(@"Status %@",online_st);
        if (online_st == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:@"Offline" forKey:@"online"];// Online or Not Online?
        }
        else{
            [[NSUserDefaults standardUserDefaults] setObject:@"Online" forKey:@"online"];
        }
        [[NSUserDefaults standardUserDefaults]  synchronize];
        
        
        NSString *photo_50 = [[[dict objectForKey:@"response"]objectAtIndex:0]objectForKey:@"photo_50"];
        NSLog(@"Status %@",photo_50);
        [[NSUserDefaults standardUserDefaults] setObject:photo_50 forKey:@"photo_50"];// Photo size 50
        [[NSUserDefaults standardUserDefaults]  synchronize];
        
        
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
