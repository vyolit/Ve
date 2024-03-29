//
//  PreferenceKeys.h
//  Vē
//
//  Created by Alexandra Aurora Göttlicher
//

static NSString* const kPreferencesIdentifier = @"codes.aurora.ve.preferences";

static NSString* const kPreferenceKeyEnabled = @"Enabled";
static NSString* const kPreferenceKeyLogLimit = @"LogLimit";
static NSString* const kPreferenceKeySaveLocalAttachments = @"SaveLocalAttachments";
static NSString* const kPreferenceKeySaveRemoteAttachments = @"SaveRemoteAttachments";
static NSString* const kPreferenceKeyLogWithoutContent = @"LogWithoutContent";
static NSString* const kPreferenceKeyBlockedSenders = @"BlockedSenders";
static NSString* const kPreferenceKeyUseBiometricProtection = @"UseBiometricProtection";
static NSString* const kPreferenceKeyAutomaticallyDeleteLogs = @"AutomaticallyDeleteLogs";
static NSString* const kPreferenceKeyUseAmericanDateFormat = @"UseAmericanDateFormat";
static NSString* const kPreferenceKeySorting = @"Sorting";

static NSString* const kPreferenceKeySortingApplication = @"Application";
static NSString* const kPreferenceKeySortingDate = @"Date";
static NSString* const kPreferenceKeySortingSearch = @"Search";

static BOOL const kPreferenceKeyEnabledDefaultValue = YES;
static NSUInteger const kPreferenceKeyLogLimitDefaultValue = 2000;
static BOOL const kPreferenceKeySaveLocalAttachmentsDefaultValue = YES;
static BOOL const kPreferenceKeySaveRemoteAttachmentsDefaultValue = YES;
static BOOL const kPreferenceKeyLogWithoutContentDefaultValue = YES;
static NSArray* const kPreferenceKeyBlockedSendersDefaultValue = @[];
static BOOL const kPreferenceKeyUseBiometricProtectionDefaultValue = NO;
static BOOL const kPreferenceKeyAutomaticallyDeleteLogsDefaultValue = YES;
static BOOL const kPreferenceKeyUseAmericanDateFormatDefaultValue = NO;
static NSString* const kPreferenceKeySortingDefaultValue = kPreferenceKeySortingDate;
