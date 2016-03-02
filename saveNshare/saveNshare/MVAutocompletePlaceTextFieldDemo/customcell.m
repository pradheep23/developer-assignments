//
//  customcell.m
//  savenstore
//
//  Created by Group X on 01/03/16.
//  Copyright © 2016 MV. All rights reserved.
//

#import "customcell.h"

@implementation customcell

- (void)awakeFromNib {
    // Initialization code
    self.imgview.clipsToBounds=YES;
    self.imgview.layer.cornerRadius=self.imgview.frame.size.height/2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
