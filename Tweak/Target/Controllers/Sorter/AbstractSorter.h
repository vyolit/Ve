//
//  AbstractSorter.h
//  Vē
//
//  Created by Alexandra Aurora Göttlicher
//

#import "SorterProtocol.h"
#import <Preferences/PSSpecifier.h>
#import "../VeDetailListController.h"
#import "../../Controllers/Cells/VeLogCell.h"

@interface AbstractSorter : NSObject
@property(nonatomic)id object;
- (instancetype)initWithObject:(id)object;
- (PSSpecifier *)createSpecifierForLog:(Log *)log;
@end
