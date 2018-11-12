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
    
    @objc dynamic var title = ""
    @objc dynamic var datetime = NSDate()
    @objc dynamic var body = ""
}
