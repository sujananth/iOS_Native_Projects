//
//  Country.swift
//  MyContacts
//
//  Created by Sujananth on 10/30/18.
//  Copyright © 2018 sujananth. All rights reserved.
//

import UIKit

class Country: NSObject {
    
    let name: String
    let alpha2Code: String

    init(countryName: String, countryCode: String) {
        
        self.name = countryName
        self.alpha2Code = countryCode
    }
}
