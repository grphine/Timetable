//
//  Linked List Queue.swift
//  timetable
//
//  Created by Juheb on 05/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

//MARK: LL Queue Class
public class Queue<T> {
    
    typealias Node = LinkedListNode<T>
    
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
        
        if var node = self.head { //begins count if queue not empty
            while case let next? = node.next { //+1 every time a node has a next node
                node = next
                count += 1 //counts nodes until end
            }
            count += 1 //counts remaining node
        }
        return count
    }
    
    //MARK: Return items
    func outputArray() -> [T]{
        var array = [T]()
        
        if var node = self.head {
            
            array.append(node.data)
            while case let next? = node.next {
                node = next
                array.append(node.data)
            }
            
        }
        return array
    }
}



//MARK: Node Class
public class LinkedListNode<T> { //Node class for a linked list. Generic datatype "T"
    var data: T
    var next: LinkedListNode?
    public init(data: T){
        self.data = data
    }
}
