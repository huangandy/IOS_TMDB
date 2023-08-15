//
//  RealmHelper.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/14.
//

import RealmSwift

class RealmHelper {
    static let shared = RealmHelper()
    let realm = try! Realm()
    
    func getAllObjects<T: Object>(type: T.Type) -> Results<T> {
        let results: Results<T> = realm.objects(type)
        return results
    }
    
    func getObjectsCount<T: Object>(type: T.Type) -> Int {
        return realm.objects(type).count
    }
    
    func getObject<T: Object>(type: T.Type, forKey key: Any) -> T? {
        let object: T? = realm.object(ofType: type, forPrimaryKey: key)
        return object
    }
    
    func addOrUpdateObject<T: Object>(_ object: T) {
        try! realm.write {
            realm.add(object, update: .all)
        }
    }
    
    func deleteObject<T: Object>(_ object: T?) {
        if let target = object {
            try! realm.write {
                realm.delete(target)
            }
        }
    }
    
    func deleteObject<T: Object>(type: T.Type, forKey key: Any) {
        let object: T? = realm.object(ofType: type, forPrimaryKey: key)
        if let obj = object {
            try! realm.write {
                realm.delete(obj)
            }
        }
    }
    
    func deleteAll<T: Object>(type: T.Type) {
        try! realm.write {
            let object: Results<T> = realm.objects(type)
            realm.delete(object)
        }
    }
}

