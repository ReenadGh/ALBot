//
//  voice.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 28/01/1445 AH.
//

import Foundation
import AVFAudio


enum AppError : Error {
    case error(description: String)
}

class TextToSpeechService {
    
    let baseURL : URL?
    
    init(baseUrl: String , apiKey: String) {
        self.baseURL = URL(string: "\(baseUrl)\(apiKey)")
    }
    func  getAudioDecodedData(for bot : BotCarecter , text: String, completion: @escaping (Result<Data,AppError>)-> Void){
        guard !text.isEmptyOrWhitespace() else {
            return
        }
       let setting =  bot.voiceSetting()
        print("Text : \(text)")
        guard let baseURL = baseURL else {
            completion(.failure(.error(description: "not found url")))
            return
        }
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
        // Construct the request body
        let requestBody: [String: Any] = [
              "input": ["text": text], // Specify your Arabic text here
              "voice": ["languageCode": setting.languageCode , "name": setting.voiceName], // Specify voice and language
              "audioConfig": [
                  "audioEncoding": "MP3", // Specify audio encoding
                  "pitch": setting.pitch // Specify pitch
              ]
          ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(.error(description: "Error creating JSON data: \(error)")))
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            print(error?.localizedDescription)
            if let data = data {
                do {
                     let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if  let audioData = json?["audioContent"] as? String,
                       let audioDecodedData = Data(base64Encoded: audioData) {
                            completion(.success(audioDecodedData))
                    }else {
                        completion(.failure(.error(description: "Error extracting audio content from JSON response")))
                    }
                } catch {
                    completion(.failure(.error(description: "Error parsing response JSON: \(error)")))
                }
            }else {
                completion(.failure(.error(description: "Error no data in responce")))
            }
        }
        
        task.resume()
        
        
    }
}
