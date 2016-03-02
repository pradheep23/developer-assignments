//
//  uploadhistory.m
//  savenstore
//
//  Created by Group X on 01/03/16.
//  Copyright © 2016 MV. All rights reserved.
//

#import "uploadhistory.h"
#import "customcell.h"
#import <CloudKit/CloudKit.h>
@interface uploadhistory ()

@end

@implementation uploadhistory
@synthesize uploadarray;
BOOL loaded=NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageview.clipsToBounds=YES;
    self.pview.layer.cornerRadius=3.5;
    self.imageview.layer.cornerRadius=self.imageview.frame.size.height/2.0f;
    self.pview.hidden=YES;
    NSLog(@"Upload array %@",uploadarray);
    [self.tableview registerNib:[UINib nibWithNibName:@"customcell" bundle:nil] forCellReuseIdentifier:@"customcell"];
    // Do any additional setup after loading the view.
}

-(void)popup{
    self.pview.hidden=NO;
    self.pview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.pview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.pview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.98, 0.98);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                self.pview.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.uploadarray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *simpleTableIdentifier = @"cell";
    
    customcell *cell = (customcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"customcell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if(loaded==NO){
        CKAsset *asset=[[uploadarray objectAtIndex:indexPath.row] valueForKey:@"document"];
        if(asset!=nil){
         dispatch_async(dispatch_get_main_queue(), ^{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:asset.fileURL.path];
    cell.imgview.image = image;
         });
        }
        else{
    cell.imgview.image = [UIImage imageNamed:@"unknown.jpg"];
        }
        NSDate *dte =[[self.uploadarray objectAtIndex:indexPath.row] valueForKey:@"uploaded_time"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    cell.docname.text = [NSString stringWithFormat:@"%@",[[self.uploadarray objectAtIndex:indexPath.row] valueForKey:@"docname"]];
    cell.last_uploaded.text=[NSString stringWithFormat:@"Uploaded at %@",[dateFormat stringFromDate:dte]];
    cell.uploaded_by.text=[NSString stringWithFormat:@"Uploaded by %@",[[self.uploadarray objectAtIndex:indexPath.row] valueForKey:@"firstname"]];
    }
    if(indexPath.row==uploadarray.count-1){     
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.fname.text=[NSString stringWithFormat:@"%@",[[self.uploadarray objectAtIndex:indexPath.row] valueForKey:@"firstname"]];
    self.lname.text=[NSString stringWithFormat:@"%@",[[self.uploadarray objectAtIndex:indexPath.row] valueForKey:@"lastname"]];
    self.org.text=[NSString stringWithFormat:@"%@",[[self.uploadarray objectAtIndex:indexPath.row] valueForKey:@"company"]];
    self.email.text=[NSString stringWithFormat:@"%@",[[self.uploadarray objectAtIndex:indexPath.row] valueForKey:@"email"]];
    self.phone.text=[NSString stringWithFormat:@"%@",[[self.uploadarray objectAtIndex:indexPath.row] valueForKey:@"phone"]];
    self.address.text=[NSString stringWithFormat:@"%@,%@,%@ %@,%@",[[self.uploadarray objectAtIndex:indexPath.row] valueForKey:@"addressline1"],[[self.uploadarray objectAtIndex:indexPath.row] valueForKey:@"city"],[[self.uploadarray objectAtIndex:indexPath.row] valueForKey:@"state"],[[self.uploadarray objectAtIndex:indexPath.row] valueForKey:@"pincode"],[[self.uploadarray objectAtIndex:indexPath.row] valueForKey:@"country"]];
    CKAsset *asset=[[uploadarray objectAtIndex:indexPath.row] valueForKey:@"document"];
    if(asset!=nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:asset.fileURL.path];
            self.imageview.image = image;
        });
    }
    else{
        self.imageview.image = [UIImage imageNamed:@"unknown.jpg"];
    }

    
    [self performSelector:@selector(popup) withObject:nil afterDelay:0.1];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismiss:(id)sender {
    self.pview.hidden=YES;
}
@end
