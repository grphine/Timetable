//
//  Note Model.swift
//  timetable
//
//  Created by Juheb on 14/03/2019.
//  Copyright © 2019 Juheb. All rights reserved.
//

import Foundation
import RealmSwift

class NoteData: Object {
    
    @objc dynamic var id = ""
    
    @objc dynamic var title = ""
    @objc dynamic var age = ""
    @objc dynamic var body = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

