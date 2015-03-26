//
//  LicenseDetailViewController.m
//  TPBUtils
//
//  Created by tpb on 2/4/15.
//  Copyright (c) 2015 tpb. All rights reserved.
//

#import "LicenseDetailViewController.h"

@interface LicenseDetailViewController ()

@end

@implementation LicenseDetailViewController

-(void) setupWithLicenseDict:(NSDictionary*)licenseDict {
    self.licenseInfoDict=licenseDict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.authorName=[UILabel newAutoLayoutView];
    self.assetName=[UILabel newAutoLayoutView];
    self.webLink=[UIButton newAutoLayoutView];
    [self.webLink setTitle:@"Visit Project Webpage" forState:UIControlStateNormal];
    [self.webLink setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:150.0 alpha:0.6]];
    
    self.licenseLabel=[UILabel newAutoLayoutView];
    self.licenseLabel.text=@"Full License";
    [self.licenseLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.licenseText=[UITextView newAutoLayoutView];
    [self.view addSubview:self.authorName];
    [self.view addSubview:self.assetName];
    [self.view addSubview:self.webLink];
    [self.view addSubview:self.licenseLabel];

    [self.view addSubview:self.licenseText];
    self.linkURL=[NSURL URLWithString:[self.licenseInfoDict objectForKey:@"Link"]];
//    Pod,Project,DebugOnly,Author,License,Link
    self.title=[self.licenseInfoDict objectForKey:@"Pod"];
    self.authorName.text=[NSString stringWithFormat:@"Project Author: %@",[self.licenseInfoDict objectForKey:@"Author"]];
    self.assetName.text=[NSString stringWithFormat:@"Project Title: %@",[self.licenseInfoDict objectForKey:@"Pod"]];
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:[self.licenseInfoDict objectForKey:@"Pod"]
                                                     ofType:@"txt"];
    NSError *error;
    self.licenseText.text=[NSString stringWithContentsOfFile:licensePath encoding:NSUTF8StringEncoding	 error:&error];
    if (error){
        NSLog(@"couldn't open file %@ with error %@",licensePath,[error localizedDescription]);
    }
    [self.webLink addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self.view setNeedsUpdateConstraints];
}

-(IBAction)buttonPressed:(UIControl *)sender{
    NSLog(@"trying to open %@ on button press " ,self.linkURL);
    if ([[UIApplication sharedApplication] canOpenURL:self.linkURL]){
        NSLog(@"can open %@ on button press " ,self.linkURL);
        [[UIApplication sharedApplication] openURL:self.linkURL];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) updateViewConstraints{
    if (!self.didSetupConstraints){
        CGFloat horizontalInset=40.0;
        CGFloat edgeInset=5.0;

        CGFloat verticalSpace=20.0;
        
        [self.authorName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:edgeInset];
        [self.authorName autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:edgeInset];
        [self.authorName autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:edgeInset];
        [self.authorName autoSetDimension:ALDimensionHeight toSize:20.0];
        
        [self.assetName autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:edgeInset];
        [self.assetName autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:edgeInset];
        [self.assetName autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.authorName withOffset:5.0];
        [self.assetName autoSetDimension:ALDimensionHeight toSize:20.0];

        [self.webLink autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:horizontalInset];
        [self.webLink autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:horizontalInset];
        [self.webLink autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.assetName withOffset:verticalSpace];
        [self.webLink autoSetDimension:ALDimensionHeight toSize:30.0];
        
        [self.licenseLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:horizontalInset];
        [self.licenseLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:horizontalInset];
        [self.licenseLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.webLink withOffset:verticalSpace];
        [self.licenseLabel autoSetDimension:ALDimensionHeight toSize:30.0];
//        [self.licenseText autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5,5,5,5) excludingEdge:ALEdgeTop];
        [self.licenseText autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.licenseLabel withOffset:verticalSpace];
        [self.licenseText autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [self.licenseText autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        [self.licenseText autoPinEdgeToSuperviewEdge:ALEdgeBottom];


    }
    [super updateViewConstraints];
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
