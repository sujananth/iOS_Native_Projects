//
//  ContactsViewController.swift
//  MyContacts
//
//  Created by Sujananth on 10/27/18.
//  Copyright © 2018 sujananth. All rights reserved.
//

import UIKit
import CoreData


class ContactsViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var _fetchedResultsController: NSFetchedResultsController<Contact>? = nil
    var fetchedResultsController: NSFetchedResultsController<Contact> {
        
        if(_fetchedResultsController != nil) {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        self._fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        self._fetchedResultsController?.delegate = self
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved Error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    @IBOutlet weak var contactsSearchBar: UISearchBar!
    @IBOutlet weak var contactsListTableView: UITableView!
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "kAddContactSegue") {
            if let addContactViewController = segue.destination as? AddContactViewController {
                addContactViewController.delegate = self
            }
        }
     }
    
    func modifyListViewForChangeOf(type: NSFetchedResultsChangeType, in indexPathSet:[IndexPath]) {
        
        switch type {
            
        case .delete:
            self.contactsListTableView.deleteRows(at: indexPathSet, with: UITableView.RowAnimation.fade)
            
        case .insert:
            self.contactsListTableView.insertRows(at: indexPathSet, with: UITableView.RowAnimation.fade)
            
        case .move:
            //While move we need to reload tableView.
            //We must animate between beginUpdate and endUpdate while reloading: https://developer.apple.com/documentation/uikit/uitableview/1614908-beginupdates
            UIView.transition(with: self.contactsListTableView, duration: 1.0, options: .curveLinear, animations: {self.contactsListTableView.reloadData()}, completion: nil)
            
        case .update:
            self.contactsListTableView.reloadRows(at: indexPathSet, with: UITableView.RowAnimation.fade)
        }
    }
}

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactCell = tableView.dequeueReusableCell(withIdentifier: "kContactCellID", for: indexPath)
        let dateDescriptionEntity = self.fetchedResultsController.object(at: indexPath)
        if let contact = contactCell as? ContactTableViewCell, let firstName =  dateDescriptionEntity.firstName, let lastName = dateDescriptionEntity.lastName{
            contact.contactName.text = firstName + " " + lastName
        }
        return contactCell
    }
}

extension ContactsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.contactsListTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        if let modifiedIndexPath = indexPath ?? self.fetchedResultsController.indexPath(forObject: anObject as! Contact)  {

            self.modifyListViewForChangeOf(type: type, in: [modifiedIndexPath])
        } else {
            
            print("Error: index path for modified data is nill")
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.contactsListTableView.endUpdates()
    }
}


extension ContactsViewController: AddContactViewDelegate {
    
    func addContact(_ contactDetails: contactDetails) {
        guard let _context = self.managedObjectContext else { return }
        let object = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: _context) as! Contact
        object.firstName = contactDetails.firstName
        object.lastName = contactDetails.lastName
        object.emailID = contactDetails.emailId
        object.mobileNumber = contactDetails.mobile
        object.countryCode = contactDetails.countryCode
    }
}
    
