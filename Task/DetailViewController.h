//
//  DetailViewController.h
//  Task
//
//  Created by Naveen Dangeti on 26/12/16.
//  Copyright © 2016 Naveen Dangeti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

