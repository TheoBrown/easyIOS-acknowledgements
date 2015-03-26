//
//  ViewController.m
//  easyiOS-Acknowledgements
//
//  Created by TPB on 3/25/15.
//  Copyright (c) 2015 DirectDiagnostics. All rights reserved.
//

#import "ViewController.h"
#import "LicenseDetailViewController.h"

@interface ViewController ()
@property (nonatomic) BOOL someBoolValue;
@property (strong,nonatomic) NSDictionary * colorMap;
@property (strong,nonatomic) NSString * myBackgroundColor;
@property (strong,nonatomic) NSNumber *  opacityValue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Your Awesome App";
    // Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *settingsButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"appbar.settings"] style:UIBarButtonItemStyleDone target:self action:@selector(showSettings:)];
    [self.navigationItem setRightBarButtonItem:settingsButtonItem];
    
    
    //You can use DynamicTableGenerator to automatically assign values to an objects properties. The object can be a ViewController, a NSObject, or even an NSManagedObject for use with core data!
    self.colorMap = [NSDictionary dictionaryWithObjects:@[[UIColor blueColor],[UIColor blackColor],[UIColor greenColor],[UIColor redColor],[UIColor whiteColor],[UIColor orangeColor]] forKeys:@[@"Blue",@"Black",@"Green",@"Red",@"White",@"Orange"]];
    self.myBackgroundColor=@"White";
    self.opacityValue=@0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showSettings:(id)sender {
    //first we will create the acknowledgements table view
    NSDictionary *licenseDict = [self loadLicenseInfo];
    NSMutableArray *acknowledgements = [NSMutableArray new];
    //populate array with info loaded from csv
    for (id key in licenseDict){
        NSDictionary*webLinkInfo=[licenseDict objectForKey:key];
        LicenseDetailViewController *licDet=[[LicenseDetailViewController alloc] init];
        [licDet setupWithLicenseDict:webLinkInfo];
        SegueOptionCellInput*showDetail = [[SegueOptionCellInput alloc] initSegueOptionCellInputForVC:licDet withTitle:webLinkInfo[@"Pod"] inSection:@"Software Assets"];
        [acknowledgements addObject:showDetail];
        
    }
    
    //All acknowledgements will sit within their own table view
    DynamicTableViewController *acknowledgementsVC = [[DynamicTableViewController alloc] initWithCells:acknowledgements forStyle:UITableViewStyleGrouped];
    acknowledgementsVC.useTableNavigationBar=NO;
    acknowledgementsVC.title=@"Acknowledgements";
    
    
    //link the acknolwedgment tableview to the main settings tableview
    SegueOptionCellInput*showAcknowledgements = [[SegueOptionCellInput alloc] initSegueOptionCellInputForVC:acknowledgementsVC withTitle:@"Acknowledgements" inSection:@"Special Thanks"];
    
    
    
    //here you can add additional settings that your app uses
    
    //just some random fun stuff to play with using the DynamicTableGenerator Pod
    SwitchOptionCellInput * boolValueCell = [[SwitchOptionCellInput alloc] initSwitchInputForObject:self forReturnKey:@"someBoolValue" withTitle:@"Switch ME" withDefault:self.someBoolValue inSection:@"App Settings"];
    
    SimpleActionSheetOptionCellInput *colorPicker = [[SimpleActionSheetOptionCellInput alloc] initSimpleActionSheetInputForObject:self forReturnKey:@"myBackgroundColor" withDefault:self.myBackgroundColor withOptions:[self.colorMap allKeys] withTitle:@"Background Color" inSection:@"Settings"];
    SliderOptionCellInput *opacity = [[SliderOptionCellInput alloc] initFloatSliderInputForObject:self forReturnKey:@"opacityValue" withTitle:@"Opacity" withDefault:self.opacityValue withMaxValue:@1.0 andMinValue:@0.0 inSection:@"Settings"];
    
    
    
    
    //finally, include all of your desired settings cellls in an array and init a new DynamicTableViewController
    NSArray *cellInputArray = @[boolValueCell,colorPicker,opacity,showAcknowledgements];
    DynamicTableViewController *settingsVC = [[DynamicTableViewController alloc] initWithCells:cellInputArray];
    
    settingsVC.useTableNavigationBar=NO;
    settingsVC.optionsDelegate=self;
    
    //show settings controller
    [self.navigationController pushViewController:settingsVC animated:YES];
}
#pragma mark - DynamicTableViewController Options Delegate
-(void) optionsWereUpdated:(NSDictionary *)optionsDictionary{
    //this is a callback from DynamicTableViewController. Here you can implement changes based on the user input in the settings panel
    NSLog(@"bool is %d",self.someBoolValue);
    [self.view setBackgroundColor:[self.colorMap objectForKey:self.myBackgroundColor]];
    [self.view setAlpha:[self.opacityValue floatValue]];
}
#pragma mark - Data
-(NSDictionary*) loadLicenseInfo {
    NSString* csvName =@"licenseinfo";//replace with your csv name
    NSString *csvPath = [[NSBundle mainBundle] pathForResource:csvName ofType:@"csv"];
    NSString *rawLines = [NSString stringWithContentsOfFile:csvPath encoding:NSASCIIStringEncoding error:nil];
    NSArray* allLines = [rawLines componentsSeparatedByString:@"\n"];
    
    NSMutableDictionary *licensesDict = [[NSMutableDictionary alloc] init];
    
    NSArray *rowKeys = [[allLines objectAtIndex:0] componentsSeparatedByString:@","];
    
    [allLines enumerateObjectsUsingBlock:^(id obj,
                                           NSUInteger idx,
                                           BOOL *stop) {
        
        if (idx ==0) {
        }
        else {
            NSArray *fields = [obj componentsSeparatedByString:@","];
            __block NSString *rowTitle = [[NSString alloc] init];
            __block NSMutableDictionary *Info = [[NSMutableDictionary alloc] init];
            
            [fields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if (idx ==0) {//set row title to pod name
                    rowTitle = obj;
                }
                [Info setObject:obj forKey:[rowKeys objectAtIndex:idx]];
            }];
            if ([rowTitle isEqualToString:@""]){
            }
            else{
                [licensesDict setObject:Info forKey:rowTitle];
            }
        }
    }];
    return [NSDictionary dictionaryWithDictionary:licensesDict];
}
@end
