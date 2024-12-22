//
//  ContactTableViewCell.swift
//  proyecto-damii
//
//  Created by Elsa on 13/12/24.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nombreLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func setData(contacto: ContactsEntity){
        nombreLabel.text = contacto.nombre
       
        if let img = contacto.imagen {
            let size = CGSize(width: 36, height: 36)
            avatarImageView.load(urlString: img, size: size,cornerRadius: 18)
        } else{
            avatarImageView.image = nil
        }
    }
}
