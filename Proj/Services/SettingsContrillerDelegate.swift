//
//  SettingsContrillerDelegate.swift
//  Proj
//
//  Created by Admin on 6/19/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

protocol SettingsControllerDelegate{
    func languageDidSelect(token: String, lang: String)
    var language: String? { get set }

}
