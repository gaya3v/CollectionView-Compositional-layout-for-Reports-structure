//
//  Section.swift
//  Collection view task
//
//  Created by Gayathri V on 22/05/22.
//

import Foundation
import UIKit

//MARK: JSON Parsing classes

class TableData : Codable
{
    var headers : [Header] = []
    var sections : [SectionData] = []
}

class Header : Codable
{
    var label : String = ""
}

class SectionData : Codable
{
    var label : String = ""
    var sub_sections : [SectionData] = []
    var rows : [Row] = []
}

class Row : Codable
{
    var label : String?
}

//MARK: custom data classes

class Section {
    var count: Int = 0
    var childCount: Int = 0
    var label : String = ""
    var sub_sections : [Section] = []
    var rows : [Row] = []
    
    init(label : String, sub_sections : [Section] = [], rows : [Row], count: Int = 0, childCount: Int = 0) {
        self.label = label
        self.sub_sections = sub_sections
        self.rows = rows
        self.count = count
        self.childCount = childCount
    }
}
