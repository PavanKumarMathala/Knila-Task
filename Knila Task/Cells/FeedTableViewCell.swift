//
//  FeedTableViewCell.swift
//  Knila Task
//
//  Created by Pavan Kumar Mathala on 06/03/21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.displayImage.layer.cornerRadius = self.displayImage.frame.size.width/2
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
