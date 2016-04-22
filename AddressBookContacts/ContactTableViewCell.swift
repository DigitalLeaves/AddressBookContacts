//
//  ContactTableViewCell.swift
//  AddressBookContacts
//
//  Created by Ignacio Nieto Carvajal on 20/4/16.
//  Copyright © 2016 Ignacio Nieto Carvajal. All rights reserved.
//

import AddressBook
import Contacts
import UIKit

class ContactTableViewCell: UITableViewCell {
    // outlets
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var contactPhoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCircularAvatar() {
        contactImageView.layer.cornerRadius = contactImageView.bounds.size.width / 2.0
        contactImageView.layer.masksToBounds = true
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setCircularAvatar()
    }
    
    func configureWithContactEntry(contact: ContactEntry) {
        contactNameLabel.text = contact.name
        contactEmailLabel.text = contact.email ?? ""
        contactPhoneLabel.text = contact.phone ?? ""
        contactImageView.image = contact.image ?? UIImage(named: "defaultUser")
        setCircularAvatar()
    }
}
