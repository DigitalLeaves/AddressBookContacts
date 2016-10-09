//
//  AddressBookViewController.swift
//  AddressBookContacts
//
//  Created by Ignacio Nieto Carvajal on 20/4/16.
//  Copyright © 2016 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit
import AddressBook
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AddressBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noContactsLabel: UILabel!

    // data
    var contacts = [ContactEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // initial appearance
        tableView.isHidden = true
        noContactsLabel.isHidden = false
        noContactsLabel.text = "Retrieving contacts..."

        retrieveAddressBookContacts { (success, contacts) in
            self.tableView.isHidden = !success
            self.noContactsLabel.isHidden = success
            if success && contacts?.count > 0 {
                self.contacts = contacts!
                self.tableView.reloadData()
            } else {
                self.noContactsLabel.text = "Unable to get contacts..."
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createNewContact(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "CreateContact", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? CreateContactViewController {
            dvc.type = .addressBookContact
        }
    }
    
    // AddressBook methods
    func retrieveAddressBookContacts(_ completion: @escaping (_ success: Bool, _ contacts: [ContactEntry]?) -> Void) {
        let abAuthStatus = ABAddressBookGetAuthorizationStatus()
        if abAuthStatus == .denied || abAuthStatus == .restricted {
            completion(false, nil)
            return
        }
        
        let addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError?) in
            DispatchQueue.main.async {
                if !granted {
                    self.showAlertMessage("Sorry, you have no permission for accessing the address book contacts.")
                } else {
                    var contacts = [ContactEntry]()
                    let abPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as Array
                    for abPerson in abPeople {
                        if let contact = ContactEntry(addressBookEntry: abPerson) { contacts.append(contact) }
                    }
                    completion(true, contacts)
                }
            }
        }
    }
    
    // UITableViewDataSource && Delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        let entry = contacts[(indexPath as NSIndexPath).row]
        cell.configureWithContactEntry(entry)
        cell.layoutIfNeeded()
        return cell
    }
    
}
