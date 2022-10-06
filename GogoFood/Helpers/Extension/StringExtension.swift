//
//  StringExtension.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 11/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    
    private func localized(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: self, comment: "Do not get value")
    }
    
    func doTrimming() -> String{
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func length() -> Int {
        return self.count
    }
    
    
}
extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}
