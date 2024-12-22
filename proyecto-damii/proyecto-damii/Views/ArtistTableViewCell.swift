//
//  ArtistTableViewCell.swift
//  proyecto-damii
//
//  Created by Analia Fiestas Calle on 12/12/24.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
