//
//  String+Email.swift
//  AddressBookContacts
//
//  Created by Ignacio Nieto Carvajal on 21/4/16.
//  Copyright © 2016 Ignacio Nieto Carvajal. All rights reserved.
//

import Foundation

extension String {
    
    func isEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]+$", options: NSRegularExpressionOptions.CaseInsensitive)
            return regex.firstMatchInString(self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
        } catch { return false }
    }
    
}