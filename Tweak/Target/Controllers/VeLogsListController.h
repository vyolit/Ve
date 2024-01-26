//
//  VeLogsListController.h
//  Vē
//
//  Created by Alexandra Aurora Göttlicher
//

#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import "../../../Preferences/PreferenceKeys.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "Views/BiometricProtectionOverlayView.h"
#import "../../../Manager/LogManager.h"
#import "Sorter/ApplicationSorter.h"
#import "Sorter/DateSorter.h"
#import "Sorter/SearchSorter.h"
#import "../Controllers/Cells/VeLogCell.h"
#import "VeDetailListController.h"

static BOOL wantsAuth = NO;

NSUserDefaults* preferences;
BOOL pfUseBiometricProtection;
NSString* pfSorting;

@interface VeLogsListController : PSEditableListController <UISearchBarDelegate>
@property(nonatomic)UIButton* filterButton;
@property(nonatomic)UIBarButtonItem* item;
@property(nonatomic)BiometricProtectionOverlayView* biometricProtectionOverlayView;
@property(nonatomic)UIRefreshControl* pullToRefreshControl;
@property(nonatomic)UISearchController* searchController;
@end
