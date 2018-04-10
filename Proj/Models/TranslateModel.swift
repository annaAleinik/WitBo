//
//  TranslateModel.swift
//  Proj
//
//  Created by Admin on 4/2/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct translationsArrayModel : Codable{
    
    let translatedText : String
    let detectedSourceLanguage : String
    let model : String
}

struct DataModel : Codable {
    
    let translations : Array<translationsArrayModel>
}
