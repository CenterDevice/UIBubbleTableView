//
//  UIBubbleHeaderTableViewCell.m
//  UIBubbleTableViewExample
//
//  Created by Александр Баринов on 10/7/12.
//  Copyright (c) 2012 Stex Group. All rights reserved.
//

#import "UIBubbleHeaderTableViewCell.h"

@interface UIBubbleHeaderTableViewCell ()

@property (nonatomic, retain) UILabel *label;

@end

@implementation UIBubbleHeaderTableViewCell

@synthesize label = _label;
@synthesize date = _date;
@synthesize author = _author;

+ (CGFloat)height
{
    return 28.0;
}
#ifndef DATE_FORMAT_TEMPLATE_DATE_AND_TIME
#define DATE_FORMAT_TEMPLATE_DATE_AND_TIME @"dd.MM.yyyy j:mm"
#endif

- (void)setAuthor:(NSString *)authorName andDate:(NSDate *)date type:(NSBubbleType)type{
	self.author = authorName;
	self.date = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:DATE_FORMAT_TEMPLATE_DATE_AND_TIME
                                                                    options:0
                                                                     locale:[NSLocale autoupdatingCurrentLocale]];
    NSString * dateString = [dateFormatter stringFromDate:self.date];
	NSString* commentHeader = [NSString stringWithFormat:CDLocalizedStringFromTable(@"bubble.header.cell.text", @"UIBubbleHeaderTableViewCell", @"Heading for a particular comment. Param 1 is the author, param 2 the formatted addition/edit date."), self.author, dateString];
    if (self.label)
    {
        self.label.text = commentHeader;
        return;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [UIBubbleHeaderTableViewCell height])];
	self.label.text = commentHeader;
    self.label.font = [UIFont boldSystemFontOfSize:12];
    self.label.textAlignment = UITextAlignmentCenter;
    self.label.shadowOffset = CGSizeMake(0, 1);
    self.label.shadowColor = [UIColor whiteColor];
    self.label.textColor = [UIColor darkGrayColor];
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {   // Go through all subviews
        if ([view isKindOfClass:[UILabel class]]) {  // Find the uilabel subview
            view.frame = CGRectOffset(view.frame, 55, 0);   // Move it center the the subview of cell
        }
    }
}

@end
