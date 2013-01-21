//
//  UIBubbleTableView.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "UIBubbleTableView.h"
#import "NSBubbleData.h"
#import "UIBubbleHeaderTableViewCell.h"
#import "UIBubbleTypingTableViewCell.h"
#import "CDContext.h"
#import "User.h"
#import "Comment.h"

@interface UIBubbleTableView ()

@property (nonatomic, retain) NSMutableArray *bubbleSection;

@end

@implementation UIBubbleTableView

@synthesize bubbleDataSource = _bubbleDataSource;
@synthesize snapInterval = _snapInterval;
@synthesize bubbleSection = _bubbleSection;
@synthesize typingBubble = _typingBubble;
@synthesize showAvatars = _showAvatars;
@synthesize comments = _comments;

#pragma mark - Initializators

- (void)initializator
{
    // UITableView properties
    
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    assert(self.style == UITableViewStylePlain);
	
    self.delegate = self;
    self.dataSource = self;
    
    // UIBubbleTableView default properties
    
    self.typingBubble = NSBubbleTypingTypeNobody;
	
	//add padding at bottom after last comment
	CGFloat bottomPadding = 44;
	UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, bottomPadding, 0);
	[self setContentInset:insets];
	
}

- (id)init
{
    self = [super init];
    if (self) [self initializator];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) [self initializator];
    return self;
}


#pragma mark - Override

- (void)reloadData
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    // Cleaning up
	self.bubbleSection = nil;
    
    // Loading new data
    int count = 0;

    self.bubbleSection = [[NSMutableArray alloc] init];
    
    if (self.bubbleDataSource && (count = [self.bubbleDataSource rowsForBubbleTable:self]) > 0)
    {
        NSMutableArray *bubbleData = [[NSMutableArray alloc] initWithCapacity:count];
        
        for (int i = 0; i < count; i++)
        {
            NSObject *object = [self.bubbleDataSource bubbleTableView:self dataForRow:i];
            assert([object isKindOfClass:[NSBubbleData class]]);
            [bubbleData addObject:object];
        }
        
        [bubbleData sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
         {
             NSBubbleData *bubbleData1 = (NSBubbleData *)obj1;
             NSBubbleData *bubbleData2 = (NSBubbleData *)obj2;
             
             return [bubbleData1.date compare:bubbleData2.date];            
         }];
        
        NSMutableArray *currentSection = nil;
        
        for (int i = 0; i < count; i++)
        {
            NSBubbleData *data = (NSBubbleData *)[bubbleData objectAtIndex:i];

                currentSection = [[NSMutableArray alloc] init];
                [self.bubbleSection addObject:currentSection];
            
            [currentSection addObject:data];
        }
    }
    
    [super reloadData];
}

#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	[self.bubbleDataSource editExistingCommentForIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = [self.bubbleSection count];
    if (self.typingBubble != NSBubbleTypingTypeNobody) result++;
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // This is for now typing bubble
	if (section >= [self.bubbleSection count]) return 1;
    
    return [[self.bubbleSection objectAtIndex:section] count] + 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Now typing
	if (indexPath.section >= [self.bubbleSection count])
    {
        return MAX([UIBubbleTypingTableViewCell height], self.showAvatars ? 52 : 0);
    }
    
    // Header
    if (indexPath.row == 0)
    {
        return [UIBubbleHeaderTableViewCell height];
    }
    
    NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
    return MAX(data.insets.top + data.view.frame.size.height + data.insets.bottom, self.showAvatars ? 52 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Now typing
	if (indexPath.section >= [self.bubbleSection count])
    {
        static NSString *cellId = @"tblBubbleTypingCell";
        UIBubbleTypingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (cell == nil) cell = [[UIBubbleTypingTableViewCell alloc] init];

        cell.type = self.typingBubble;
        cell.showAvatar = self.showAvatars;
        cell.shouldIndentWhileEditing = NO;
        return cell;
    }

    // Header with date and time and author
    if (indexPath.row == 0)
    {
        static NSString *cellId = @"tblBubbleHeaderCell";
        UIBubbleHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:0];
        
        if (cell == nil) cell = [[UIBubbleHeaderTableViewCell alloc] init];

		[cell setAuthor:data.author andDate:data.date type:data.type];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.shouldIndentWhileEditing = NO;
        return cell;
    }
    
    // Standard bubble    
    static NSString *cellId = @"tblBubbleCell";
    UIBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
    if (cell == nil) {
		cell = [[UIBubbleTableViewCell alloc] initWithData:data];
	}
    cell.data = data;
    cell.showAvatar = self.showAvatars;
	cell.shouldIndentWhileEditing = NO;
	cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
	if(indexPath.row == 0) {
		return NO;
	}
    NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
	if (data.comment.isMyComment) {
		return YES;
	}
	return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[self.bubbleSection removeObjectAtIndex:indexPath.section];
		[tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
		[self.bubbleDataSource updateDataSource:indexPath]; //indexPath.section is bubble with comment which is deleted
    }
}


@end
