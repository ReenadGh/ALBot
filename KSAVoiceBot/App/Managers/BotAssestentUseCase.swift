//
//  AssistentViewModel.swift
//  KSAVoiceBot
//
//  Created by Reenad on 25/01/1445 AH.
//

import Foundation
import Assistant

struct KSABotResponce {
    var text : String = ""
    var imageSource : String?
    
    init(responce : [RuntimeResponseGeneric]) {
        for generic in responce {
            if case let RuntimeResponseGeneric.text(textResponse) = generic {
                self.text = textResponse.text
            }
            if case let RuntimeResponseGeneric.image(imageResponce) = generic {
                self.imageSource = imageResponce.source
            }
        }
    }
}

class BootAssestentUseCase {
    
    private let assistantService: AssistantService
    private var sessionID: String?  // Keep track of the session

       init(assistantService: AssistantService) {
           self.assistantService = assistantService
       }
    
    
    func createSession(bootInitalizeValue: String , completion: @escaping (Result< String ,BotAppError>)->Void){
            assistantService.createSession(bootInitalizeValue: bootInitalizeValue) { result in
                switch result {
                case .success(let botResponce):
                    self.sessionID = botResponce.sessionID
                    completion(.success(KSABotResponce(responce: botResponce.initalValue ?? []).text))
                case .failure(let error):
                    if error.errorDescription  == WatsonError.noResponse.errorDescription {
                        completion(.failure(.noInternetConection))
                    }else {
                        completion(.failure(.sessionEnd))
                    }
            }
        }
    }
    
    func sendMessage(_ message: String , completion: @escaping (Result<KSABotResponce ,BotAppError>)-> Void){
                guard let sessionID = sessionID else {
                    completion(.failure(.sessionEnd))
                    return
                }
                self.assistantService.sendMessage(sessionID: sessionID , message: message) { result in
                    switch result {
                    case .success(let responce):
                        completion(.success(KSABotResponce(responce:responce)))
                    case .failure(let error):
                        print("DEBUG : Error from assistantService : \(error.errorDescription)")
                        completion(.failure(.otherError))

            }
        }
    }
}
