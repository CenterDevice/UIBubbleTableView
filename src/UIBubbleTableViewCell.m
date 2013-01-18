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
@property (nonatomic, retain) UIButton* deleteBtn;
@property (nonatomic, retain) UIImage* deleteImg;

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
	[self setupInternalData];
}


#if !__has_feature(objc_arc)
- (void) dealloc
{
    self.data = nil;
    self.customView = nil;
    self.bubbleImage = nil;
    self.avatarImage = nil;
    [super dealloc];
}
#endif

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
	if (self.contentView.frame.origin.x >= 32) { // ugly fix when one comment is deleted all bubbles on the right hand side are moved from view to right
		self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width + self.contentView.frame.origin.x, self.contentView.frame.size.height);
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
    [self.contentView addSubview:self.bubbleImage];
	[self.contentView bringSubviewToFront:self.customView];
	self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage* deleteImg = [UIImage imageNamed:@"deleteBtn.png"];
	_deleteBtn.frame = CGRectMake(-100, 0, deleteImg.size.width, deleteImg.size.height);
	[_deleteBtn setImage:deleteImg forState:UIControlStateNormal];
	_deleteBtn.contentMode = UIViewContentModeScaleToFill;
	[_deleteBtn addTarget:self action:@selector(deleteComment) forControlEvents:UIControlEventTouchUpInside];
	_deleteBtn.hidden = YES;
	[self.contentView addSubview:_deleteBtn];
}


-(void)layoutSubviews {
	[super layoutSubviews];
	NSLog(@"self.contentView : %@", self.contentView);
//	self.deleteBtn.frame = CGRectMake(88, 0, 60, 60);
}


- (void)willTransitionToState:(UITableViewCellStateMask)state {
	
    [super willTransitionToState:state];
	
    if ((state & UITableViewCellStateShowingEditControlMask) == UITableViewCellStateShowingEditControlMask) {
		
        for (UIView *subview in self.subviews) {
			
          //  if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
				
                subview.hidden = NO;
               // subview.alpha = 0.0;
				[UIView beginAnimations:@"anim" context:nil];
				subview.alpha = 1.0;
				[UIView commitAnimations];
           // }
        }
    }
}

@end
