//
//  AddContactViewController.swift
//  MyContacts
//
//  Created by Sujananth on 10/28/18.
//  Copyright © 2018 sujananth. All rights reserved.
//

import UIKit

enum PageType {
    case edit
    case add
}

enum ContactDetails: Int, CaseIterable {
    case firstName
    case lastName
    case email
    case mobile
    case countryCode
}

protocol AddOrEditContactsViewDelegate: class {
    func saveContact(_ contact: Contact)
    func addContact(_ contact: Contact)
}

class AddContactViewController: UIViewController {

    weak var delegate: AddOrEditContactsViewDelegate?
    var pageType: PageType?
    
    @IBOutlet weak var contactProfileImage: UIImageView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var addOrSaveContactButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactProfileImage.image = UIImage(named: "ContactProfilePlaceHolder")
    }
    
    @IBAction func onTappingAddOrSaveContactButton(_ sender: Any) {
        let contact = Contact()
        contact.firstName = self.firstNameTextField.text
        contact.lastName = self.lastNameTextField.text
        contact.emailID = self.emailTextField.text
        if let mobileNumber = Int64(self.mobileNumberTextField.text!) {
            contact.mobileNumber = mobileNumber
        }
        contact.countryCode = self.countryCodeTextField.text
        
        if(pageType == .edit) {
            self.delegate?.saveContact(contact)
        } else if(pageType == .add) {
            self.delegate?.addContact(contact)
        } else {
            //Throw error to user as unable to save contact and log the error message with unkown page type.
        }
        self.navigationController?.popViewController(animated: true)

    }
}
