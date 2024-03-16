//
//  BotViewModel.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 11/02/1445 AH.
//

import Foundation
import Assistant
import AVFoundation
import SwiftUI
import Combine
import SwiftyGif


class VoiceBotViewModel: ObservableObject, BootAssestentCommunication {
    
    var assestent = BootAssestentUseCase(assistantService: DependencyContainer.shared.assistantService)
    
    let bootAudioPlayer = BootAudioPlayer(serviceProvider: DependencyContainer.shared.textToSpeechService)
    
    @Published var isBotGreeted: Bool = false
    @Published var isRecordingSheetPresented: Bool = false
    @Published var bot: Bot
    @Published var error : BotAppError?

    private var transcriptCancellable: AnyCancellable?
    
    private var speechRecognizer: SpeechRecognizer
    
    func startAssestentSession(){
        startLoading()
        assestent.createSession(bootInitalizeValue: bot.type.apiName) { result in
            switch result {
            case .success(let responce):
                self.bootAudioPlayer.playAudioFor(self.bot.type , text: responce)
            case .failure(let error):
                print(error.localizedDescription)
                self.speechRecognizer.info = .error(description: "حدث خطأ في الجلسه ، الرجاء اغلاق التطبيق وإعادة فتحه")
            }
        }
    }
    
    
    init(speechRecognizer: SpeechRecognizer , bot: Bot = Bot(type: .saud, status: .listening)){
        self.bot = bot
        self.speechRecognizer = speechRecognizer
        self.subscribeToAudioRecorder()
        self.subscribeToAudioPlayer()
        self.startAssestentSession()
    }
    
    func toggleBotCarecter(){
        isBotGreeted = false
        if bot.type == .najd {
            bot.type = .saud
           startAssestentSession()
        }else {
            bot.type = .najd
           startAssestentSession()
        }
    }
    
    func letBotTalkAbout(message : String){
        self.sendMessageToBoot(message)
    }
    
    
    func stopTalking() {
        bootAudioPlayer.audioPlayer.stop()
    }
    
    private func sendMessageToBoot(_ transcript: String){
        getBootResponse(for: transcript) { result in
            switch result {
            case .success(let responce):
                self.bootAudioPlayer.playAudioFor(self.bot.type, text: responce.text)
                print (responce)
            case .failure(let failure):
                self.speechRecognizer.info = .error(description: "حدث خطأ ما الرجاء إعادة فتح التطبيق")
            }
        }
    }
}

extension VoiceBotViewModel: BotAudioPlayerDelegate {
    
    private func doBotTalkStatus() {
        bot.animateTalking()
        speechRecognizer.stopListening()
        speechRecognizer.transcript = ""
    }
    private func doBotListenStatus() {
        bot.animateListening()
        speechRecognizer.startListening()
    }
    private func finishBotGreeting(){
        if !isBotGreeted {
            stopLoading()
            isBotGreeted = true

        }
    }
    
    private func stopLoading(){
        self.speechRecognizer.info = .none
    }
    private func startLoading(){
        self.speechRecognizer.info = .loading
    }
    
    func audioPlayerDidStartPlaying() {
        doBotTalkStatus()
    }
  
    func audioPlayerDidFinishPlaying(successfully: Bool) {
        if successfully {
            doBotListenStatus()
            finishBotGreeting()
        } else {
           print("DEBUG : Voice not successfully Played")
        }
    }
}



extension VoiceBotViewModel {
    
    private func subscribeToAudioRecorder(){
        transcriptCancellable = speechRecognizer.$finalTranscript
            .receive(on: DispatchQueue.main) // Ensure updates are on the main queue
            .sink { [weak self] transcribt in
                self?.sendMessageToBoot(transcribt)}
    }
    
    private func subscribeToAudioPlayer(){
        bootAudioPlayer.audioPlayer.delegate = self
    }
    
}
