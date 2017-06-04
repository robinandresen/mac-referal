//
//  Constants.swift
//  MacResearch
//
//  Created by Simon Rowlands on 18/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import Foundation

let kSavedUser = "savedUser"

// General
let clientSecret = "uNkXHi2QS29EhNL1l4ehzBDAtkS2r7CYqrun0FUM"
let clientID = 2
let apiURL = "https://mac.appitized-dev.com/api/"
let oauthURL = "https://mac.appitized-dev.com/oauth/token"

// User APIs
let userEndpoint = "user?includes=medication,medical_indicators"
let registerEndpoint = "register"
let userUpdateEndpoint = "user"

// Contact APIs
let contactEndpoint = "contacts"

// Study APIs
let liveStudiesEndpoint = "live-studies"
let upcomingStudiesEndpoint = "upcoming-studies"
let myStudiesEndpoint = "my-studies"
let getStudyDetailEndpoint = "studies/"
let registerInterestEndpoint = "/register-interest"

// Register Interest Alert
let registerInterestSuccess = "Your interest in this study has been successfully registered!"
let registerInterestFailed = "Unfortunately your interest in this study has not been registered!"

// Update User Alert
let updateUserSuccess = "Your profile has been updated"

// Register Validation Rule
let REGEX_USER_NAME_LIMIT = "^.{3,10}$"
let REGEX_USER_NAME = "[A-Za-z0-9]{3,10}"
let REGEX_EMAIL = "[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
let REGEX_POSTCODE_LIMIT = "^.{4,10}$"
let REGEX_POSTCODE = "[0-9]{4,10}"
let REGEX_PASSWORD_LIMIT = "^.{6,20}$"
let REGEX_PASSWORD = "[A-Za-z0-9]{6,20}"
let REGEX_PHONE_DEFAULT = "[0-9]{4,10}"
