//
//  VeLogsListController.m
//  Vē
//
//  Created by Alexandra Aurora Göttlicher
//

#import "VeLogsListController.h"

@implementation VeLogsListController
/**
 * Sets up the controller's view.
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    load_preferences();

    [self setSearchController:[[UISearchController alloc] init]];
    [[[self searchController] searchBar] setDelegate:self];
    [[self searchController] setObscuresBackgroundDuringPresentation:NO];
    [[self navigationItem] setSearchController:[self searchController]];

    [self setPullToRefreshControl:[[UIRefreshControl alloc] init]];
    [[self pullToRefreshControl] addTarget:self action:@selector(handlePullToRefresh) forControlEvents:UIControlEventValueChanged];
    [[self pullToRefreshControl] setTintColor:[UIColor labelColor]];
    [[self table] setRefreshControl:[self pullToRefreshControl]];

    [self setBiometricProtectionOverlayView:[[BiometricProtectionOverlayView alloc] initWithFrame:[[self view] bounds]]];
    [[self biometricProtectionOverlayView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [[self view] addSubview:[self biometricProtectionOverlayView]];

    if (pfUseBiometricProtection) {
        [self showBiometricProtectionOverlay];
        [self checkBiometrics];
    } else {
        [self hideBiometricProtectionOverlay];
    }

    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

    [self reloadSpecifiers];
}

/**
 * Sets up the filter button.
 *
 * The filter button needs to be set up after the view has loaded.
 * Otherwise the default "Edit" button will override it.
 *
 * @param animated
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setFilterButton:[[UIButton alloc] init]];
    [[self filterButton] setImage:[[UIImage systemImageNamed:@"line.3.horizontal.decrease.circle"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:23 weight:UIImageSymbolWeightRegular]] forState:UIControlStateNormal];
    [[self filterButton] setTintColor:[UIColor systemBlueColor]];

    UIAction* applicationSortingAction = [UIAction actionWithTitle:kPreferenceKeySortingApplication image:nil identifier:nil handler:^(__kindof UIAction* _Nonnull action) {
        pfSorting = kPreferenceKeySortingApplication;
        [preferences setObject:pfSorting forKey:kPreferenceKeySorting];
        [self reloadSpecifiers];
    }];
    UIAction* dateSortingAction = [UIAction actionWithTitle:kPreferenceKeySortingDate image:nil identifier:nil handler:^(__kindof UIAction* _Nonnull action) {
        pfSorting = kPreferenceKeySortingDate;
        [preferences setObject:pfSorting forKey:kPreferenceKeySorting];
        [self reloadSpecifiers];
    }];

    UIMenu* menu = [UIMenu menuWithTitle:@"" children:@[applicationSortingAction, dateSortingAction]];

    [[self filterButton] setMenu:menu];
    [[self filterButton] setShowsMenuAsPrimaryAction:YES];

    [self setItem:[[UIBarButtonItem alloc] initWithCustomView:[self filterButton]]];
    [[self navigationItem] setRightBarButtonItem:[self item]];
}

/**
 * Shows the biometric protection overlay when the app resigns active.
 *
 * @param notification
 */
- (void)applicationWillResignActive:(NSNotification *)notification {
    if (pfUseBiometricProtection) {
        [self showBiometricProtectionOverlay];
    }
}

/**
 * Notes that a biometric protection check should be performed when the app will enter the foreground.
 *
 * @param notification
 */
- (void)applicationWillEnterForeground:(NSNotification *)notification {
    wantsAuth = YES;
}

/**
 * Performs a biometric protection check and applies the filter button when the app entered the foreground.
 *
 * @param notification
 */
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    // The filter button is overridden by the default edit button again when the app enters the foreground.
    [[self navigationItem] setRightBarButtonItem:[self item]];

    if (pfUseBiometricProtection && wantsAuth) {
        wantsAuth = NO;
        [self checkBiometrics];
    } else if (![[self biometricProtectionOverlayView] isHidden]) {
        // UIApplicationWillEnterForegroundNotification is only fired when the app is in the background,
        // which means wantsAuth isn't set to YES when the app is pushed to the app switcher for example.
        // Since the biometric protection overlay is shown when the app resigns active, it needs to be hidden again.
        [self hideBiometricProtectionOverlay];
    }
}

/**
 * Performs a biometric protection check.
 *
 * If access granted, the biometric protection overlay view will be hidden.
 * Else, it'll pop the controller.
 */
