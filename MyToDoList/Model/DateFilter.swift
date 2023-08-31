//
//  DateFilter.swift
//  MyToDoList
//
//  Created by Pierson McCall on 8/28/23.
//

import SwiftUI

enum DateFilter: String
{
    static var allFilters: [DateFilter]
    {
        return [.SpecifiedDate, .SpecifiedWeek]
    }
    
    case SpecifiedDate = "Date"
    case SpecifiedWeek = "Period of Time"
}
