//
//  UIBubbleTableViewCell.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <QuartzCore/QuartzCore.h>
#import "UIBubbleTableViewCell.h"
#import "NSBubbleData.h"

@interface UIBubbleTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic, retain) UIImageView *avatarImage;

- (void) setupInternalData;

@end

@implementation UIBubbleTableViewCell

@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleImage = _bubbleImage;
@synthesize showAvatar = _showAvatar;
@synthesize avatarImage = _avatarImage;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}


- (void)setDataInternal:(NSBubbleData *)value
{
	self.data = value;
	[self setupInternalData];
}

- (void) setupInternalData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!self.bubbleImage)
    {
        self.bubbleImage = [[UIImageView alloc] init];
    }
    
    NSBubbleType type = self.data.type;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;
	if ([self.superview isKindOfClass:[UITableView class]]) { // ugly hack to fix the problem when bubbles run away from screen on the right hand side while deleting and editing the comment
		UITableView* tableView = (UITableView* )self.superview;
		if (tableView.isEditing) {
			if (self.data.comment.isMyComment) {
				self.contentView.frame = CGRectMake(-35, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
			}
		}
	}
    CGFloat x = (type == BubbleTypeSomeoneElse) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;
    [self.customView removeFromSuperview];
	
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
	self.customView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.customView];

    if (type == BubbleTypeSomeoneElse)
    {
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
     }
    else {
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleMine.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:14];
    }

    self.bubbleImage.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
	self.bubbleImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.bubbleImage];
	[self.contentView bringSubviewToFront:self.customView];
}

-(id)initWithData:(NSBubbleData *)aData {
	self = [super init];
	if (self) {
		self.data = aData;
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	[self setupInternalData];
}


- (void)layoutSubviews {
	[super layoutSubviews];
}

@end
