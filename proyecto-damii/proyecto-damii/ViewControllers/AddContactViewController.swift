//
//  AddContactViewController.swift
//  proyecto-damii
//
//  Created by Elsa on 13/12/24.
//

import UIKit
import CoreData

class AddContactViewController: UIViewController  {
 
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nombreTextField: UITextField!
    
    @IBOutlet weak var apellidoTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var telefonoTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    let datePicker = UIDatePicker()
    
    var contact: ContactsEntity?
    var contactRepository: ContactRepository!
    var avatarRepository: AvatarRepository!
    var avatarUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactRepository = ContactRepository()
        avatarRepository = AvatarRepository()
        createDatePicker()
        
        if let contact = contact {
            setData(contact: contact)
        }
        
        deleteButton.isHidden = contact == nil
    }
    
    @IBAction func saveContact(_ sender: Any) {
        let nombre = nombreTextField.text
        let apellido = apellidoTextField.text
        let email = emailTextField.text
        let telefono = telefonoTextField.text
        
        var fecha: Date?
        if dateTextField.text?.isEmpty == false {
            fecha = datePicker.date
        }
        
        if contact == nil {
            contactRepository.guardarContacto(nombre: nombre, apellido: apellido, email: email, telefono: telefono, fecha: fecha, imagen: avatarUrl)
        } else {
            contactRepository.updateContact(contacto: contact!, nombre: nombre, apellido: apellido, email: email, telefono: telefono, fecha: fecha, imagen: avatarUrl)
        }
        volverInicio()
    }
    
    
    @IBAction func cargarImagen(_ sender: Any) {
        if emailTextField.text?.isEmpty == false {
            avatarRepository.getAvatar(email: emailTextField.text!) { result in
                switch result {
                case .success(let avatar):
                    self.avatarUrl = avatar.image
                    self.loadAvatar(urlString: avatar.image)
                case .failure(let error):
                    print(error)
                }
            }
            
        } else {
            print("Debe ingresar el correo")
        }
    }
    
    private func setData(contact: ContactsEntity) {
        nombreTextField.text = contact.nombre
        apellidoTextField.text = contact.apellido
        emailTextField.text = contact.email
        telefonoTextField.text = contact.telefono
        if let fecha = contact.fechaN {
            dateTextField.text = format(fecha: fecha)
        }
        if let imagen = contact.imagen {
            avatarUrl = imagen
            loadAvatar(urlString: imagen)
        }
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc func donePressed() {
        dateTextField.text = format(fecha: datePicker.date)
        self.view.endEditing(true)
    }
    
    func format(fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let f = formatter.string(from: fecha)
        return f
    }
    
    func loadAvatar(urlString: String) {
        let size = CGSize(width: 150, height: 150)
        avatarImageView.load(urlString: urlString, size: size, cornerRadius: 75)
    }
    
    @IBAction func deleteContact(_ sender: Any) {
        let alert = UIAlertController(title: "Eliminar Contacto", message: "Estas seguro de eliminar este contacto?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Eliminar", style: .destructive) { (action) in
            if let  contacto = self.contact {
                self.contactRepository.deleteContact(contacto: contacto)
                self.volverInicio()
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    func volverInicio() {
        self.navigationController?.popViewController(animated: true)
    }
}
