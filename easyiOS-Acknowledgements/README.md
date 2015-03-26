# easyIOS-acknowledgements
Example how to create  reference/ acknowledgements section automatically for iOS apps

uses my DynamicTableGenerator pod located [here](https://github.com/TheoBrown/DynamicTableGenerator-iOS):

####First you need to load information about the assets into a dictionary. Create a csv similar to the example one included here. Put in information about the pods and resources you used in your project.

```Objective-C
#pragma mark - license/theme data
-(NSDictionary*) loadLicenseInfo {
    NSString* csvName =@"texasHoldemCalc_licenses";//replace with your csv name 
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

```

###Now create the settings view controller and show it when requested
```Objective-C

  
    NSDictionary *licenseDict = [self loadLicenseInfo];
    NSMutableArray *acknowledgements = [NSMutableArray new];
    for (id key in licenseDict){
        NSDictionary*webLinkInfo=[licenseDict objectForKey:key];
        LicenseDetailViewController *licDet=[[LicenseDetailViewController alloc] init];
        [licDet setupWithLicenseDict:webLinkInfo];
        SegueOptionCellInput*showDetail = [[SegueOptionCellInput alloc] initSegueOptionCellInputForVC:licDet withTitle:webLinkInfo[@"Pod"] inSection:@"Software Assets"];
        [acknowledgements addObject:showDetail];
        
    }
    
    DynamicTableViewController *acknowledgementsVC = [[DynamicTableViewController alloc] initWithCells:acknowledgements forStyle:UITableViewStyleGrouped];
    acknowledgementsVC.useTableNavigationBar=NO;
    acknowledgementsVC.title=@"Acknowledgements";
    
    SegueOptionCellInput*showAcknowledgements = [[SegueOptionCellInput alloc] initSegueOptionCellInputForVC:acknowledgementsVC withTitle:@"Acknowledgements" inSection:@"Special Thanks"];

    NSArray *cellInputArray = @[showAcknowledgements];
    DynamicTableViewController *settingsVC = [[DynamicTableViewController alloc] initWithCells:cellInputArray];
    
    settingsVC.useTableNavigationBar=NO;
    settingsVC.optionsDelegate=self;
    
    //show settings controller
    [self.navigationController pushViewController:settingsVC animated:YES];


}
```
