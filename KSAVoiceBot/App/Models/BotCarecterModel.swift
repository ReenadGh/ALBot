//
//  BotCarecterModel.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 12/02/1445 AH.
//

import Foundation
import SwiftUI
enum BotCarecter {
    case najd
    case saud

    
    var apiName: String {
        switch self {
        case .najd:
            return "نجد"
        case .saud:
            return "سعود"
        }
    }
    
    func getGifImageName(for movment : BotStatus)-> String{
        switch self {
        case .najd:
            switch movment {
            case .talking:
                return "najed-talking"

            case .listening:
                return "najed-listening"

            }
            
        case .saud:
            switch movment {
            case .talking:
                return "saud-talking"

            case .listening:
                return "saud-listening"

            }
            
        }
    }
    func getVideoName(for movment : BotStatus)-> String{
        switch self {
        case .najd:
            switch movment {
            case .talking:
                return "najed-talking3"

            case .listening:
                return "najed-listening3"

            }
            
        case .saud:
            switch movment {
            case .talking:
                return "saud-talking3"

            case .listening:
                return "saud-listening3"

            }
            
        }
    }
    
    
    func voiceSetting(languageCode: String = "ar-XA") -> CloudGoogleVoiceSetting {
        switch self {
        case .najd:
            return .init(languageCode: languageCode, voiceName: "ar-XA-Standard-D", pitch: 7.8, speed: 0.9)
        case .saud:
            return .init(languageCode: languageCode, voiceName: "ar-XA-Standard-C", pitch: 7.8, speed: 0.9)

        }
    
    }
}

 enum BotStatus {
     case talking
     case listening
     
 }
struct Bot {
 var type: BotCarecter
 var status: BotStatus
    
    init(type: BotCarecter, status: BotStatus = .listening) {
        self.type = type
        self.status = status
    }
    var getGifNameStatusImage: String{
        return self.type.getGifImageName(for: self.status)
    }
    
    var getVideoNameStatus: String{
        return self.type.getVideoName(for: self.status)
    }
    
    mutating func animateListening(){
        withAnimation(){
            self.status = .listening
        }
    }
    mutating func animateTalking(){
        withAnimation(){
            self.status = .talking
        }
    }
    
}

struct CloudGoogleVoiceSetting{
    let languageCode: String
    let voiceName: String
    let pitch: CGFloat
    let speed:CGFloat
}
