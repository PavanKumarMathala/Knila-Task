//
//  DetailViewController.swift
//  Knila Task
//
//  Created by Pavan Kumar Mathala on 06/03/21.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    var img: String?
    var name: String?
    var emailId: String?
    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()

        // Do any additional setup after loading the view.
    }
    //MARK:- Setting UP Data into UI
    func configUI() {
        self.nameLabel.text = "User Name - \(String(self.name ?? ""))"
        self.emailLabel.text = "User EmailID - \(String(self.emailId ?? ""))"
        self.userIdLabel.text = "User ID - \(String(self.userId ?? ""))" 
        self.displayImage.layer.cornerRadius = self.displayImage.frame.size.height/2
        if let imageToDisplay = URL(string: self.img?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            self.displayImage.kf.setImage(with: imageToDisplay)
        }
    }
    


}
