//
//  customcell.h
//  savenstore
//
//  Created by Group X on 01/03/16.
//  Copyright © 2016 MV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customcell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *docname;
@property (weak, nonatomic) IBOutlet UILabel *last_uploaded;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UILabel *uploaded_by;

@end
