//
//  CityGroupsTableViewController.m
//  HW-CityGroups
//
//  Created by Tarena on 16/5/17.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CityGroupsTableViewController.h"
#import "TRMetaDataTool.h"
#import "TRCityGroups.h"
#import "AppDelegate.h"

@interface CityGroupsTableViewController ()
@property(nonatomic, strong)NSArray *cityArray;
@end

@implementation CityGroupsTableViewController

//-(NSArray *)cityArray {
//    if (!_cityArray) {
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
//        NSArray *plistArray = [NSArray arrayWithContentsOfFile:plistPath];
//        NSMutableArray *MArray = [[NSMutableArray alloc] initWithCapacity:100];
//        for (NSDictionary *dict in plistArray) {
//            TRCityGroups *cityGroups = [[TRCityGroups alloc] initWithDict:dict];
//            [MArray addObject:cityGroups];
//        }
//        _cityArray = MArray;
//    }
//    return _cityArray;
//}

-(NSArray *)cityArray {
    if (!_cityArray) {
        _cityArray = [TRMetaDataTool getAllCityGroup];
    }
    return _cityArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"城市列表";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityCell"];
    
//    NSLog(@"%@",self.cityArray);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    TRCityGroups *cityGroups = [[TRCityGroups alloc] init];
    cityGroups = self.cityArray[section];
    return cityGroups.title;
}
//
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    TRCityGroups *cityGroups = [[TRCityGroups alloc] init];
//    NSMutableArray *MArray = [[NSMutableArray alloc]initWithCapacity:100];
//    for (TRCityGroups *city in self.cityArray) {
//        [MArray addObject:city.title];
//    }
//    return MArray;
    
    //使用KVC方式
    return [self.cityArray valueForKey:@"title"];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.cityArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TRCityGroups *cityGroups = [[TRCityGroups alloc] init];
    cityGroups = self.cityArray[section];
    
    return cityGroups.cities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    
    TRCityGroups *cityGroups = [[TRCityGroups alloc] init];
    cityGroups = self.cityArray[indexPath.section];
    cell.textLabel.text = cityGroups.cities[indexPath.row];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点中");
    //将选中的城市名传出去
    TRCityGroups *cityGroup = self.cityArray[indexPath.section];
    [TRMetaDataTool setSelectedCityName:cityGroup.cities[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
