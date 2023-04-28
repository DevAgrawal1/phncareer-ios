//
//  taskModel.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 07/04/23.
//

import Foundation
struct TaskModel : Codable{
    let success : Bool
    let status_code : String
    let message : String
    let apps : [Apps]
}

struct Apps : Codable{
    let title : String?
    let type : String?
    let data : [Datum]
}

struct Datum : Codable{
    let id : String?
    let app_icon : String?
    let title : String?
    let image : String?
    let app_link : String?
    let video_img : String?
    let video_link : String?
    let updated : String?
}
