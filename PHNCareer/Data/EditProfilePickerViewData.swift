//
//  EditProfilePickerViewData.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 05/04/23.
//

import Foundation
struct EditProfileData{
    static var shared = EditProfileData()
    
    func qualification()->[String]{
        return ["12th","Diploma","B.E","M.E","B.Tech","M.Tech","BCA","MCA","BBA","MBA","B.Sc","M.Sc","B.Com","M.Com","B.A","M.A",]
    }
    
    func educationalStatus()->[String]{
        return ["Pursuing","Passout"]
    }
    
    func passoutYear(educationStatus:String)->[String]{
        var years = [String]()
        if(educationStatus == "Passout"){
            for i in 2005...2022{
                years.append(String(i))
            }
        }
        else if(educationStatus == "Pursuing"){
            for i in 2023...2028{
                years.append(String(i))
            }
        }
        return years
    }
    
    func jobStatus()->[String]{
        return ["Fresher","Experienced"]
    }
    
    func reference()->[String]{
        return ["LinkedIn","Instagram","News Paper","WhatsApp","PHN Employee","Other"]
    }
    
    func stateDistricts()->[State]?{
            guard let fileLocation = Bundle.main.url(forResource: "state_district", withExtension: "json")
            else{return nil}
            do{
                let data = try Data( contentsOf: fileLocation)
                let recivedData = try JSONDecoder().decode(StateData.self, from: data)
                let states = recivedData.states
                return states
            }
            catch{
                print("Data Not Fetched")
            }
        return nil
    }
    
}

//   let stateData = try? JSONDecoder().decode(StateData.self, from: jsonData)

// MARK: - StateData
struct StateData: Codable {
    let states: [State]
}

// MARK: - State
struct State: Codable {
    let state: String
    let districts: [String]
}
