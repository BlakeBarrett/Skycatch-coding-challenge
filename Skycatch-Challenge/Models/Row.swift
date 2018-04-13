//
//  Row.swift
//  Skycatch-Challenge
//
//  Created by Blake Barrett on 4/11/18.
//  Copyright © 2018 Blake Barrett. All rights reserved.
//

import Foundation

class Row {
    
    let value: [Any]
    
    init(_ value: [Any]) {
        self.value = value
    }
    
    var title: String {
        return valueFor(Column.title)
    }
    
    var releaseYear: String {
        return valueFor(Column.releaseYear)
    }
    
    var location: String {
        return valueFor(Column.location)
    }
    
    func wasShot(on location: String) -> Bool {
        return self.location == location
    }
    
    func valueFor(_ column: Column?) -> String {
        guard let column = column else { return "" }
        return String(describing: value[column.position])
    }
    
    func toString() -> String {
        var returnString = ""
        
        Column.allColumns.forEach({ column in
            if !column.hidden {
                let value = valueFor(column)
                if value != "<null>" {
                    returnString += "\(column.name):\t \(value)\r"
                }
            }
        })
        return returnString
    }
}
