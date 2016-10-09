//
//  CreateContactViewController.swift
//  AddressBookContacts
//
//  Created by Ignacio Nieto Carvajal on 21/4/16.
//  Copyright © 2016 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit
import Contacts
import AddressBook

enum ContactType {
    case addressBookContact
    case cnContact
}

class CreateContactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // outlets
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var emailAddressTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    
    // data
    var type: ContactType?
    var contactImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contactImageView.layer.cornerRadius = contactImageView.frame.size.width / 2.0
        contactImageView.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // create contact
    func createAddressBookContactWithFirstName(_ firstName: String, lastName: String, email: String?, phone: String?, image: UIImage?) {
        // first check permissions.
        let abAuthStatus = ABAddressBookGetAuthorizationStatus()
        if abAuthStatus == .denied || abAuthStatus == .restricted {
            self.showAlertMessage("Sorry, you are not authorize to access the contacts.")
            return
        }
        
        // get addressbook reference.
        let addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        // now let's create the contact.
        let newContact: ABRecord = ABPersonCreate().takeRetainedValue()
        
        // first name
        if !ABRecordSetValue(newContact, kABPersonFirstNameProperty, firstName as CFTypeRef, nil) {
            self.showAlertMessage("Error setting first name for the new contact")
            return
        }
        // last name
        if !ABRecordSetValue(newContact, kABPersonLastNameProperty, lastName as CFTypeRef, nil) {
            self.showAlertMessage("Error setting last name for the new contact")
            return
        }
        // email
        if email != nil {
            let emails: ABMutableMultiValue =
                ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
            ABMultiValueAddValueAndLabel(emails, email! as CFTypeRef!, kABHomeLabel, nil)
            if !ABRecordSetValue(newContact, kABPersonEmailProperty, emails, nil) {
                self.showAlertMessage("Error setting email for the new contact")
                return
            }

        }
        
        // phone number
        if phone != nil {
            let phoneNumbers: ABMutableMultiValue =
                ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
            ABMultiValueAddValueAndLabel(phoneNumbers, phone! as CFTypeRef!, kABPersonPhoneMainLabel, nil)
            if !ABRecordSetValue(newContact, kABPersonPhoneProperty, phoneNumbers, nil) {
                self.showAlertMessage("Error setting phone number for the new contact")
                return
            }
        }
        
        // image
        if image != nil {
            let imageData = UIImageJPEGRepresentation(image!, 0.9)
            if !ABPersonSetImageData(newContact, imageData as CFData!, nil) {
                self.showAlertMessage("Error setting image for the new contact")
                return
            }
        }
        
        // finally, store person and save addressbook
        var errorSavingContact = false
        if ABAddressBookAddRecord(addressBookRef, newContact, nil) { // stored. Now save addressbook.
            if ABAddressBookHasUnsavedChanges(addressBookRef){
                if !ABAddressBookSave(addressBookRef, nil) {
                    errorSavingContact = true
                }
            }
        }
                    
        if errorSavingContact { self.showAlertMessage("There was an error storing your new contact. Please try again.") }
        else { self.presentingViewController?.dismiss(animated: true, completion: nil) }
    }

    @available(iOS 9.0, *)
    func createCNContactWithFirstName(_ firstName: String, lastName: String, email: String?, phone: String?, image: UIImage?) {
        // create contact with mandatory values: first and last name
        let newContact = CNMutableContact()
        newContact.givenName = firstName
        newContact.familyName = lastName
        
        // email
        if email != nil {
            let contactEmail = CNLabeledValue(label: CNLabelHome, value: email! as NSString)
            newContact.emailAddresses = [contactEmail]
        }
        // phone
        if phone != nil {
            let contactPhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: phone!))
            newContact.phoneNumbers = [contactPhone]
        }
        
        // image
        if image != nil {
            newContact.imageData = UIImageJPEGRepresentation(image!, 0.9)
        }
        
        do {
            let newContactRequest = CNSaveRequest()
            newContactRequest.add(newContact, toContainerWithIdentifier: nil)
            try CNContactStore().execute(newContactRequest)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } catch {
            self.showAlertMessage("I was unable to create the new contact. An error occurred.")
        }
    }
    
    // MARK: - Button actions
    @IBAction func createContact(_ sender: AnyObject) {
        // check if we can create a contact.
        if let firstName = firstNameTextfield.text , firstName.characters.count > 0,
            let lastName = lastNameTextfield.text , lastName.characters.count > 0 {
            let email = emailAddressTextfield.text
            let phone = phoneNumberTextfield.text
            
            if type == .addressBookContact {
                createAddressBookContactWithFirstName(firstName, lastName: lastName, email: email, phone: phone, image: contactImage)
            } else if type == .cnContact {
                if #available(iOS 9, *) {
                    createCNContactWithFirstName(firstName, lastName: lastName, email: email, phone: phone, image: contactImage)
                } else {
                    self.showAlertMessage("Sorry, you can only use the Contacts framework from iOS 9.")
                }

            }
        } else {
            self.showAlertMessage("Please, insert at least a first and last name for the contact.")
        }
    }
    
    @IBAction func changeContactImage(_ sender: AnyObject) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.contactImage = info[UIImagePickerControllerEditedImage] as? UIImage
        self.contactImageView.image = self.contactImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func goBack(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
