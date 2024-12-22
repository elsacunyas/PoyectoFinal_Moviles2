//
//  ContactsViewController.swift
//  proyecto-damii
//
//  Created by Elsa on 13/12/24.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
 
   
    @IBOutlet weak var contactoTableView: UITableView!
    
    var contactRepository: ContactRepository!
    var contactList: [ContactsEntity] = []
    var selectedContact: ContactsEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactRepository =  ContactRepository()
        
        contactoTableView.rowHeight = 48
        contactoTableView.dataSource = self
        contactoTableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        listarContactos()
    }
    
    func listarContactos(){
        contactList = contactRepository.listarContactos()
        contactoTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactTableViewCell
        let contacto = contactList[indexPath.row]
        cell.setData(contacto: contacto)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContact = contactList[indexPath.row]
        performSegue(withIdentifier: "idSegueAddContact", sender: self)
        selectedContact = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let identifier = segue.identifier {
        if identifier == "idSegueAddContact" {
            let addContactViewController = segue.destination as! AddContactViewController
            if let selectedContact = selectedContact {
                addContactViewController.contact = selectedContact
            }
        }
      }
    }
}
