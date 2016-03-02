//
//  ViewController.m
//  GoogleMapsController
//
//  Created by Mrugrajsinh Vansadia on 10/06/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "ViewController.h"
#import "uploadhistory.h"
#import "MVPlaceSearchTextField.h"
#import <GoogleMaps/GoogleMaps.h>
@interface ViewController ()<PlaceSearchTextFieldDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *txtPlaceSearch;
@end

@implementation ViewController
NSString *imagename;
UIImage *chosenImage;
UIView *uv;
NSArray *uploadarray;
int pick=0;
NSURL* imageURL;
int i=0;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.okAction setEnabled:(finalString.length >= 5)];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField==self.addressline1 || textField==self.state || textField==self.country || textField==self.pincode || textField==self.city){
        _txtPlaceSearch.hidden=YES;
    self.addresscontainer.frame=CGRectMake(self.addresscontainer.frame.origin.x, [[UIScreen mainScreen] bounds].size.height*0.1, self.addresscontainer.frame.size.width, self.addresscontainer.frame.size.height);
        self.firstname.hidden=YES;
        self.middlename.hidden=YES;
        self.lastname.hidden=YES;
        self.imgview.hidden=YES;
        self.email.hidden=YES;
        self.phone.hidden=YES;
        self.sharebtn.hidden=YES;
        self.historybtn.hidden=YES;
    }
    self.tableview.alpha=0.0;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if(textField==self.addressline1 || textField==self.state || textField==self.country || textField==self.pincode || textField==self.city){
        _txtPlaceSearch.hidden=NO;
        self.addresscontainer.frame=CGRectMake(self.addresscontainer.frame.origin.x, uv.frame.origin.y, self.addresscontainer.frame.size.width, self.addresscontainer.frame.size.height);
        self.firstname.hidden=NO;
        self.middlename.hidden=NO;
        self.lastname.hidden=NO;
        self.imgview.hidden=NO;
        self.email.hidden=NO;
        self.phone.hidden=NO;
        self.sharebtn.hidden=NO;
        self.historybtn.hidden=NO;
    }
}

-(void)hideviews:(NSNotification *)note{
    
    if([_txtPlaceSearch becomeFirstResponder]){
    self.containerview.hidden=YES;
        self.imgview.hidden=YES;
    }
    
}

