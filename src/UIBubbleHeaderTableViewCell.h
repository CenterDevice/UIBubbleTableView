//
//  UIBubbleHeaderTableViewCell.h
//  UIBubbleTableViewExample
//
//  Created by Александр Баринов on 10/7/12.
//  Copyright (c) 2012 Stex Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleTypes.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000 // iOS 6.0 or later
#define LINEBREAKMODE 0
#else                                         // iOS 5.X or earlier
#define LINEBREAKMODE 1
#endif


@interface UIBubbleHeaderTableViewCell : UITableViewCell

+ (CGFloat)height;
- (void)setAuthor:(NSString *)author andDate:(NSDate *)date type:(NSBubbleType)type;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *author;

@end
