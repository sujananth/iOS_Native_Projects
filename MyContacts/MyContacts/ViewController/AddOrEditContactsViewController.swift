//
//  AddOrEditContactsViewController.swift
//  MyContacts
//
//  Created by Sujananth on 10/28/18.
//  Copyright © 2018 sujananth. All rights reserved.
//

import UIKit

enum ContactDetails: Int, CaseIterable {
    case firstName
    case lastName
    case email
    case mobile
    case countryCode
}

protocol AddOrEditContactsViewDelegate: class {
    func saveContact()
    func addContact()
}

class AddOrEditContactsViewController: UIViewController {

    @IBOutlet weak var contactProfileImage: UIImageView!
    @IBOutlet weak var contactDetailsListTableView: UITableView!
    
    @IBOutlet weak var addOrSaveContactButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactProfileImage.image = UIImage(named: "ContactProfilePlaceHolder")
    }
    
    @IBAction func onTappingAddOrSaveContactButton(_ sender: Any) {
        
    }
}

extension AddOrEditContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactDetails.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactDetailCell = tableView.dequeueReusableCell(withIdentifier: "kContactDetailCellID", for: indexPath)
        if let detailCell = contactDetailCell as? ContactDetailTableViewCell {
            addPlaceHolderValueTo(cell: detailCell, index: indexPath.row)
        }
        return contactDetailCell
    }
}

extension AddOrEditContactsViewController: UITableViewDelegate {
    
}

extension AddOrEditContactsViewController {
    
    func addPlaceHolderValueTo( cell: ContactDetailTableViewCell, index:Int) {
        switch index {
        case ContactDetails.firstName.hashValue:
            cell.contactDetailTextField.placeholder = "First Name"
        case ContactDetails.lastName.hashValue:
            cell.contactDetailTextField.placeholder = "Last Name"
        case ContactDetails.email.hashValue:
            cell.contactDetailTextField.placeholder = "Email"
        case ContactDetails.mobile.hashValue:
            cell.contactDetailTextField.placeholder = "Mobile"
        case ContactDetails.countryCode.hashValue:
            cell.contactDetailTextField.placeholder = "Country Code"
        default:
            cell.contactDetailTextField.placeholder = ""
        }
    }
    
}
