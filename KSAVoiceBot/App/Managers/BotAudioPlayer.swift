//
//  AudioPlayerViewModel.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 29/01/1445 AH.
//

import Foundation
import AVFAudio

//play audio from api service
class BootAudioPlayer : ObservableObject {
    
    let textToSpeechService: TextToSpeechService
    
     var audioPlayer: AudioPlayer = AudioPlayer()
    
    init(serviceProvider: TextToSpeechService ){
        self.textToSpeechService = serviceProvider
    }
    
    func playAudioFor( _ bot : BotCarecter , text: String) {
        textToSpeechService.getAudioDecodedData(for: bot ,text: text) { result in
            DispatchQueue.main.async { // Make sure this code runs on the main thread
                switch result {
                case .success(let audioDecodedData):
                    do {
                        self.audioPlayer.play(data: audioDecodedData)
                    } catch {
                        print("Error playing audio: \(error)")
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
}

protocol BotAudioPlayerDelegate: AnyObject {
    func audioPlayerDidStartPlaying()
    func audioPlayerDidFinishPlaying(successfully: Bool)
}


//get audio from decoding data
class AudioPlayer:  NSObject, AVAudioPlayerDelegate {
   
    private var audioPlayer: AVAudioPlayer?
    private var isPlaying = false

    let audioSession = AVAudioSession.sharedInstance()
   
    weak var delegate: BotAudioPlayerDelegate? // Delegate property
    
    func play(data audioDecodedData :Data) {
        
        audioPlayer?.prepareToPlay() //maybe not needed?  idk
        audioPlayer?.volume = 30

        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord , options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
        
        } catch let error {
            print("Error Voice :\(error.localizedDescription)")
        }
        
        do {
            
            audioPlayer = try AVAudioPlayer(data: audioDecodedData)
            audioPlayer?.delegate = self // Set the delegate to this class
            audioPlayer?.play()
            audioPlayer?.volume = 30
            isPlaying = true
            delegate?.audioPlayerDidStartPlaying()
            
        } catch {
            print(error)
        }
    }
    
    func stop(){
        audioPlayer?.stop()
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Audio has finished playing, you can handle it here
        delegate?.audioPlayerDidFinishPlaying(successfully: flag)
    }
    
}
