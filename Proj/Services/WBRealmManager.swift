//
//  WBRealmManager.swift
//  Proj
//
//  Created by  Anita on 5/13/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import RealmSwift

class WBRealmManager {
    
    private var database: Realm
    private let userModel = BaseUserModel()

    static let shared = WBRealmManager()

    private init () {
        database = try! Realm()
    }
    
//    func getDataFromDB() ->   Results<BaseUserModel> {
//        let results: Results<Route> = database.objects(BaseUserModel.self)
//        return results
//    }
    func addData(object: BaseUserModel)   {
        try! database.write {
            database.add(object, update: true)
            print("Added new object")
        }
    }
    func deleteAllFromDatabase()  {
        try!   database.write {
            database.deleteAll()
        }
    }
    func deleteFromDb(object: BaseUserModel)   {
        try!   database.write {
            database.delete(object)
        }
    }
    
    func updateTime(time: Int) {

//        let userObj = database.object(ofType: BaseUserModel.self, forPrimaryKey: String.self)
        try! database.write {
            userModel.timeLeft = time
            try! database.commitWrite()
        }
    }
    
}
