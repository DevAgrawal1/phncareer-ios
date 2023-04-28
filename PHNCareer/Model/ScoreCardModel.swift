//
//  ScoreCardModel.swift
//  PHNCareer
//
//  Created by PHN MAC 1 on 12/04/23.
//

import Foundation
struct ScoreCard : Decodable{
    let success:Bool
    let statusCode:String
    let message:String
    let training:[ScoreCardTraining]
    
    enum RootKeys:String,CodingKey{
        case success
        case statusCode = "status_code"
        case message
        case training
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        statusCode = try container.decode(String.self, forKey: .statusCode)
        message = try container.decode(String.self, forKey: .message)
        training = try container.decode([ScoreCardTraining].self, forKey: .training)
    }
}

struct ScoreCardTraining : Decodable{
    let courseId:String
    let title:String
    let playedQuiz:Int
    let overallPerformance:Int
    let section:[ScoreCardSection]
    
    enum ScoreCardTrainingKeys:String,CodingKey{
        case courseId = "course_id"
        case title
        case playedQuiz = "played_quiz"
        case overallPerformance = "overall_performance"
        case section
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ScoreCardTrainingKeys.self)
        courseId = try container.decode(String.self, forKey: .courseId)
        title = try container.decode(String.self, forKey: .title)
        playedQuiz = try container.decode(Int.self, forKey: .playedQuiz)
        overallPerformance = try container.decode(Int.self, forKey: .overallPerformance)
        section = try container.decode([ScoreCardSection].self, forKey: .section)
    }
}

struct ScoreCardSection : Decodable{
    let sectionId:String
    let title:String
    let score:Int
    let attempted:String
    let skipped:String
    let total:String
    
    enum ScoreCardSectionKeys:String,CodingKey{
      case sectionId = "section_id"
      case title
      case score = "Score"
      case attempted = "Attempted"
      case skipped = "Skipped"
      case total = "Total"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ScoreCardSectionKeys.self)
        sectionId = try container.decode(String.self, forKey: .sectionId)
        title = try container.decode(String.self, forKey: .title)
        score = try container.decode(Int.self, forKey: .score)
        attempted = try container.decode(String.self, forKey: .attempted)
        skipped = try container.decode(String.self, forKey: .skipped)
        total = try container.decode(String.self, forKey: .total)
    }
}
