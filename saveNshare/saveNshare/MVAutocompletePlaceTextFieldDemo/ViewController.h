//
//  ViewController.h
//  GoogleMapsController
//
//  Created by Mrugrajsinh Vansadia on 10/06/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <CloudKit/CloudKit.h>
@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *pincode;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIView *addresscontainer;
@property (weak, nonatomic) IBOutlet UIButton *sharebtn;
@property (weak, nonatomic) IBOutlet UIButton *historybtn;

- (IBAction)share:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *addressline1;
@property (weak, nonatomic) IBOutlet UIButton *btn;
- (IBAction)browse:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerview;
@property(nonatomic, strong)UIAlertAction *okAction;   
@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *firstname;
@property (weak, nonatomic) IBOutlet UITextField *middlename;
- (IBAction)retrieve:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *lastname;
- (IBAction)uploadtocloud:(id)sender;
@end

