//
//  ContactTableViewCell.swift
//  MyContacts
//
//  Created by Sujananth on 10/28/18.
//  Copyright © 2018 sujananth. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactProfileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contactProfileImageView.image = UIImage(named: "ContactProfilePlaceHolder")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
