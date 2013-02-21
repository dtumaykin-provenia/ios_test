//
//  CustomCell.m
//  ProveniaTest
//
//  Created by Federico Frappi on 19/02/13.
//  Copyright (c) 2013 F&F Services S.R.L. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell ()

@property (retain, nonatomic) IBOutlet UILabel *status;
@property (retain, nonatomic) IBOutlet UILabel *is_shared;
@property (retain, nonatomic) IBOutlet UILabel *share_id;
@property (retain, nonatomic) IBOutlet UILabel *last_updated_date;
@property (retain, nonatomic) IBOutlet UILabel *item_id;
@property (retain, nonatomic) IBOutlet UILabel *path;
@property (retain, nonatomic) IBOutlet UILabel *link;
@property (retain, nonatomic) IBOutlet UILabel *user_id;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *shared_by;
@property (retain, nonatomic) IBOutlet UILabel *last_updated_by;
@property (retain, nonatomic) IBOutlet UILabel *shared_date;
@property (retain, nonatomic) IBOutlet UILabel *parent_id;
@property (retain, nonatomic) IBOutlet UILabel *type;
@property (retain, nonatomic) IBOutlet UILabel *mime_type;
@property (retain, nonatomic) IBOutlet UILabel *size;
@property (retain, nonatomic) IBOutlet UILabel *created_date;
@property (retain, nonatomic) IBOutlet UILabel *shared_level;
@property (retain, nonatomic) IBOutlet UILabel *path_by_id;


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

- (void)dealloc {
	[_status release];
	[_is_shared release];
	[_share_id release];
	[_last_updated_date release];
	[_item_id release];
	[_path release];
	[_link release];
	[_user_id release];
	[_name release];
	[_shared_by release];
	[_last_updated_by release];
	[_shared_date release];
	[_parent_id release];
	[_type release];
	[_mime_type release];
	[_size release];
	[_created_date release];
	[_shared_level release];
	[_path_by_id release];
	[super dealloc];
}
@end