-(void)unhideviews{
    if([_txtPlaceSearch becomeFirstResponder]){
        self.containerview.hidden=NO;
                self.imgview.hidden=NO;
        [_txtPlaceSearch resignFirstResponder];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    uploadarray =[[NSArray alloc] init];
    uv=[[UIView alloc] initWithFrame:self.addresscontainer.frame];
    self.spinner.hidden=YES;
    self.imgview.clipsToBounds=YES;
    self.imgview.layer.cornerRadius=self.imgview.frame.size.height/2.0f;
    self.imgview.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor blackColor]);
    
    self.imgview.layer.borderWidth=2.0;
    _txtPlaceSearch.placeSearchDelegate                 = self;
    _txtPlaceSearch.strApiKey                           = @"AIzaSyDuAyVCwUbiO-aSUxGKrXcbQu7OAprvHJU";
    _txtPlaceSearch.superViewOfList                     = self.view;  // View, on which Autocompletion list should be appeared.
    _txtPlaceSearch.autoCompleteShouldHideOnSelection   = YES;
    _txtPlaceSearch.maximumNumberOfAutoCompleteRows     = 5;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    self.imgview.userInteractionEnabled=YES;
    [self.imgview addGestureRecognizer:singleTap];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedtoexit)];
    singleTap1.numberOfTapsRequired = 1;
    self.containerview.userInteractionEnabled=YES;
    [self.containerview addGestureRecognizer:singleTap1];
    self.tableview.alpha=0.0;
    NSObject *s=[NSFileManager defaultManager].ubiquityIdentityToken;
    NSLog(@"S is %@",s);
    if (s == nil || s == (id)[NSNull null]) {
        UIAlertView *a=[[UIAlertView alloc] initWithTitle:@"iCloud login required" message:@"It seems like you didn't login to your iCloud account. Goto settings -> iCloud -> Signin and retry. Also, Please make sure that you've enabled iCloud Drive." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
              [a show];
    }else{
        ABAddressBookRef addressBook = ABAddressBookCreate();
        addressBook = nil;
        __block NSMutableArray *arrayOfPeople = nil;
        __block BOOL userDidGrantAddressBookAccess;
        CFErrorRef addressBookError = NULL;
        
        if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined ||
            ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized )
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, &addressBookError);
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
                userDidGrantAddressBookAccess = granted;
                arrayOfPeople = [(__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook) mutableCopy];
                CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
                NSMutableArray *allEmails = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
                NSLog(@"%@",arrayOfPeople);
                for (CFIndex i = 0; i < CFArrayGetCount(people); i++) {
                    ABRecordRef person = CFArrayGetValueAtIndex(people, i);
                    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
                    if(i==0){
                        NSInteger  contactId = (NSInteger) ABRecordGetRecordID(person);
                        NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
                        UIImage  *img = [UIImage imageWithData:imgData];
                            self.imgview.image=img;
                            self.imgview.clipsToBounds=YES;
                            self.imgview.layer.cornerRadius=self.imgview.layer.frame.size.height/2.0f;
                            [self.imgview setNeedsDisplay];
                            [self.imgview setNeedsLayout];
                        
                        NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"New Folder"];
                        
                        // New Folder is your folder name
                        
                        NSError *error = nil;
                        
                        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
                            [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
                        
                        NSString *fileName = [stringPath stringByAppendingFormat:@"/image.jpg"];
                        NSLog(@"Path is %@",fileName);
                        imageURL= [NSURL fileURLWithPath:fileName];
                        NSData *data = UIImageJPEGRepresentation(img, 1.0);
                        [data writeToFile:fileName atomically:YES];
                        imagename=@"image";
                        
                        
                        NSString* email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, i);
                        NSLog(@"%@",email);
                        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
                        NSString *company=(__bridge NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
                        ABMultiValueRef phone = (__bridge ABMultiValueRef)((__bridge NSMutableDictionary *)ABRecordCopyValue(person, kABPersonPhoneProperty));
                        NSArray *phoneArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phone);
                        NSMutableString *strPhone = [NSMutableString string];
                        [strPhone appendString:[NSString stringWithFormat:@"%@",[phoneArray objectAtIndex:0]]];
                        
                        NSLog(@"contactId : %i %@ %@ %@ %@ %@",contactId,strPhone,email,firstName,lastName,company);
                        
                            if (strPhone != nil && strPhone != (id)[NSNull null]) {
                                self.phone.text=[NSString stringWithFormat:@"%@",strPhone];
                            }
                        if (email != nil && email != (id)[NSNull null]) {
                            self.email.text=[NSString stringWithFormat:@"%@",email];
                        }
                        if (firstName != nil && firstName != (id)[NSNull null]) {
                            self.firstname.text=[NSString stringWithFormat:@"%@",firstName];
                        }
                        if (lastName != nil && lastName != (id)[NSNull null]) {
                            self.lastname.text=[NSString stringWithFormat:@"%@",lastName];
                        }
                        if (company != nil && company != (id)[NSNull null]) {
                            self.middlename.text=[NSString stringWithFormat:@"%@",company];
                        }
                        
                    }
                    for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
                        NSString* email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, j);
                        [allEmails addObject:email];
                    }
                    CFRelease(emails);
                }
                CFRelease(addressBook);
                CFRelease(people);
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        else
        {
            if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
                ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted )
            {
                // Display an error.
            }
            
        }
        
    }
