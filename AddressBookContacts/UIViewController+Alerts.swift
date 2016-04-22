//
//  UIViewController+Alerts.swift
//  AddressBookContacts
//
//  Created by Ignacio Nieto Carvajal on 20/4/16.
//  Copyright © 2016 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     * Shows a default alert/info message with an OK button.
     */
    func showAlertMessage(message: String, okButtonTitle: String = "Ok") -> Void {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: okButtonTitle, style: .Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}