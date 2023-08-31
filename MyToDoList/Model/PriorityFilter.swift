//
//  PriorityFilter.swift
//  MyToDoList
//
//  Created by Pierson McCall on 8/29/23.
//

import SwiftUI

enum PriorityFilter: String
{
    static var allFilters: [PriorityFilter]
    {
        return [.High, .Medium, .Low]
    }
    
    case High = "High"
    case Medium = "Medium"
    case Low = "Low"
}
