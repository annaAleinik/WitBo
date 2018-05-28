//
//  WBRealmManager.swift
//  Proj
//
//  Created by  Anita on 5/13/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import RealmSwift

class WBRealmManager {
    
    private var database = try! Realm()
    private let userModel = BaseUserModel()
    private let contactModel = BaseContactModel()
    
//    static let shared = WBRealmManager()
//
//    private init () {
//        database = try! Realm()
//    }
    
    
    func getObjFromBase() -> BaseUserModel {
        let user = database.objects(BaseUserModel.self)
        return user.first!
    }
    
    func deleteContactById(id: String) {
//        let predicate = NSPredicate(format: "clientId = \(id))")
        let predicate = NSPredicate(format: "clientId = %@", id)
        let contact = database.objects(BaseContactModel.self).filter(predicate)
        try! database.write {
            database.delete(contact.first!)
        }
    }
    
    func addData(object: Object)   {
        try! database.write {
            database.add(object, update: true)
        }
    }
    
    func deleteAllFromDatabase()  {
        try!   database.write {
            database.deleteAll()
        }
    }
    
    func deleteFromDb(object: Object)   {
        try!   database.write {
            database.delete(object)
        }
    }
    
    func updateTime(forToken: String, secet: String, email: String,name: String, lang: String, timeLeft: Int) {
        
        try! database.write {
            userModel.name = name
            userModel.token = forToken
            userModel.timeLeft = timeLeft
            userModel.email = email
            userModel.secret = secet
            userModel.lang = lang

            database.add(userModel, update: true)
        }
    }
    
    func getAllContactsFromDB() -> Array<BaseContactModel>{
       let arrContfromDB = database.objects(BaseContactModel.self)
    return Array(arrContfromDB)
    }
    
}

