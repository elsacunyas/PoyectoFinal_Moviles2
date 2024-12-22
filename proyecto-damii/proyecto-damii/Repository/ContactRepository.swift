//
//  ContactRepository.swift
//  proyecto-damii
//
//  Created by Elsa on 13/12/24.
//
import UIKit
import CoreData

class ContactRepository {
    
    func guardarContacto(nombre: String? , apellido: String?, email: String?, telefono: String?,fecha: Date?, imagen: String?) {
        if let name = nombre, let lastName = apellido, let email = email, let phoneNumber = telefono {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistenContainer.viewContext
            let contacto = ContactsEntity(context: managedContext)
            contacto.nombre = name
            contacto.apellido = lastName
            contacto.email = email
            contacto.telefono = phoneNumber
            contacto.fechaN = fecha
            contacto.imagen = imagen
            do {
                try managedContext.save()
            }catch {
                print("No fue posible guardar contacto \(error), \(error)")
            }
        }
    }
    
    func listarContactos() -> [ContactsEntity] {
        
        var contactos: [ContactsEntity] = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistenContainer.viewContext
        
        do {
            let result = try managedContext.fetch(ContactsEntity.fetchRequest())
            contactos = result 
        }
        catch  let error as NSError{
            print("No fue posible listar contactos \(error), \(error)")
        }
        
        return contactos
    }
    
    func updateContact(contacto: ContactsEntity,nombre: String? , apellido: String?, email: String?, telefono: String?,fecha: Date?, imagen: String?) {
        if let name = nombre, let lastName = apellido, let email = email, let phoneNumber = telefono{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistenContainer.viewContext
            contacto.nombre = name
            contacto.apellido = lastName
            contacto.email = email
            contacto.telefono = phoneNumber
            contacto.fechaN = fecha
            contacto.imagen = imagen
            
            do {
                try managedContext.save()
            }catch {
                print("No fue posible actualizar el  contacto \(error), \(error)")
            }
        }
        }
    
    func deleteContact(contacto: ContactsEntity) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistenContainer.viewContext
        managedContext.delete(contacto)
        do {
            try managedContext.save()
        }catch {
            print("No fue posible actualizar el  contacto \(error), \(error)")
        }
    }
    
}
