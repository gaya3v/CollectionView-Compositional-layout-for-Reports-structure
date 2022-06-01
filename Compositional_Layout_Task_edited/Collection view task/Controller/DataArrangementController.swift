//
//  LayoutArrangementController.swift
//  Collection view task
//
//  Created by Gayathri V on 20/05/22.
//

import Foundation

class DataArrangementController {
    let jsonDataConverter = JSONParser()
    private var sectionList: [Section] = []
    private lazy var tableData = jsonDataConverter.getParsedData()
    
    init() {
        setupSectionData()
        updateCountValues()
        updateChildCountValues()
    }
    
    //MARK: JSON 'SectionData' class -> custom 'Section' class conversion
    
    func convertSection(section: SectionData) -> Section {
        if section.sub_sections.isEmpty && !(section.rows.isEmpty) {
            return Section(label: section.label, rows: section.rows)
        }
        
        let nextSection = section.sub_sections
        var sectionArr: [Section] = []
        for subSection in nextSection {
            let newSection = convertSection(section: subSection)
            sectionArr.append(newSection)
        }
        let section = Section(label: section.label, sub_sections: sectionArr, rows: section.rows)
        return section
    }
    
    //update values to sectionData
    
    func setupSectionData() {
        if let tableData = tableData {
            for sectionItem in tableData.sections {
                sectionList.append(convertSection(section: sectionItem))
            }
        }
    }
    
    //MARK: count calculation

    func calculateCountValue(section: Section) -> Int {
        if section.sub_sections.isEmpty && !(section.rows.isEmpty) {
            section.count = 1
            return 1
        }
        
        let nextSection = section.sub_sections
        var countValue = 0
        
        for subSection in nextSection {
            countValue = countValue + calculateCountValue(section: subSection)
        }
        section.count = countValue
        return countValue
    }
    
    func updateCountValues() {
        for sectionItem in sectionList {
            sectionItem.count = calculateCountValue(section: sectionItem)
        }
    }
    
    //MARK: child count - update
    
    func updateChildCountValues() {
        for sectionItem in sectionList {
            sectionItem.childCount = getChildCount(section: sectionItem)
        }
    }
    
    func getChildCount(section: Section) -> Int {
        if section.sub_sections.isEmpty && !(section.rows.isEmpty) {
            let value = section.rows.count + 1
            section.childCount = value
            return value
        }
        
        let nextSection = section.sub_sections
        var countValue = 1
        
        for subSection in nextSection {
            countValue = countValue + getChildCount(section: subSection)
        }
        section.childCount = countValue
        return countValue
    }
    
    //MARK: data population method
    
    func getDataForSection(section: Section, dataArray: inout [String]) {
        if section.sub_sections.isEmpty {
            dataArray.append(section.label)
            for rowData in section.rows {
                dataArray.append(rowData.label ?? "")
            }
            return
        }
        dataArray.append(section.label)
        for section in section.sub_sections {
            getDataForSection(section: section, dataArray: &dataArray)
        }
    }
    
    func setDataValues(sectionToBePopulated: Section, dataArray: inout [String]) {
        for section in sectionList {
            if sectionToBePopulated.label == section.label {
            getDataForSection(section: section, dataArray: &dataArray)
                break
            }
        }
    }
   
    //getters
    func getHeaders() -> [Header] {
        if let tableData = tableData {
            return tableData.headers
        }
        return []
    }
    
    func getSections() -> [Section] {
        return sectionList
    }
    
}
