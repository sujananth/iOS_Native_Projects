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
    
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
     }
}

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactCell = tableView.dequeueReusableCell(withIdentifier: "kContactCellID", for: indexPath)
        return contactCell
    }
}

extension ContactsViewController: UITableViewDelegate {
    
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
        
        //IndexPath will be nill on addition or insertion in ManagedObjectContext: https://developer.apple.com/documentation/coredata/nsfetchedresultscontrollerdelegate/1622296-controller
        //So while insertion we get indexPath for the object in fetchedResultsController
        if let modifiedIndexPath = indexPath ?? self.fetchedResultsController.indexPath(forObject: anObject as! Contact)  {
            
//            self.modifyListViewForChangeOf(type: type, in: [modifiedIndexPath])
        } else {
            
            print("Error: index path for modified data is nill")
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.contactsListTableView.endUpdates()
    }
    
}

extension ContactsViewController {
    
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
    
    func updateManagedObjectContextOf(date: String) {
        
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dateInfo = '\(date)'")
        do {
            
            guard let _context = self.managedObjectContext else { return }
            let test = try _context.fetch(fetchRequest)
            if test.count == 1 {
                
                let objectUpdate = test[0] as NSManagedObject
//                objectUpdate.setValue(self.getDateTimeWithNanoSecond(), forKey: "dateInfo")
//                objectUpdate.setValue("Tap a Cell to update Date Time", forKey: "additionalInfo")
            }
        } catch {
            
            print(error)
        }
    }
    
    func addToManagedObjectContext() {
        
        guard let _context = self.managedObjectContext else { return }
        let object = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: _context) as! Contact
//        object.dateInfo = self.getDateTimeWithNanoSecond()
//        object.additionalInfo = "Slide Left to delete Cells"
    }
}