- (void)checkBiometrics {
    LAContext* laContext = [[LAContext alloc] init];
    [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"Vē needs to make sure you're permitted to view the notification logs." reply:^(BOOL success, NSError* _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [self hideBiometricProtectionOverlay];
            } else {
                [[self navigationController] popViewControllerAnimated:YES];
            }
        });
    }];
}

/**
 * Shows the biometric protection overlay.
 */
- (void)showBiometricProtectionOverlay {
    [[self biometricProtectionOverlayView] setHidden:NO];
}

/**
 * Hides the biometric protection overlay.
 */
- (void)hideBiometricProtectionOverlay {
    [[self biometricProtectionOverlayView] setHidden:YES];
}

/**
 * Reloads the specifiers via pull to refresh.
 */
- (void)handlePullToRefresh {
    [self reloadSpecifiers];
    [[self pullToRefreshControl] endRefreshing];

    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[self pullToRefreshControl] setAlpha:0];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [[self pullToRefreshControl] setAlpha:1];
        } completion:nil];
    }];
}

/**
 * Reloads the specifiers when the search button was tapped.
 *
 * @param searchBar
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self reloadSpecifiers];
}

/**
 * Resets the search bar text when the cancel button was tapped.
 *
 * @param searchBar
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // The search bar's text is actually cleared by default when the cancel button is clicked.
    // However, it's not cleared before the specifiers are reloaded, so the search results are still shown.
    [[[self searchController] searchBar] setText:@""];
    [self reloadSpecifiers];
}

/**
 * Sets up the specifiers.
 *
 * @return The specifiers.
 */
- (NSArray *)specifiers {
    _specifiers = [[NSMutableArray alloc] init];

    if ([self searchController] && ![[[[self searchController] searchBar] text] isEqualToString:@""]) {
        [_specifiers addObjectsFromArray:[self getSpecifiersForSorting:kPreferenceKeySortingSearch withObject:[[[self searchController] searchBar] text]]];
    } else {
        [_specifiers addObjectsFromArray:[self getSpecifiersForSorting:pfSorting withObject:nil]];
    }

    return _specifiers;
}

/**
 * Returns an array of sorted specifiers.
 *
 * @param sorting The sorting mode.
 * @param object The object used to sort with.
 *
 * @return The array of specifiers.
 */
- (NSArray *)getSpecifiersForSorting:(NSString *)sorting withObject:(id)object {
    NSArray* specifiers = @[];

    id sorter = nil;
    if ([sorting isEqualToString:kPreferenceKeySortingApplication]) {
        sorter = [[ApplicationSorter alloc] initWithObject:object];
    } else if ([sorting isEqualToString:kPreferenceKeySortingDate]) {
        sorter = [[DateSorter alloc] initWithObject:object];
    } else if ([sorting isEqualToString:kPreferenceKeySortingSearch]) {
        sorter = [[SearchSorter alloc] initWithObject:object];
    }
    specifiers = [sorter getSpecifiers];

    // The target is this controller and not the sorter.
    for (PSSpecifier* specifier in specifiers) {
        [specifier setTarget:self];
        [specifier setProperty:NSStringFromSelector(@selector(removedSpecifier:)) forKey:PSDeletionActionKey];
    }

    return specifiers;
}

/**
 * Removes a log.
 *
 * Called when a specifier was removed.
 *
 * @param specifier The specifier that was removed.
 */
- (void)removedSpecifier:(PSSpecifier *)specifier {
    [[LogManager sharedInstance] removeLog:[specifier propertyForKey:@"log"]];
    [self reloadSpecifiers];
}

/**
 * Prevents the specifiers from reloading on resume.
 *
 * @return Whether to reload the specifiers on resume.
 */
- (BOOL)shouldReloadSpecifiersOnResume {
    return NO;
}

/**
 * Loads the user's preferences.
 */
static void load_preferences() {
    preferences = [[NSUserDefaults alloc] initWithSuiteName:kPreferencesIdentifier];

    [preferences registerDefaults:@{
        kPreferenceKeyUseBiometricProtection: @(kPreferenceKeyUseBiometricProtectionDefaultValue),
        kPreferenceKeySorting: kPreferenceKeySortingDefaultValue
    }];

    pfUseBiometricProtection = [[preferences objectForKey:kPreferenceKeyUseBiometricProtection] boolValue];
    pfSorting = [preferences objectForKey:kPreferenceKeySorting];
}
@end
