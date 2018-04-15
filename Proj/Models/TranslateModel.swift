//
//  TranslateModel.swift
//  Proj
//
//  Created by Admin on 4/2/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct TranslationModel : Codable{
    
    let translatedText : String
    let detectedSourceLanguage : String
    let model : String
}

struct TranslationsModel : Codable {
    let translations : Array<TranslationModel>
}

struct DataTranslatorModel: Codable {
	let data : TranslationsModel
}
