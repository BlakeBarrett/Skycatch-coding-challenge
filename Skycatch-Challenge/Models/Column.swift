//
//  Column.swift
//  Skycatch-Challenge
//
//  Created by Blake Barrett on 4/11/18.
//  Copyright © 2018 Blake Barrett. All rights reserved.
//

import Foundation

public class Column {
    
    public static var allColumns = [Column]()
    
    public static var title: Column?
    public static var releaseYear: Column?
    public static var location: Column?
    
    var name = ""
    var position = 0
    var hidden = false
    
    init(_ value: JSON) {
        
        if let name = value["name"] as? String {
            self.name = name
        }
        
        if let flags = value["flags"] as? [String] {
            self.hidden = flags.first == "hidden"
        }
        
        switch self.name {
        case "Locations":
            Column.location = self
        case "Release Year":
            Column.releaseYear = self
        case "Title":
            Column.title = self
        default: break
        }
    }
}
