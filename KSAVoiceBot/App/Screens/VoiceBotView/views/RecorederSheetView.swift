//
//  RecorederSheetView.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 14/02/1445 AH.
//

import SwiftUI

extension VoiceBotView {

    func recorderView(height:CGFloat , width : CGFloat)-> some View {
             VStack(spacing: 8) {
                 Text(speechRecognizer.transcript)
                     .padding(.horizontal , 60)
                     .fontTheme(font: .regular, size: 15 , color: .gray)
                     .frame(maxHeight: 60)
                     .shadow(radius: 10)
                 MicView(micStatus: speechRecognizer.isRecording ? .recording: .stopped){
                     speechRecognizer.toggleRecording()
                     botViewModel.stopTalking()
                     
                 }                 
             }     
    }
    func setTranscriptForPreview(_ text: String) -> VoiceBotView {
        var updatedView = self
        updatedView.speechRecognizer.transcript = text
        return updatedView
    }
}

struct RecorederSheetView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceBotView()
            .setTranscriptForPreview("تجربة تجربة تجربة تجربة تجربة تجربة تجربة تجربة تجر بةتجربة تجربةت جربةا لمحادثه الصوتيه")
            .recorderView(height: 240, width: UIScreen.main.bounds.width)
           // .padding()
            .background(Color.red)
            
    }
}
