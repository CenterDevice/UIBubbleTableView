//
//  NSBubbleData.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <QuartzCore/QuartzCore.h>

#import "NSBubbleData.h"
#import "CDUser.h"

@implementation NSBubbleData

#pragma mark - Properties

@synthesize date = _date;
@synthesize type = _type;
@synthesize view = _view;
@synthesize insets = _insets;
@synthesize avatar = _avatar;
@synthesize author = _author;
@synthesize comment = _comment;

static NSUInteger maxContentWidth = 400;

-(NSString *)description {
	return [NSString stringWithFormat:@"comment id : %@, text : %@", _comment.commentId, _comment.text];
}

#pragma mark - Lifecycle

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_date release];
	_date = nil;
    [_view release];
    _view = nil;
	[_author release];
	_author = nil;

    self.avatar = nil;

    [super dealloc];
}
#endif

#pragma mark - Text bubble

const UIEdgeInsets textInsetsMine = {5, 10, 11, 17};
const UIEdgeInsets textInsetsSomeone = {5, 15, 11, 10};

+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type
{
    return [[NSBubbleData alloc] initWithText:text date:date type:type];
}

+ (id)dataWithText:(NSString *)text date:(NSDate *)date author:(NSString *)author type:(NSBubbleType)type {
	return [[NSBubbleData alloc] initWithText:text date:date author:author type:type];
}

- (id)dataWithComment:(CDComment *)aComment type:(NSBubbleType)type {
	if (type == BubbleTypeMine) {
		aComment.myComment = YES;
	}else {
		aComment.myComment = NO;
	}
	return [self initWithComment:aComment type:type];
}

-(id)initWithComment:(CDComment *)comment type:(NSBubbleType)type {
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
#if LINEBREAKMODE
	    CGSize size = [(comment.text ? comment.text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(maxContentWidth, 9999) lineBreakMode: UILineBreakModeWordWrap];
#else
    CGSize size = [(comment.text ? comment.text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(maxContentWidth, 9999) lineBreakMode: NSLineBreakByWordWrapping];
#endif

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines = 0;
#if LINEBREAKMODE
    label.lineBreakMode = UILineBreakModeWordWrap;
#else
    label.lineBreakMode = NSLineBreakByWordWrapping;
#endif
    label.text = (comment.text ? comment.text : @"");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];

    UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
	return [self initWithView:label comment:comment type:type insets:insets];
}

- (id)initWithView:(UIView *)view comment:(CDComment *)comment type:(NSBubbleType)type insets:(UIEdgeInsets)insets {
	self = [super init];
    if (self)
    {
        _view = view;
        _date = comment.creationDate;
		_author = [NSString stringWithFormat:@"%@ %@", comment.author.firstName, comment.author.lastName];
		_comment = comment;
        _type = type;
        _insets = insets;
    }
    return self;
}

- (id)initWithText:(NSString *)text date:(NSDate *)date author:(NSString *)author type:(NSBubbleType)type {
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
#if LINEBREAKMODE
    CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(maxContentWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
#else
    CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(maxContentWidth, 9999) lineBreakMode:NSLineBreakByWordWrapping];
#endif

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines = 0;
#if LINEBREAKMODE
    label.lineBreakMode = UILineBreakModeWordWrap;
#else
    label.lineBreakMode = NSLineBreakByWordWrapping;
#endif
    label.text = (text ? text : @"");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];

    UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
	return [self initWithView:label date:date author:author type:type insets:insets];
}


- (id)initWithView:(UIView *)view date:(NSDate *)date author:(NSString *)author type:(NSBubbleType)type insets:(UIEdgeInsets)insets {
    self = [super init];
    if (self)
    {
        _view = view;
        _date = date;
		_author = author;
        _type = type;
        _insets = insets;
    }
    return self;
}

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type
{
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
#if LINEBREAKMODE
    CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(maxContentWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
#else
    CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(maxContentWidth, 9999) lineBreakMode:NSLineBreakByWordWrapping];
#endif

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines = 0;
#if LINEBREAKMODE
    label.lineBreakMode = UILineBreakModeWordWrap;
#else
    label.lineBreakMode = NSLineBreakByWordWrapping;
#endif
    label.text = (text ? text : @"");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];

    UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:label date:date type:type insets:insets];
}

#pragma mark - Image bubble

const UIEdgeInsets imageInsetsMine = {11, 13, 16, 22};
const UIEdgeInsets imageInsetsSomeone = {11, 18, 16, 14};

+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type
{
    return [[NSBubbleData alloc] initWithImage:image date:date type:type];
}

- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type
{
    CGSize size = image.size;
    if (size.width > maxContentWidth)
    {
        size.height /= (size.width / maxContentWidth);
        size.width = maxContentWidth;
    }

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = image;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;

    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:imageView date:date type:type insets:insets];
}

#pragma mark - Custom view bubble

+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets
{
    return [[NSBubbleData alloc] initWithView:view date:date type:type insets:insets];
}


- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets
{
    self = [super init];
    if (self)
    {
        _view = view;
        _date = date;
        _type = type;
        _insets = insets;
    }
    return self;
}

@end
