//
//  WorkTableViewCell.swift
//  proyecto-damii
//
//  Created by Analia Fiestas Calle on 12/12/24.
//

import UIKit

class WorkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workImageView: UIImageView!
    @IBOutlet weak var workTitleLabel: UILabel!
    @IBOutlet weak var moreInfoTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
