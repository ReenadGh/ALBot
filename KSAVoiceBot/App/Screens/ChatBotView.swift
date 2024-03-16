//
//  ChatBotView.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 02/02/1445 AH.
//

import SwiftUI

//
//  ContentView.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 24/01/1445 AH.
//

import SwiftUI
import Assistant
import AVFoundation
import Combine
struct ChatBotView: View {
    
    @State var BotResponce: String = ""
    @State var message: String = ""
    @State var errorMessage: String? 
    let synthesizer = AVSpeechSynthesizer()
    @StateObject var chatViewModel: ChatBotViewModel = ChatBotViewModel()

    var body: some View {
        VStack {
             messageListView(chatViewModel.chat.messages)
            VStack (spacing: 0){
                if let errorMessage = errorMessage {
                    
                    ErrorsView(errors: [errorMessage]) {
                        
                    }
                    .frame(height: 40)
                    .padding(.horizontal)
                }

                HStack {
                    TextField("أدخل رسالتك هنا", text: $message)
                    Button {

                        chatViewModel.sendMessage(message){ result in
                            switch result {
                            case .success(_): break
                                
                            case .failure(let error):
                                errorMessage = error.message
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5 ){
                                    errorMessage = nil
                                }
                                    
                            }
                            
                        }
                        message = ""

                    } label: {
                        Image(systemName: "paperplane.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(Color("Color-Blue"))
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            .padding()
            }
            
        
            
        }
        .environment(\.layoutDirection, .rightToLeft)
        .preferredColorScheme(.light)
        .dismissKeyboard(on: [.drag , .tap])
        .keyboardAware()
        .padding(.top)

    }
        
    private func messageListView(_ list: [Message])-> some View {
        ScrollViewReader { scrollView in // Use ScrollViewReader
            ScrollView{
                ForEach(list ,id: \.self){ message in
                    HStack{
                        HStack {
                            Text(message.message)
                                .multilineTextAlignment(.leading)
                                .fontTheme(font: .regular, size: 16 ,color: .gray)
                                .padding()
                                .background(chatViewModel.messageBackgroundColor(message))
                                .cornerRadius(12)
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width - 30 , alignment: chatViewModel.messageAlignment(message))
                        
                    }
                    .frame(maxWidth: .infinity)
                    .id(message) // Use id to identify each message
                }
            }
            .frame(maxWidth: .infinity)
            .onChange(of: list) { list in
                scrollView.scrollTo(list.last)
            }
           .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            if newIsKeyboardVisible {
                scrollView.scrollTo(list.last)
                
            }
        }
        }
    }
}

struct ChatBotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView()
    }
}
