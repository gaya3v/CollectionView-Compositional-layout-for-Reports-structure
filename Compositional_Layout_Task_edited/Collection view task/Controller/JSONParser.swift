////
////  JSONParser.swift
////  Collection view task
////
////  Created by Gayathri V on 22/05/22.
////
//
import Foundation

class JSONParser {
    private var tableData : TableData?

    init() {
        parsingDataFromJsonFile()
    }
    //MARK: parsing json -> swift
    
    func parsingDataFromJsonFile()
    {
        let fileName :String = "header"
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do
            {
                let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe) as Data
                let parsedData = try JSONDecoder().decode(TableData.self, from: data)
                tableData = parsedData
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        else {
            print("Invalid Settings File path")
        }
    }
    
    func getParsedData() -> TableData? {
        return tableData
    }
  
}
