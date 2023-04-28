//
//  stringToURL.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 08/04/23.
//

import Foundation

func stringToUrl(str:String)->URL?{
    let urlString = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let url = URL(string: urlString!)
    return url
}
