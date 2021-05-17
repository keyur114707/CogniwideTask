//
//  String.swift
//  cogniwideAssesment
//
//  Created by Keyur Patel on 14/05/21.
//  Copyright © 2021 cogniwide. All rights reserved.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        }
        catch {
            return false
        }
    }
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,20}$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        }
        catch {
            return false
        }
    }
}
