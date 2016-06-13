//
//  STTableRowView.m
//  States
//
//  Created by Dmitry Rodionov on 10/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STColorFactory.h"
#import "STTableRowView.h"
#import "STTableCellView.h"

@interface STTableRowView()
@property (readwrite, weak) NSTableView *tableView;
@end

@implementation STTableRowView

- (instancetype)initWithTableView:(NSTableView *)containingTableView
{
	if ((self = [super initWithFrame: NSZeroRect])) {
		_tableView = containingTableView;
	}
	return self;
}

- (void)drawBackgroundInRect:(NSRect)dirtyRect
{
	[super drawBackgroundInRect: dirtyRect];
	NSInteger row = [self.tableView rowForView: self];
	if (row % 2 == 0) {
		[[STColorFactory mainTableViewRowColor] setFill];
	} else {
		[[STColorFactory secondaryTableViewRowColor] setFill];
	}
	NSBezierPath *path = [NSBezierPath bezierPathWithRect: dirtyRect];
	[path fill];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self updateTextFieldWithAlphaValue: 1.0f];
	});
}

- (void)drawSelectionInRect: (NSRect)dirtyRect
{
	[super drawBackgroundInRect: dirtyRect];
	if (self.emphasized) {
		[[STColorFactory selectedTableViewRowColor] setFill];
	} else {
		[[STColorFactory selectedInactiveTableViewRowColor] setFill];
	}
	NSBezierPath *path = [NSBezierPath bezierPathWithRect: dirtyRect];
	[path fill];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self updateTextFieldWithAlphaValue: self.representsCurrentRow ? 1.0f : 0.5f];
	});
}

#pragma mark -

// TODO: refactor the delegate to return just YES or NO
- (BOOL)representsCurrentRow
{
	return [self.delegate cellViewRepresentingCurrentState] == self.cellView;
}

- (STTableCellView *)cellView
{
	return [self subviews].firstObject;
}

- (void)updateTextFieldWithAlphaValue: (CGFloat)newAlpha
{
	NSTextField *textField = self.cellView.textField;
	textField.textColor = [textField.textColor colorWithAlphaComponent: newAlpha];
}

@end
