//
//  HMKeychainWrapper.h
//  HMKeychainWrapper
//
//  Created by Himal Madhushan on 7/6/16.
//  Copyright © 2016 Himal Madhushan. All rights reserved.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Himal Madhushan
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//  https://github.com/MacKaSL
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HMKeychainType){
    HMKeychainTypeDeviceID,
    HMKeychainTypeOther
};

@interface HMKeychainWrapper : NSObject

+ (HMKeychainWrapper * _Nonnull)sharedInstance;

/**
 *  Generates a unique device id and saves it in the keychain. If the type == KeychainTypeDeviceID, Whatever string you pass through "secretString" will be ignored.
 *
 *  @param serviceName Service name
 *  @param accountName Account name
 *  @param secretStr   Secret string
 *  @param type        Keychain save type
 */
- (void)saveItemInKeyChainForService:(NSString * _Nonnull)serviceName account:(NSString * _Nonnull)accountName secretString:(NSString * _Nonnull)secretStr type:(HMKeychainType)type;

/**
 *  Retrieve the item saved for service name and account name.
 *
 *  @param serviceName Used service name
 *  @param accountName Used account name
 *
 *  @return Saved string item
 */
- (nullable NSString *)itemSavedInKeychainForService:(NSString * _Nonnull)serviceName account:(NSString * _Nonnull)accountName;
@end