/*
    [UIView transitionWithView:self.tableview
                      duration:4.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    self.tableview.hidden = YES;*/
   
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
        self.tableview.alpha=0.0;
        
    }
    else if(indexPath.row==1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
                self.tableview.alpha=0.0;
    }
    else if(indexPath.row==2){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
        
                self.tableview.alpha=0.0;
    }
    else if (indexPath.row==3){
        self.imgview.image=nil;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [self.tableview setAlpha:0.0];
        [UIView commitAnimations];
        [UIView setAnimationDuration:0.0];
        pick=0;
    }
    else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [self.tableview setAlpha:0.0];
        [UIView commitAnimations];
        [UIView setAnimationDuration:0.0];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if(indexPath.row==0){
    cell.textLabel.text=@"Upload photo";
    }else if(indexPath.row==1){
    cell.textLabel.text=@"Take photo";
    }else if(indexPath.row==2){
    cell.textLabel.text=@"Update photo";
    }
    else if(indexPath.row==3){
    cell.textLabel.text=@"Remove photo";
    }
    else{
    cell.textLabel.text=@"Cancel";
    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(void)tapDetectedtoexit{
    if(self.tableview.alpha==1.0){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [self.tableview setAlpha:0.0];
        [UIView commitAnimations];
        [UIView setAnimationDuration:0.0];
    }
    
}
-(void)tapDetected{
 /*   self.imgview.userInteractionEnabled=NO;
    [UIView transitionWithView:self.tableview
                      duration:4.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:^(BOOL finished){
                            self.imgview.userInteractionEnabled=YES;
                    }];
    

    
    self.tableview.hidden = !self.tableview.hidden;*/
    if(self.tableview.alpha==1.0){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [self.tableview setAlpha:0.0];
        [UIView commitAnimations];
        [UIView setAnimationDuration:0.0];
    }
    else{
    self.tableview.alpha = 0.0;
    self.tableview.layer.cornerRadius = 5;
    self.tableview.layer.borderWidth = 1.5f;
    self.tableview.layer.masksToBounds = YES;

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [self.tableview setAlpha:1.0];
    [UIView commitAnimations];
    [UIView setAnimationDuration:0.0];
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    //Optional Properties
    _txtPlaceSearch.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    _txtPlaceSearch.autoCompleteBoldFontName = @"HelveticaNeue";
    _txtPlaceSearch.autoCompleteTableCornerRadius=0.0;
    _txtPlaceSearch.autoCompleteRowHeight=35;
    _txtPlaceSearch.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    _txtPlaceSearch.autoCompleteFontSize=14;
    _txtPlaceSearch.autoCompleteTableBorderWidth=1.0;
    _txtPlaceSearch.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    _txtPlaceSearch.autoCompleteShouldHideOnSelection=YES;
    _txtPlaceSearch.autoCompleteShouldHideClosingKeyboard=YES;
    _txtPlaceSearch.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    _txtPlaceSearch.autoCompleteTableFrame = CGRectMake((self.view.frame.size.width-_txtPlaceSearch.frame.size.width)*0.5, 0.2*[[UIScreen mainScreen]bounds].size.height-45.0, _txtPlaceSearch.frame.size.width, 200.0);
}

#pragma mark - Place search Textfield Delegates



-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict{
    [self.view endEditing:YES];
    self.city.text=@"";
    self.country.text=@"";
    self.pincode.text=@"";
    self.state.text=@"";
    self.addressline1.text=@"";
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.spinner];
    NSLog(@"SELECTED ADDRESS :%@",responseDict);
    NSMutableString *mstring=[[NSMutableString alloc] init];
    mstring=[responseDict.formattedAddress mutableCopy];
    [mstring replaceOccurrencesOfString:@", "
                              withString:@","
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, mstring.length)];
    NSLog(@"%@",mstring);
    NSArray *a=[mstring componentsSeparatedByString:@","];
    NSLog(@"%@",a);
    if(a.count>4){
    NSString *res = [[a subarrayWithRange:NSMakeRange(0, fmin(a.count-4, [a count]))]
                     componentsJoinedByString:@","];
    
    self.addressline1.text=[NSString stringWithFormat:@"%@",res];
    self.city.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:a.count-3]];
    self.country.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:a.count-1]];
    self.pincode.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:a.count-2]];
        NSArray *b=[NSArray arrayWithArray:a];
        a=[[a objectAtIndex:a.count-2] componentsSeparatedByString:@" "];
        self.state.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:0]];
        if(a.count==2 && [[a objectAtIndex:1] intValue]!=0){
            self.pincode.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:1]];
        }
        else if(a.count>2){
            self.state.text=[NSString stringWithFormat:@"%@",[b objectAtIndex:1]];
        }
        else{
            self.pincode.text=@"";
        }
        
    }
    else if(a.count==3){
        
        self.city.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:a.count-3]];
        self.country.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:a.count-1]];
        NSArray *b=[NSArray arrayWithArray:a];
        a=[[a objectAtIndex:a.count-2] componentsSeparatedByString:@" "];
        self.state.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:0]];
        if(a.count==2 && [[a objectAtIndex:1] intValue]!=0){
        self.pincode.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:1]];
        }
        else if(a.count>2){
            self.state.text=[NSString stringWithFormat:@"%@",[b objectAtIndex:1]];
        }
        else{
            self.pincode.text=@"";
        }
    }
    else if(a.count==1){
        self.country.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:0]];
    }
    else if(a.count==2){
    self.country.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:a.count-1]];
        NSArray *b=[NSArray arrayWithArray:a];

        a=[[a objectAtIndex:a.count-2] componentsSeparatedByString:@" "];
        self.state.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:0]];
        if(a.count==2){
            self.pincode.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:1]];
        }
        else if(a.count>2){
            self.pincode.text=[NSString stringWithFormat:@"%@",[b objectAtIndex:1]];
        }
        else{
            self.pincode.text=@"";
        }


    }
    else if(a.count==4){
    self.country.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:a.count-1]];
        NSString *res = [[a subarrayWithRange:NSMakeRange(0, fmin(a.count-3, [a count]))]
                         componentsJoinedByString:@","];
    self.addressline1.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:0]];
    self.city.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:1]];
        NSArray *b=[NSArray arrayWithArray:a];
        a=[[a objectAtIndex:a.count-2] componentsSeparatedByString:@" "];
        self.state.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:0]];
        if(a.count==2 && [[a objectAtIndex:1] intValue]!=0){
            self.pincode.text=[NSString stringWithFormat:@"%@",[a objectAtIndex:1]];
        }
        else if(a.count>2){
            self.state.text=[NSString stringWithFormat:@"%@",[b objectAtIndex:1]];
        }
        else{
            self.pincode.text=@"";
        }


    }
}
-(void)placeSearchWillShowResult:(MVPlaceSearchTextField*)textField{
    
}
-(void)placeSearchWillHideResult:(MVPlaceSearchTextField*)textField{
    
}
-(void)placeSearch:(MVPlaceSearchTextField*)textField ResultCell:(UITableViewCell*)cell withPlaceObject:(PlaceObject*)placeObject atIndex:(NSInteger)index{
    if(index%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
}
- (IBAction)browse:(id)sender {

    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    pick=1;
    chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Document name required"
                                  message:@"Enter the name of the attached image"
                                  preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *alertRef = alert;
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Do Some action here
                                                   NSString *text = ((UITextField *)[alertRef.textFields objectAtIndex:0]).text;
                                                   
                                                   imagename=text;
                                                   NSLog(@"Name is %@",imagename);
                                                   
                                                   UIImage* image;
                                                   
                                                   if([[info valueForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"])
                                                   {
                                                       
                                                       image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
                                                       
                                                       NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"New Folder"];
                                                       
                                                       // New Folder is your folder name
                                                       
                                                       NSError *error = nil;
                                                       
                                                       if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
                                                           [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
                                                       
                                                       NSString *fileName = [stringPath stringByAppendingFormat:@"/%@.jpg",imagename];
                                                       NSLog(@"Path is %@",fileName);
                                                       imageURL= [NSURL fileURLWithPath:fileName];
                                                       NSData *data = UIImageJPEGRepresentation(image, 1.0);
                                                       
                                                       [data writeToFile:fileName atomically:YES];
                                                       self.imgview.image = chosenImage;
                                                   }
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)uploadtocloud:(id)sender {
    if(imagename.length==0){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Document name required"
                                      message:@"Enter the name of the attached image"
                                      preferredStyle:UIAlertControllerStyleAlert];
        __weak UIAlertController *alertRef = alert;
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       //Do Some action here
                                                       NSString *text = ((UITextField *)[alertRef.textFields objectAtIndex:0]).text;
                                                       
                                                       imagename=text;
                                                       NSLog(@"Name is %@",imagename);
                                                       [self upload];
                                                   }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        }];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        [self upload];
    }
}

