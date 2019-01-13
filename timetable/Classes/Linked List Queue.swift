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
    //MARK: Dequeue All
    func dequeueAll(){
//        while self.length() > 0{
//            self.dequeue()
//        }
        // the above has like O(n^2) time complexity
    /* notes:
         setting head as nil loses (rather than deletes) queue. memory leaks
         unable to delete data
         
         setting head as nil loses the queue, so it is assumed empty. this however leaves nodes in memory. since data cannot be deleted (being non-optional), i cannot remove the data from memory. the nodes also remain regardless
    */
        
//        if var node = self.head{
//            while case let next? = node.next{
//                node = next
//            }
//        }
        
        head = nil
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
