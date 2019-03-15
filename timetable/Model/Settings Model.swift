//
//  Settings Model.swift
//  timetable
//
//  Created by Juheb on 14/03/2019.
//  Copyright © 2019 Juheb. All rights reserved.
//

import Foundation
import RealmSwift

class SettingsStore: Object{
    @objc dynamic var id = "1"
    @objc dynamic var twentyFour = false
    @objc dynamic var lowerBound = 6
    @objc dynamic var upperBound = 17
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
