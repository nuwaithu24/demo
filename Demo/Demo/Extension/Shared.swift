//
//  Share.swift
//  UninetWallet
//
//  Created by COMQUAS on 1/21/20.
//  Copyright © 2020 COMQUAS. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func save<T:Encodable>(customObject object: T, inKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
        }
    }
    
    func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            }else {
                print("Couldnt decode object")
                return nil
            }
        }else {
            print("Couldnt find key")
            return nil
        }
    }
    
}

enum SharedType :String{
    case offlineData = "offlineData"
}


class Shared {
    
    static let instance = Shared()
    
    func saveData(data : WonderModel){
        UserDefaults.standard.save(customObject: data, inKey: SharedType.offlineData.rawValue)
    }
    
    func getData() -> WonderModel?{
           guard  let obj = UserDefaults.standard.retrieve(object: WonderModel.self, fromKey: SharedType.offlineData.rawValue) else {return nil}
           UserDefaults.standard.synchronize()
           return obj
       }
    
    
   

}