-(void)upload{
    self.spinner.hidden=NO;
    NSString *recordID=[NSString stringWithFormat:@"%d",i];
    CKRecordID *wellKnownID = [[CKRecordID alloc] initWithRecordName:recordID];
    CKRecord *record = [[CKRecord alloc] initWithRecordType:@"saveandshare" recordID:wellKnownID];
    
    //create and set record instance properties
    
    //get the PublicDatabase from the Container for this app
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    
    //save the record to the target database
    if(self.imgview.image!=nil && self.city.text.length>0 && self.country.text.length>0 && self.pincode.text.length>0 && self.addressline1.text.length>0 && self.firstname.text.length>0 && self.lastname.text.length>0){
    record[@"phone"] = self.phone.text;
    record[@"email"] = self.email.text;
    record[@"firstname"] = self.firstname.text;
    record[@"lastname"] = self.lastname.text;
    record[@"company"] = self.middlename.text;
    record[@"city"] = self.city.text;
    record[@"pincode"] = self.pincode.text;
    record[@"addressline1"] = self.addressline1.text;
    record[@"docname"] = imagename;
    record[@"state"]=self.state.text;
        if (imageURL){
            CKAsset *asset = [[CKAsset alloc] initWithFileURL:imageURL];
            record[@"document"] = asset;
        }
        record[@"uploaded_time"]=[NSDate date];
        //save the record to the target database
        [publicDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
            
            //handle save error
            if(error) {
                NSLog(@"%d",error.code);
                if(error.code==14){
                    i++;
                    [self upload];
                
                }
                    self.spinner.hidden=YES;
                      //      NSLog(@"Uh oh, there was an error ... %@", [error valueForKey:@"server message"]);
                
                //handle successful save
            } else {
                self.spinner.hidden=YES;
                NSLog(@"Saved successfully");
            }
        }];
    }
    else{
        self.spinner.hidden=YES;
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Upload unsuccessful"
                                      message:@"Please enter all the fields before uplading. All the fields are mandatory"
                                      preferredStyle:UIAlertControllerStyleAlert];
UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                     
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

- (IBAction)retrieve:(id)sender {
    UIButton *b=(UIButton *)sender;
    b.enabled=NO;
    /*CKContainer *defaultContainer = [CKContainer defaultContainer];
    
    //get the PublicDatabase inside the Container
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    
    //create the target record id you will use to fetch by
    CKRecordID *wellKnownID = [[CKRecordID alloc] initWithRecordName:@"1"];
    
    //fetch the target record using it's record id
    [publicDatabase fetchRecordWithID:wellKnownID completionHandler:^(CKRecord *record, NSError *error) {
        
        //handle error
        if(error) {
            
            NSLog(@"Uh oh, there was an error ... %@", [error valueForKey:@"server message"]);
            
        } else {
            
            NSLog(@"Fetched record by Id successfully");
            NSLog(@"Title: %@", record[@"phone"]);
            NSLog(@"Description: %@", record[@"email"]);
            NSLog(@"Address: %@", record[@"address"]);
            NSLog(@"Locations: %@", record[@"locations"]);
        }
    }];*/
    self.spinner.hidden=NO;
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"saveandshare" predicate:predicate];
    
    [[CKContainer defaultContainer].publicCloudDatabase performQuery:query
                                                        inZoneWithID:nil
                                                   completionHandler:^(NSArray *results, NSError *error) {
                                                       if(!error){
                                                           uploadarray=[NSArray arrayWithArray:results];
                                                    b.enabled=YES;
                                                           self.spinner.hidden=YES;
                                                           [self performSegueWithIdentifier:@"showuploadhistory" sender:nil];
                                                       }
                                                       else{
                                                           NSLog(@"%@",error);
                                                           b.enabled=YES;
                                                           self.spinner.hidden=YES;
                                                       }
                                                   }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    uploadhistory *upload=[segue destinationViewController];
    upload.uploadarray=uploadarray;
}
- (IBAction)share:(id)sender {
    if(self.imgview.image!=nil && self.city.text.length>0 && self.country.text.length>0 && self.pincode.text.length>0 && self.addressline1.text.length>0 && self.firstname.text.length>0 && self.lastname.text.length>0){
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setValue:self.firstname.text forKey:@"firstname"];
    [dict setValue:self.lastname.text forKey:@"lasstname"];
    [dict setValue:self.email.text forKey:@"email"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];

    NSString *str=[NSString stringWithFormat:@"Firstname: %@ \n Lastname: %@ \n Organization: %@ \n Email: %@ \n Phone: %@ \n Address: %@",self.firstname.text,self.lastname.text,self.middlename.text,self.email.text,self.phone.text,self.txtPlaceSearch.text];
    NSArray *activityItems = [NSArray arrayWithObjects:str,imageURL,  nil];
    UIActivityViewController *avc = [[UIActivityViewController alloc]
                                     initWithActivityItems:activityItems
                                     applicationActivities:nil];
    
    
    avc.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard ];
    avc.completionHandler = ^(NSString *activityType, BOOL completed) {
        if (completed) {
            NSLog(@"The selected activity was %@", activityType);
        }
    };
    //    [self presentViewController:avc animated:YES completion:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:avc animated:YES completion:nil];
    }
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:avc];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0)inView:self.view permittedArrowDirections:0 animated:YES];
    }
    }
    else{
        self.spinner.hidden=YES;
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Sharing unsuccessful"
                                      message:@"Please enter all the fields before sharing. All the fields are mandatory"
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
@end
