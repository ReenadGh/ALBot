//
//  SpeechToText.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 04/02/1445 AH.
//

import Foundation

import AVFoundation
import Foundation
import Speech
import SwiftUI
import Combine

/// A helper for transcribing speech to text using SFSpeechRecognizer and AVAudioEngine.
class SpeechRecognizer: ObservableObject {
     
    @Published var transcript: String = ""
    @Published var finalTranscript: String = ""
    @Published var isRecording: Bool = false
   
    @Published var info: infoStatus = .loading

    var isError: Bool {
        if case .error = info {
            return true
        }
        return false
    }
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer? = nil
    
    let stopRecordingAfterSecound : CGFloat
    
    func toggleRecording(){
        if !isRecording {
            self.startListening()
        } else {
            self.stopListening()
        }
    }


    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    
    init(language: Locale ,stopRecordingAfter: CGFloat ) {
        recognizer = SFSpeechRecognizer(locale:language)
        self.stopRecordingAfterSecound = stopRecordingAfter
        self.checkRecognizerError()
    }
    
    deinit {
        reset()
    }

    func checkRecognizerError(){
        print("check errorss ")
        Task(priority: .background) {
            do {
                guard recognizer != nil else {
                    throw RecognizerError.nilRecognizer
                }
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                speakError(error)
            }
        }
    }
    
    /// Reset the speech recognizer.
        func reset() {
            task?.cancel()
            audioEngine?.stop()
            audioEngine = nil
            request = nil
            task = nil
            isRecording = false
        }
    /**
           Begin transcribing audio.
        
           Creates a `SFSpeechRecognitionTask` that transcribes speech to text until you call `stopTranscribing()`.
           The resulting transcription is continuously written to the published `transcript` property.
        */
    func startListening() {
        self.checkRecognizerError()
        Task(priority: .background) {
            do {
                guard recognizer != nil else {
                    throw RecognizerError.nilRecognizer
                }
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                speakError(error)
            }
            return
        }
        
        //info = .none
        var timer: Timer? // Initialize a timer
        isRecording = true

        DispatchQueue(label: "Speech Recognizer Queue", qos: .background).async { [weak self] in
          
            guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
         
                self?.speakError(RecognizerError.recognizerIsUnavailable)
                return
            }
            
            do {
                let (audioEngine, request) = try Self.prepareEngine()
                self.audioEngine = audioEngine
                self.request = request
                
                self.task = recognizer.recognitionTask(with: request) { result, error in
                    let receivedFinalResult = result?.isFinal ?? false
                    let receivedError = error != nil // != nil means there's an error (true)
                    
                    if receivedFinalResult || receivedError {
                        audioEngine.stop()
                        audioEngine.inputNode.removeTap(onBus: 0)
                       // print("sttoped")
                    }
                    
                    if let result = result {
                        // Update the transcript with the current transcription.
                        self.transcript = result.bestTranscription.formattedString
                        
                        // Invalidate the existing timer.
                        timer?.invalidate()
                        
                        // Start a new timer that will print "stop" after 2 seconds.
                        timer = Timer.scheduledTimer(withTimeInterval: self.stopRecordingAfterSecound , repeats: false) { _ in
                           
                            self.saveMessageAndStopListening()
                        }
                    }
                }
            } catch {
                self.reset()
                self.speakError(error)
            }
        }
    }


       
       private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
           let audioEngine = AVAudioEngine()
           let request = SFSpeechAudioBufferRecognitionRequest()
           request.shouldReportPartialResults = true
           
           let audioSession = AVAudioSession.sharedInstance()
           try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
           try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
           let inputNode = audioEngine.inputNode
           
           let recordingFormat = inputNode.outputFormat(forBus: 0)
           inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
               (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
               request.append(buffer)
           }
           audioEngine.prepare()
           try audioEngine.start()
           
           return (audioEngine, request)
       }
    
    private func speakError(_ error: Error) {
        print(error.localizedDescription)
            if let error = error as? RecognizerError {
                switch error {
                case .nilRecognizer:
                    info = .error(description: "")
                case .notAuthorizedToRecognize:
                    info = .error(description: "الرجاء السماح بإستخدام خاصية Speech Recognizer من الاعدادات ")
                case .notPermittedToRecord:
                    info = .error(description: "الرجاء السماح بإستخدام المايكروفون من إعدادات الايفون")
                case .recognizerIsUnavailable:
                    info = .error(description: "الرجاء التأكد من توفر الانترنت")
                }
                
            } else {
                info = .error(description: "حدث خطأ ما ، قم بإعادة تشغيل التطبيق")
            }
    }
    
    private func speak(_ message: String) {
            transcript = message
    }
    /// Stop transcribing audio.
        func stopListening(){
            reset()
        }
    
    private func saveMessageAndStopListening() {
        guard !transcript.isEmptyOrWhitespace() else {
            return
        }
        finalTranscript = transcript
        self.stopListening()
    }
    
    
    
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
