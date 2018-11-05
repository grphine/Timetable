//
//  Linked List Queue.swift
//  timetable
//
//  Created by Juheb on 05/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//


public class Queue<T> {
    
    typealias Node = LinkedList<T>
    
    var head: Node!
    public var isEmpty: Bool { return head == nil }
    var first: Node? { return head }
    var last: Node? {
        
        if var node = self.head {
            while case let next? = node.next {
                node = next
            }
            return node
        } else {
            return nil
        }
    }
    
    
    
    func enqueue(key: T) {
        let nextItem = Node(data: key)
        if let lastNode = last {
            lastNode.next = nextItem
        } else {
            head = nextItem
        }
    }
    func dequeue() -> T? {
        if self.head?.data == nil { return nil  }
        let out = head?.data
        if let nextItem = self.head?.next {
            head = nextItem
        } else {
            head = nil
        }
        return out
    }
}

