//
//  Sorts.swift
//  timetable
//
//  Created by Juheb on 19/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import Foundation

class Sorts {
    
    //MARK: Quick Sort a string
    func quickSort(_ arr: [String]) -> [String]{
        
        var less = [String]()
        var equal = [String]()
        var more = [String]()
        
        if arr.count > 1{
            let pivot = arr[arr.count/2]
            
            for value in arr{
                if value > pivot{
                    more.append(value)
                }
                else if value < pivot{
                    less.append(value)
                }
                if value == pivot{
                    equal.append(value)
                }
            }
            return quickSort(less) + equal + quickSort(more)
            
        }
        else{
            return arr
        }
    }

    
    
    //MARK: Merge Sort a date
    func mergeSort(_ arr: [Date]) -> [Date]{
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
    
    func merge(_ a: [Date],_ b: [Date]) -> [Date]{
        
        var array = [Date]()
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
