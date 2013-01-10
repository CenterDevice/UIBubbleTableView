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

//- (void)setDate:(NSDate *)value
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    NSString *text = [dateFormatter stringFromDate:value];
//    [dateFormatter release];
//    
//    if (self.label)
//    {
//        self.label.text = text;
//        return;
//    }
//    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [UIBubbleHeaderTableViewCell height])];
//    self.label.text = text;
//    self.label.font = [UIFont boldSystemFontOfSize:12];
//    self.label.textAlignment = UITextAlignmentCenter;
//    self.label.shadowOffset = CGSizeMake(0, 1);
//    self.label.shadowColor = [UIColor whiteColor];
//    self.label.textColor = [UIColor darkGrayColor];
//    self.label.backgroundColor = [UIColor clearColor];
//    [self addSubview:self.label];
//}

#define DATE_FORMAT_TEMPLATE_DATE_AND_TIME @"dd.MM.yyyy j:mm"


- (void)setAuthor:(NSString *)authorName andDate:(NSDate *)date {
	self.author = authorName;
	self.date = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:DATE_FORMAT_TEMPLATE_DATE_AND_TIME
                                                                    options:0
                                                                     locale:[NSLocale autoupdatingCurrentLocale]];
    NSString *text = [dateFormatter stringFromDate:self.date];
    [dateFormatter release];
#warning localize !!! "on" string 
    if (self.label)
    {
        self.label.text = [NSString stringWithFormat:@"%@ on %@", self.author, text];
        return;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [UIBubbleHeaderTableViewCell height])];
//    self.label.text = text;
	self.label.text = [NSString stringWithFormat:@"%@ on %@", self.author, text];
    self.label.font = [UIFont boldSystemFontOfSize:12];
    self.label.textAlignment = UITextAlignmentCenter;
    self.label.shadowOffset = CGSizeMake(0, 1);
    self.label.shadowColor = [UIColor whiteColor];
    self.label.textColor = [UIColor darkGrayColor];
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
}

@end
