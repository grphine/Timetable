//
//  Linked List Queue.swift
//  timetable
//
//  Created by Juheb on 05/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

//MARK: LL Queue Class
public class Queue<T> {
    
    typealias Node = LinkedList<T>
    
    var head: Node!
    public var isEmpty: Bool { return head == nil }
    var first: Node? { return head }
    var last: Node? {
        
        if var node = self.head { //finds first node in list
            while case let next? = node.next {
                node = next
            }
            return node
        } else {
            return nil
        }
    }
    
    
    //MARK: Enqueue
    func enqueue(key: T) {
        let nextItem = Node(data: key) //item to be added as node
        if let lastNode = last {
            lastNode.next = nextItem //last node moved to added item
        } else {
            head = nextItem //unless item is added to empty queue
        }
    }
    
    //MARK: Dequeue
    func dequeue() -> T? {
        if self.head?.data == nil { return nil } //cannot dequeue if queue empty
        let out = head?.data
        if let nextItem = self.head?.next {
            head = nextItem //next node set as head
        } else {
            head = nil
        }
        return out
    }
    
    //MARK: Length
    func length() -> Int{
        var count = 0
        
        if var node = self.head {
            while case let next? = node.next {
                node = next
                count += 1
            }
        }
        return count
    }
}



//MARK: Node Class
public class LinkedList<T> { //Node class for a linked list. Generic datatype "T"
    var data: T
    var next: LinkedList?
    public init(data: T){
        self.data = data
    }
}
