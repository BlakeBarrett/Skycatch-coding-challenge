//
//  SFGovAPI.swift
//  Skycatch-Challenge
//
//  Created by Blake Barrett on 4/5/18.
//  Copyright © 2018 Blake Barrett. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]
typealias SFGovAPIResponse = (rows: [Row], locations: [String])
typealias SuccessCallback = (SFGovAPIResponse) -> Void
typealias FailureCallback = ((Any?) -> Void)?

class SFGovAPI {
    
    private static let apiUrlString = "https://data.sfgov.org/api/views/yitu-d5am/rows.json?accessType=DOWNLOAD"
    
    private static func apiUrl() -> URL? {
        return URL(string: SFGovAPI.apiUrlString)
    }
    
    static func fetch(_ success: @escaping SuccessCallback, _ failure: FailureCallback = nil) {
        guard let url = SFGovAPI.apiUrl() else {
            failure?(nil)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data,
                   let jsonData = try? JSONSerialization.jsonObject(with: data) as? JSON,
                   let json = jsonData {
                    
                    parseColumns(from: json)
                    let rows = parseRows(from: json, with: Column.allColumns)
                    let locations = Array(Set( rows.map({ $0.location }) ))
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        success((rows, locations))
                    })
                } else {
                    DispatchQueue.main.async(execute: { () -> Void in
                        failure?(error)
                    })
                }
        }
        dataTask.resume()
    }
    
    static func parseColumns(from value: JSON) {
        
        guard let meta = value["meta"] as? JSON,
              let view = meta["view"] as? JSON,
              let columns = view["columns"] as? [JSON] else { return }
        
        Column.allColumns.removeAll()
        var index = 0
        columns.forEach({ col in
            let current = Column(col)
            current.position = index
            Column.allColumns.append(current)

            index += 1
        })
    }
    
    static func parseRows(from value: JSON, with columns: [Column]) -> [Row] {
        
        guard let rows = value["data"] as? [[Any]] else { return [Row]() }
        return rows.map({ Row($0) })
    }
}
