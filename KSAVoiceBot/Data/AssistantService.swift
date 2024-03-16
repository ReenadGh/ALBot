//
//  AssistantService.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 25/01/1445 AH.
//

import Foundation
import Assistant



struct BotSessionResponce {
    let initalValue: [RuntimeResponseGeneric]?
    let sessionID: String
}



class AssistantService {
    private let assistant : Assistant
    private let assistantID : String
    
    init(apiKey: String, serviceURL: String , assistantID: String) {
        assistant = Assistant(version: "2021-09-01", authenticator: WatsonIAMAuthenticator(apiKey: apiKey))
        assistant.serviceURL = serviceURL
        self.assistantID = assistantID
    }
    
    typealias SessionID = String?
    func createSession(bootInitalizeValue : String , completion: @escaping (Result<BotSessionResponce ,WatsonError>) -> Void) {
        assistant.createSession(assistantID: self.assistantID) { response, error in
            if let error = error {
                completion(.failure(error))
            }
            if let sessionId = response?.result?.sessionID {
                self.sendMessage(sessionID: sessionId, message: "") { _ in
                    self.sendMessage(sessionID: sessionId, message: bootInitalizeValue) { result in
                        switch result {
                        case .success(let responce):
                            completion(.success(.init(initalValue: responce , sessionID: sessionId)))
                        case .failure(let failure):
                            completion(.failure(failure))
                        }
                    }
                }
                completion(.success(.init(initalValue: nil, sessionID: sessionId)))

            }else {
                completion(.success(.init(initalValue: nil, sessionID: "")))
            }
        }
    }

    func sendMessage(sessionID: String , message: String , completion: @escaping (Result<[RuntimeResponseGeneric] ,WatsonError>)-> Void){
        
        let input = MessageInput(text: message)
        
        assistant.message(assistantID: self.assistantID, sessionID: sessionID, input: input) { response, error in
            if let error = error {
               //  print(error.self.failureReason)
                completion(.failure(error))
            }
         //   print(response?.result)
            if let genericResponses = response?.result?.output.generic {
                print("DEBUG :: \(genericResponses)")
                completion(.success(genericResponses))
            }else{
                completion(.failure(.noData))
            }

        }
    }
    
}
