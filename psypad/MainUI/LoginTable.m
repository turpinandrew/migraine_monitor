//
//  LoginTable.m
//  psypad
//
//  Created by LiuYuHan on 8/7/18.
//  Copyright © 2018 LiuYuHan. All rights reserved.
//

#import "LoginTable.h"
#import "YHBarButtonItem.h"

@interface LoginTable ()

@end

@implementation LoginTable

@synthesize userID,serverURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setScrollEnabled:NO];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    _topToolBarView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.tableView.contentSize.width, 55)];
    [_topToolBarView setBarStyle:UIBarStyleDefault];
    //[_topToolBarView setBackgroundColor:[UIColor clearColor]];
    //[_topToolBarView setTintColor:[UIColor clearColor]];
    //[_topToolBarView setBarTintColor:[UIColor colorWithRed:207.0/255.0 green:213.0/255.0 blue:221.0/255.0 alpha:1.0]];
    [_topToolBarView setBarTintColor:[UIColor colorWithRed:201.0/255.0 green:209.0/255.0 blue:217.0/255.0 alpha:1.0]];
    //[_topToolBarView setBarTintColor:[UIColor clearColor]];
    
    [self initTopView];
    [self initTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTopView{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *buttonArray = [[NSMutableArray alloc]init];
    if ([ud objectForKey:@"RecentUsers"]) {
        NSArray *recentUsers = [ud objectForKey:@"RecentUsers"];
        
        
        for (NSString *user in recentUsers) {
            
            YHBarButtonItem *abuttonView = [[YHBarButtonItem alloc]initWithFrame:CGRectMake(0, 0, 100, 55)];
            [abuttonView addText:user WithColor:[UIColor clearColor]];
            UIButton *abutton = [UIButton buttonWithType:UIButtonTypeCustom];
            abutton.frame = abuttonView.frame;
            abutton.titleLabel.text = [user uppercaseString];
            [abutton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventAllEvents];
            abutton.tintColor = [UIColor clearColor];
            [abuttonView addSubview:abutton];
            
            
            UIBarButtonItem *aBarButton =[[UIBarButtonItem alloc]initWithCustomView:abuttonView];
            
            [aBarButton setTarget:self];
            [aBarButton setAction:@selector(barButtonAction:)];
            [buttonArray addObject:aBarButton];
            
            /*
            UIBarButtonItem *tmpButton = [[UIBarButtonItem alloc] initWithTitle:user style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAction:)];
            [tmpButton setTintColor:[UIColor colorWithRed:72.0/255.0 green:104.0/255.0 blue:135.0/255.0 alpha:1.0]];
            [buttonArray addObject:tmpButton];
            */
            
            UIBarButtonItem* spaceBn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
            [buttonArray addObject:spaceBn];
        }
        //[buttonArray removeLastObject];
    }
    //NSLog(@"%@",buttonArray);
    [_topToolBarView setItems:buttonArray];
}


-(void)initTextField{
    
    _urlField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.tableView.contentSize.width - 10, 65)];
    _urlField.tag = 0;
    //_urlField.placeholder = @"Server URL";
    _urlField.placeholder = @"Password";
    //_urlField.text = @"https://server.psypad.net.au/";
    _urlField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _urlField.keyboardType = UIKeyboardTypeURL;
    _urlField.delegate = self;
    _urlField.secureTextEntry = YES;
    _urlField.textColor = [UIColor blackColor];
    _urlField.returnKeyType = UIReturnKeyDone;
    
    _idField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.tableView.contentSize.width - 10, 65)];
    _idField.tag = 1;
    _idField.placeholder = @"User ID";
    _idField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _idField.keyboardType = UIKeyboardTypeDefault;
    _idField.delegate = self;
    _idField.textColor = [UIColor blackColor];
    _idField.returnKeyType = UIReturnKeyNext;
    [_idField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [_idField setInputAccessoryView:_topToolBarView];
    
}

-(void)barButtonAction:(UIBarButtonItem *)button{
    //NSLog(@"%@", button.title);
    _idField.text = button.title;
    [_urlField becomeFirstResponder];
}

-(void)buttonAction:(UIButton *)button{
    //NSLog(@"%@", button.title);
    _idField.text = button.titleLabel.text;
    [_urlField becomeFirstResponder];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 2;
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [cell addSubview:_urlField];
    }
    else if (indexPath.section == 0 && indexPath.row == 0){
        [cell addSubview:_idField];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (section == 1)
        return @"Input Your Password:";
    else
        return @"Input Your ID:";
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _idField) {
        [_urlField becomeFirstResponder];
    }
    else {
        [_urlField resignFirstResponder];
    }
    return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *returnView = [[UIView alloc]initWithFrame:CGRectZero];
    return returnView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
