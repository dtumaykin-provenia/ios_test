//
//  CustomCell.m
//  ProveniaTest
//
//  Created by Federico Frappi on 19/02/13.
//  Copyright (c) 2013 F&F Services S.R.L. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell ()

@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *is_shared;
@property (strong, nonatomic) IBOutlet UILabel *share_id;
@property (strong, nonatomic) IBOutlet UILabel *last_updated_date;
@property (strong, nonatomic) IBOutlet UILabel *item_id;
@property (strong, nonatomic) IBOutlet UILabel *path;
@property (strong, nonatomic) IBOutlet UILabel *link;
@property (strong, nonatomic) IBOutlet UILabel *user_id;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *shared_by;
@property (strong, nonatomic) IBOutlet UILabel *last_updated_by;
@property (strong, nonatomic) IBOutlet UILabel *shared_date;
@property (strong, nonatomic) IBOutlet UILabel *parent_id;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *mime_type;
@property (strong, nonatomic) IBOutlet UILabel *size;
@property (strong, nonatomic) IBOutlet UILabel *created_date;
@property (strong, nonatomic) IBOutlet UILabel *shared_level;
@property (strong, nonatomic) IBOutlet UILabel *path_by_id;


@end

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (void)configureForObject:(NSManagedObject *)obj{
	_status.text = [obj valueForKey:@"status"];
	_is_shared.text = [obj valueForKey:@"is_shared"];
	_share_id.text = [obj valueForKey:@"share_id"];
	_last_updated_date.text = [obj valueForKey:@"last_updated_date"];
	_item_id.text = [[obj valueForKey:@"item_id"] stringValue];
	_path.text = [obj valueForKey:@"path"];
	_link.text = [obj valueForKey:@"link"];
	_user_id.text = [[obj valueForKey:@"user_id"] stringValue];
	_name.text = [obj valueForKey:@"name"];
	_shared_by.text = [[obj valueForKey:@"shared_by"] stringValue];
	_last_updated_by.text = [obj valueForKey:@"last_updated_by"];
	_shared_date.text = [obj valueForKey:@"shared_date"];
	_parent_id.text = [[obj valueForKey:@"parent_id"] stringValue];
	_type.text = [obj valueForKey:@"type"];
	_mime_type.text = [obj valueForKey:@"mime_type"];
	_size.text = [[obj valueForKey:@"size"] stringValue];
	_created_date.text = [obj valueForKey:@"created_date"];
	_shared_level.text = [obj valueForKey:@"share_level"];
	_path_by_id.text = [obj valueForKey:@"path_by_id"];
}

@end
