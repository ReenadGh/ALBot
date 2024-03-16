//
//  DependencyContainer.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 28/01/1445 AH.
//

import Foundation
import Assistant
import SwiftUI
protocol AssistantConfig {
    static var apiKey: String {get}
    static var serviceURL: String {get}
    static var assistantID: String {get}
}


struct KSAKidAssistantConfig: AssistantConfig{
    static let apiKey = "ffj9Pz-BPuXMF-klmzaDEHzXV_h23uWWzNNw-SHA2gu3"
    static let serviceURL = "https://api.eu-gb.assistant.watson.cloud.ibm.com/instances/d802cb5f-89da-4bde-80b1-3e33236175d5"
    static let assistantID = "d510f4b2-36f6-4d51-8406-bee7acbeff58"
}
struct SmartyAssistantConfig: AssistantConfig{
    static let apiKey = "ffj9Pz-BPuXMF-klmzaDEHzXV_h23uWWzNNw-SHA2gu3"
    static let serviceURL = "https://api.eu-gb.assistant.watson.cloud.ibm.com/instances/d802cb5f-89da-4bde-80b1-3e33236175d5"
    static let assistantID = "2f22fe26-260a-4144-8f74-0d504c4ec823"
}
struct TextToSpeechConfig {
    static let apiKey = "AIzaSyAhF3bxrveUchz-mR5URvNaMYt3ukrVIAc"
    static let serviceURL = "https://texttospeech.googleapis.com/v1/text:synthesize?key="
}

class DependencyContainer {
    
    static let shared = DependencyContainer()
    
    var assistantService : AssistantService = .init(apiKey: KSAKidAssistantConfig.apiKey, serviceURL: KSAKidAssistantConfig.serviceURL, assistantID: KSAKidAssistantConfig.assistantID)
    
    var textToSpeechService: TextToSpeechService = .init(baseUrl: TextToSpeechConfig.serviceURL, apiKey: TextToSpeechConfig.apiKey)

}
