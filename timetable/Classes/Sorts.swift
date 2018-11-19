//
//  Sorts.swift
//  timetable
//
//  Created by Juheb on 19/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import Foundation

class Sorts {
    
    //MARK: Quick Sort
    func partition<T: Comparable>(array: inout [T], startIndex: Int, endIndex: Int) -> Int {
        var q = startIndex
        for index in startIndex..<endIndex {
            if array[index] < array[endIndex] {
                array.swapAt(q, index)
                q += 1
            }
        }
        array.swapAt(q, endIndex)
        
        return q
    }
    
    func quickSort<T: Comparable>(array: inout [T], startIndex: Int, endIndex: Int) {
        // Base case
        if startIndex >= endIndex {
            return
        }
        let placedItemIndex = partition(array: &array, startIndex: startIndex, endIndex: endIndex)
        quickSort(array: &array, startIndex: startIndex, endIndex: placedItemIndex-1)
        quickSort(array: &array, startIndex: placedItemIndex+1, endIndex: endIndex)
    }
    
    func quickSort<T: Comparable>(array: inout [T]) {
        quickSort(array: &array, startIndex: 0, endIndex: array.count-1)
    }
    
    
    //MARK: Merge Sort
    func mergeSort(_ arr: [Int]) -> [Int]{
        var array = arr
        
        if array.count == 1{
            return array
        }
        else{
            let split = array.count/2
            let leftSide = mergeSort(Array(array[0..<split]))
            let rightSide = mergeSort(Array(array[split..<array.count]))
            
            return merge(leftSide, rightSide)
        }
        
    }
    
    func merge(_ a: [Int],_ b: [Int]) -> [Int]{
        
        var array = [Int]()
        var indexa = 0
        var indexb = 0
        
        while indexa < a.count && indexb < b.count{
            if a[indexa] < b[indexb]{
                array.append(a[indexa])
                indexa += 1
            }
            else if a[indexa] > b[indexb]{
                array.append(b[indexb])
                indexb += 1
            }
            else {
                array.append(a[indexa])
                indexa += 1
                array.append(b[indexb])
                indexb += 1
            }
        }
        
        while indexa < a.count{
            array.append(a[indexa])
            indexa += 1
        }
        while indexb < b.count{
            array.append(b[indexb])
            indexb += 1
        }
        
        return array
    }
    
    
}
