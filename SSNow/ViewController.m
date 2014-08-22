//
//  ViewController.m
//  SSNow
//
//  Created by itisioslab on 22.08.14.
//  Copyright (c) 2014 kpfu.itisioslab. All rights reserved.
//

#import "ViewController.h"
#import "vkLoginViewController.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize appID, textField, authButton;

- (void)dealloc {
    [appID release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isAuth = NO;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
	self.appID = _textField.text;
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)doAuth:(id)sender {
    vkLoginViewController *vk = [[vkLoginViewController alloc] init];
    self.appID = textField.text;
    vk.appID = appID;
    vk.delegate = self;
    [self presentModalViewController:vk animated:YES];
    [vk release];
    NSLog(@"doAuth");
}

- (void) authComplete {
    [self sendSuccessWithMessage:@"Авторизация прошла успешно!"];
    isAuth = YES;
    NSLog(@"isAuth: %@", isAuth ? @"YES":@"NO");
}

- (IBAction)logout:(id)sender {
    // Запрос на logout
    NSString *logout = @"http://api.vk.com/oauth/logout";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:logout]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60.0];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(responseData){
        NSDictionary *dict = [[JSONDecoder decoder] parseJSONData:responseData];
        NSLog(@"Logout: %@", dict);
        
        // Приложение больше не авторизовано, можно удалить данные
        isAuth = NO;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VKAccessUserId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VKAccessToken"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VKAccessTokenDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self sendSuccessWithMessage:@"Выход произведен успешно!"];
    }
}

- (IBAction)sendTextAction:(id)sender {
    if(!isAuth) return;
    [self sendText];
}

- (IBAction)sendTextAndUrlAction:(id)sender {
    if(!isAuth) return;
    [self sendTextAndLink];
}


- (IBAction)sendImageAction:(id)sender {
    if(!isAuth) return;
      UIImage *image = [UIImage imageNamed:@"test.jpg"];
    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessUserId"];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessToken"];
    
    // Этап 1
    NSString *getWallUploadServer = [NSString stringWithFormat:@"https://api.vk.com/method/photos.getWallUploadServer?owner_id=%@&access_token=%@", user_id, accessToken];
    
    NSDictionary *uploadServer = [self sendRequest:getWallUploadServer withCaptcha:NO];
    
    // Получаем ссылку для загрузки изображения
    NSString *upload_url = [[uploadServer objectForKey:@"response"] objectForKey:@"upload_url"];
    
    // Этап 2
    // Преобразуем изображение в NSData
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    
    NSDictionary *postDictionary = [self sendPOSTRequest:upload_url withImageData:imageData];
    
    // Из полученного ответа берем hash, photo, server
    NSString *hash = [postDictionary objectForKey:@"hash"];
    NSString *photo = [postDictionary objectForKey:@"photo"];
    NSString *server = [postDictionary objectForKey:@"server"];
    
    // Этап 3
    // Создаем запрос на сохранение фото на сервере вконтакте, в ответ получим id фото
    NSString *saveWallPhoto = [NSString stringWithFormat:@"https://api.vk.com/method/photos.saveWallPhoto?owner_id=%@&access_token=%@&server=%@&photo=%@&hash=%@", user_id, accessToken,server,photo,hash];
    
    NSDictionary *saveWallPhotoDict = [self sendRequest:saveWallPhoto withCaptcha:NO];
    
    NSDictionary *photoDict = [[saveWallPhotoDict objectForKey:@"response"] lastObject];
    NSString *photoId = [photoDict objectForKey:@"id"];
    
    // Этап 4
    // Постим изображение на стену пользователя
    NSString *postToWallLink = [NSString stringWithFormat:@"https://api.vk.com/method/wall.post?owner_id=%@&access_token=%@&message=%@&attachment=%@", user_id, accessToken, [self URLEncodedString:@"К изображению можно добавить текст и ссылку"], photoId];
    
    NSDictionary *postToWallDict = [self sendRequest:postToWallLink withCaptcha:NO];
    NSString *errorMsg = [[postToWallDict  objectForKey:@"error"] objectForKey:@"error_msg"];
    if(errorMsg) {
        [self sendFailedWithError:errorMsg];
    } else {
        [self sendSuccessWithMessage:@"Картинка размещена на стене!"];
    }
    // Ура! Фото должно быть на стене!
    
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
