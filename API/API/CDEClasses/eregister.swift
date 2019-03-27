//
//  eregister.swift
//  API
//
//  Created by 4lex@ndr0 on 06/03/2019.
//  Copyright © 2019 LenTech. All rights reserved.
//

import Foundation

class Eregister {
    private var eregister: [String: [Any]]?
    
    init(rawJsonData: [String: [Any]]?) {
        self.eregister = rawJsonData
    }
    
    private func getYear(styear: String) -> [String: Any]? {
        let years = self.eregister!["years"]
        for year in years! {
            let year_data = year as? [String: Any]
            let studyyear = year_data!["studyyear"] as? String
            if studyyear! == styear {
                return year_data
            }
        }
        return nil
    }
    
    func getStudyears() -> Array<String> {
        var years_array: Array<String> = []
        
        let years = self.eregister!["years"]
        for year in years! {
            let year_data = year as? [String: Any]
            years_array.append(year_data!["studyyear"] as! String)
        }
        return years_array
    }
    
    func getFirstSemesterByStudyYear(styear: String) -> Int {
        let first_subject = (self.getYear(styear: styear)!["subjects"] as! NSArray)[0] as? [String: Any]
        
        if Int(first_subject!["semester"] as! String)! % 2 != 0 {
            return Int(first_subject!["semester"] as! String)!
        } else {
            return Int(first_subject!["semester"] as! String)! - 1
        }
    }
    
    func getFirstSemesterByStudyYear(styear: String) -> (Int, Int) {
        var sem: (Int, Int) = (1, 1)
        let first_subject = (self.getYear(styear: styear)!["subjects"] as! NSArray)[0] as? [String: Any]
        
        if Int(first_subject!["semester"] as! String)! % 2 != 0 {
            sem = (Int(first_subject!["semester"] as! String)!, Int(first_subject!["semester"] as! String)! + 1)
        } else {
            sem = (Int(first_subject!["semester"] as! String)! - 1, Int(first_subject!["semester"] as! String)!)
        }
        
        return sem
    }
    
    func getSubjects(styear: String, semester: Int?) -> Array<Dictionary<String, String>> {
        var subjects_array: Array<Dictionary<String, String>> = []
        
        let subjects = getYear(styear: styear)!["subjects"] as! NSArray
        for subject in subjects {
            let d = subject as? [String: Any]
            if semester != nil {
                if (d!["semester"] as! String) != String(semester!) {
                    continue
                }
            }
            
            var subject_dict: Dictionary<String, String> = [:]
            let marks = (d!["marks"] as! NSArray).lastObject as! [String: Any]
            let points = d!["points"] as? NSArray
            
            if marks["mark"] != nil {
                if marks["mark"] as! String != "" || marks["mark"] as! String != " " {
                    subject_dict["mark"] = marks["mark"] as! String
                } else { subject_dict["mark"] = "X" }
            } else { subject_dict["mark"] = "X" }
            
            if points != nil {
                if points!.count != 0 {
                    subject_dict["amount"] = (points![0] as! [String: Any])["value"] as? String
                } else { subject_dict["amount"] = "0" }
            } else { subject_dict["amount"] = "0" }
            
            subject_dict["name"] = d!["name"] as? String
            subject_dict["worktype"] = marks["worktype"] as? String
            
            subjects_array.append(subject_dict)
        }
        return subjects_array
    }
    
    func getPoints(styear: String, semester: Int, subject: String) -> Array<Dictionary<String, String>> {
        var points_array: Array<Dictionary<String, String>> = []
        
        let subjects = getYear(styear: styear)!["subjects"] as! NSArray
        for i in subjects {
            let d = i as? [String: Any]
            if (d!["semester"] as! String) != String(semester) { continue }
            
            if (d!["name"] as! String) == subject {
                
                let points = d!["points"] as? NSArray
                if points != nil {
                    if points!.count != 0 {
                        for point in points! {
                            let point_data = point as? [String: String]
                            
                            var point_array_elem: Dictionary<String, String> = [:]
                            point_array_elem["variable"] = point_data!["variable"]
                            point_array_elem["limit"] = point_data!["limit"]
                            point_array_elem["value"] = point_data!["value"]
                            point_array_elem["max"] = point_data!["max"]
                            points_array.append(point_array_elem)
                        }
                    } else { return [] }
                } else { return [] }
            }
        }
        return points_array
    }
    
}
