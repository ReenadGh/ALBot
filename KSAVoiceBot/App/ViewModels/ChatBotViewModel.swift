//
//  ChatBotViewModel.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 02/02/1445 AH.
//

import Foundation
import Combine
import SwiftUI

enum UserRole {
    case boot
    case user
}

protocol BootAssestentCommunication {
  
    var assestent : BootAssestentUseCase { get }
   
    func getBootResponse(for message: String, completion: @escaping (Result<KSABotResponce, BotAppError>) -> Void)
}

extension BootAssestentCommunication {
    func getBootResponse(for message: String, completion: @escaping (Result<KSABotResponce, BotAppError>) -> Void) {
        guard !message.isEmptyOrWhitespace() else {
            return
        }
        assestent.sendMessage(message) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
class ChatBotViewModel: ObservableObject , BootAssestentCommunication {
  
    var assestent = BootAssestentUseCase(assistantService: DependencyContainer.shared.assistantService)

    init(assestent: BootAssestentUseCase = BootAssestentUseCase(assistantService: DependencyContainer.shared.assistantService)) {
        self.assestent = assestent
        
        
        assestent.createSession(bootInitalizeValue:  BotCarecter.najd.apiName) { result in
            switch result {
            case .success(let responce):
                print("settion started \(responce)")
            case .failure(let failure):
                print(failure)
            }
        }
        
        chat.sendBootMessage("مرحبا بك في المحادثه النصية ، اكتب هنا كل ما يثير فضولك حول المملكة العربيه السعوديه وانا سوف احاول مساعدتك")
    }
    
    func messageAlignment(_ message : Message)->Alignment {
        message.userRole == .user ? .leading : .trailing
    }
    func messageBackgroundColor(_ message : Message)-> Color {
        message.userRole == .user ? Color.gray.opacity(0.1) : Color("Color-Blue").opacity(0.1)
    }
    
    @Published var chat: Chat = .init()
  
    func sendMessage(_ message: String,completion: @escaping (Result<String, BotAppError>) -> Void){
        guard !message.isEmptyOrWhitespace() else {
            return
        }
        chat.sendUserMessage(message)
        getBootResponse(for: message) { result in
        switch result {
        case .success(let responce):
        self.chat.sendBootMessage(responce.text)
            completion(.success(message))
        case .failure(let failure):
            completion(.failure(.otherError))
          //  self.chat.sendBootErrorMessage(message, error: "حدث خطأ ما ، حاول مره اخرى لاحقا")
            
        }
        }
    }
}


struct Message : Hashable{
    let userRole: UserRole
    let message: String
    let Date: Date
    var errorMessage: String?
}

struct Chat  {
    
    var messages: [Message] = []
    
    mutating func sendUserMessage(_ message: String){
        messages.append(.init(userRole: .user, message: message, Date: Date()))
    }
    mutating func sendBootMessage(_ message: String){
        messages.append(.init(userRole: .boot, message: message, Date: Date()))
    }
    mutating func sendUserErrorMessage(_ message: String , error: String){
        messages.append(.init(userRole: .user, message: message, Date: Date() ,errorMessage: error))
    }
    mutating func sendBootErrorMessage(_ message: String , error: String){

        messages.append(.init(userRole: .boot, message: message, Date: Date() ,errorMessage: error))
    }
}
