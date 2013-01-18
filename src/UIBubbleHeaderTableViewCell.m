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

#define DATE_FORMAT_TEMPLATE_DATE_AND_TIME @"dd.MM.yyyy j:mm"

- (void)setAuthor:(NSString *)authorName andDate:(NSDate *)date type:(NSBubbleType)type{
	self.author = authorName;
	self.date = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:DATE_FORMAT_TEMPLATE_DATE_AND_TIME
                                                                    options:0
                                                                     locale:[NSLocale autoupdatingCurrentLocale]];
    NSString *text = [dateFormatter stringFromDate:self.date];
	NSString* onDateText = CDLocalizedStringFromTable(@"buble.header.cell.part.of.label.text", @"UIBubbleHeaderTableViewCell", @"Adverb used in label text when comment is created or edited.");
    if (self.label)
    {
        self.label.text = [NSString stringWithFormat:@"%@ %@ %@", self.author, onDateText, text];
        return;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [UIBubbleHeaderTableViewCell height])];
	self.label.text = [NSString stringWithFormat:@"%@ %@ %@", self.author, onDateText, text];
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
