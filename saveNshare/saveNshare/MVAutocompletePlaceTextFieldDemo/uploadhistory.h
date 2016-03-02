//
//  uploadhistory.h
//  savenstore
//
//  Created by Group X on 01/03/16.
//  Copyright © 2016 MV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface uploadhistory : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIView *pview;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *lname;
- (IBAction)dismiss:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *fname;
@property (weak, nonatomic) IBOutlet UILabel *org;
@property (nonatomic,strong) NSArray *uploadarray;
@end
