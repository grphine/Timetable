//
//  RealmSetupFile.swift
//  timetable
//
//  Created by Juheb on 12/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import Foundation
import RealmSwift

class NoteData: Object {
    
    @objc dynamic var id = ""
    
    @objc dynamic var title = ""
    @objc dynamic var age = Date()
    @objc dynamic var body = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Results {
    func toArray() -> [Any] {
        return self.map{$0}
    }
}

extension RealmSwift.List {
    func toArray() -> [Any] {
        return self.map{$0}
    }
}
