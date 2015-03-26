//
//  LicenseDetailViewController.h
//  TPBUtils
//
//  Created by tpb on 2/4/15.
//  Copyright (c) 2015 tpb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PureLayout.h"

@interface LicenseDetailViewController : UIViewController
@property (nonatomic,strong) NSDictionary* licenseInfoDict;
@property (nonatomic,strong) NSURL* linkURL;

@property (nonatomic,strong) IBOutlet UILabel *authorName;
@property (nonatomic,strong) IBOutlet UILabel *assetName;
@property (nonatomic,strong) IBOutlet UIButton *webLink;

@property (nonatomic,strong) IBOutlet UILabel *licenseLabel;
@property (nonatomic,strong) IBOutlet UITextView *licenseText;

@property (nonatomic, assign) BOOL didSetupConstraints;

-(void) setupWithLicenseDict:(NSDictionary*)licenseDict;

@end
