//
//  File.swift
//  timetable
//
//  Created by Juheb on 05/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//



public class LinkedList<T> { //Node class for a linked list. Generic datatype "T"
    var data: T
    var next: LinkedList?
    public init(data: T){
        self.data = data
    }
}

