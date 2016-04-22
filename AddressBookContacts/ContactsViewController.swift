//
//  ContactsViewController.swift
//  AddressBookContacts
//
//  Created by Ignacio Nieto Carvajal on 20/4/16.
//  Copyright © 2016 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit
import Contacts

@available(iOS 9.0, *)
class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noContactsLabel: UILabel!
    
    // data
    var contactStore = CNContactStore()
    var contacts = [ContactEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.hidden = true
        noContactsLabel.hidden = false
        noContactsLabel.text = "Retrieving contacts..."
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        requestAccessToContacts { (success) in
            if success {
                self.retrieveContacts({ (success, contacts) in
                    self.tableView.hidden = !success
                    self.noContactsLabel.hidden = success
                    if success && contacts?.count > 0 {
                        self.contacts = contacts!
                        self.tableView.reloadData()
                    } else {
                        self.noContactsLabel.text = "Unable to get contacts..."
                    }
                })
            }
        }
    }

    
    func requestAccessToContacts(completion: (success: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
        case .Authorized: completion(success: true) // authorized previously
        case .Denied, .NotDetermined: // needs to ask for authorization
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (accessGranted, error) -> Void in
                completion(success: accessGranted)
            })
        default: // not authorized.
            completion(success: false)
        }
    }
    
    func retrieveContacts(completion: (success: Bool, contacts: [ContactEntry]?) -> Void) {
        var contacts = [ContactEntry]()
        do {
            let contactsFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactImageDataKey, CNContactImageDataAvailableKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey])
            try contactStore.enumerateContactsWithFetchRequest(contactsFetchRequest, usingBlock: { (cnContact, error) in
                if let contact = ContactEntry(cnContact: cnContact) { contacts.append(contact) }
            })
            completion(success: true, contacts: contacts)
        } catch {
            completion(success: false, contacts: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createNewContact(sender: AnyObject) {
        self.performSegueWithIdentifier("CreateContact", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? CreateContactViewController {
            dvc.type = .CNContact
        }
    }
    
    // UITableViewDataSource && Delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactTableViewCell", forIndexPath: indexPath) as! ContactTableViewCell
        let entry = contacts[indexPath.row]
        cell.configureWithContactEntry(entry)
        cell.layoutIfNeeded()

        return cell
    }
}
