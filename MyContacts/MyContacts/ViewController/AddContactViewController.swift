//
//  AddContactViewController.swift
//  MyContacts
//
//  Created by Sujananth on 10/28/18.
//  Copyright © 2018 sujananth. All rights reserved.
//

import UIKit

typealias contactDetails = (firstName: String, lastName: String, emailId: String, mobile: Int64, countryCode: String)
//App is crashing crashes when I run using creating instance of autocreated model class. This issue is specific to xcode 10. https://stackoverflow.com/questions/50718018/xcode-10-error-multiple-commands-produce So created a tuple to send data between view controllers.

protocol AddContactViewDelegate: class {
    func addContact(_ contactDetails: contactDetails)
}

class AddContactViewController: UIViewController {

    
    weak var delegate: AddContactViewDelegate?
    
    @IBOutlet weak var contactProfileImage: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var addContactButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        self.countryCodeTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.contactProfileImage.image = UIImage(named: "ContactProfilePlaceHolder")
        self.navigationController?.title = "Add Contact"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "kCountryListSegue") {
            if let countryListViewController = segue.destination as? CountryListViewController {
                countryListViewController.delegate = self
            }
        }
    }
    
    @IBAction func onTappingAddContactButton(_ sender: Any) {
        
        guard let firstName = self.firstNameTextField.text, let lastName = self.lastNameTextField.text, let email = self.emailTextField.text, let mobileNumber = Int64(self.mobileNumberTextField.text!), let countryCode = self.countryCodeTextField.text else {
             self.displayAlertWith(message: "Invalid input")
            return
        }
        
        if(!isValidEmail(emailID: email)) {
            self.displayAlertWith(message: "Please enter a valid email ID")
            return
        }
        
        let contact = (firstName: firstName, lastName: lastName, emailId: email, mobile: mobileNumber, countryCode: countryCode)
        self.delegate?.addContact(contact)
        self.navigationController?.popViewController(animated: true)
    }
    
    func isValidEmail(emailID:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,100}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    func displayAlertWith( message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
}

extension AddContactViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == self.countryCodeTextField) {
            self.performSegue(withIdentifier: "kCountryListSegue", sender: self)
            return false
        }
        return true
    }
}

extension AddContactViewController: CountryListDelegate {
    
    func didSelect(_ country: Country) {
        self.countryCodeTextField.text =  country.alpha2Code
    }
}
