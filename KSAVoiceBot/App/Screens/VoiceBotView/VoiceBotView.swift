////
////  ContentView.swift
////  KSAVoiceBot
////
////  Created by Reenad gh on 24/01/1445 AH.
////
//
import Assistant
import AVFoundation
import SwiftUI
import Combine
import SwiftyGif


enum infoStatus : Equatable {
    case loading
    case error(description: String)
    case none
}

struct VoiceBotView: View {
    
    @StateObject var speechRecognizer: SpeechRecognizer
    @StateObject var botViewModel: VoiceBotViewModel
    @State private var imageOffset: CGSize = .zero
    @State private var indicatorOpacity: Double = 1.0
    @State private var isAnimating: Bool = false
    @State var isChatBotViewPresented: Bool = false
    @State var isLanguageViewPresented: Bool = false
    @State var isSliderViewPresented: Bool = false
    
    init(){
        let speechRecognizer = SpeechRecognizer(language: Locale(identifier: "ar-SA"), stopRecordingAfter: 1.2)
        let botViewModel = VoiceBotViewModel(speechRecognizer: speechRecognizer)
        _speechRecognizer = StateObject(wrappedValue: speechRecognizer)
        _botViewModel = StateObject(wrappedValue: botViewModel)
    }

    var body: some View {
        VStack{
            VStack(spacing: 0) {
                HStack{
                    Button{
                        isChatBotViewPresented.toggle()
                    } label: {
                        Image(systemName:"ellipsis.bubble")
                            .font(.system(size: 20))
                            .foregroundColor(.gray.opacity(0.8))
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(6)
                            .shadow(color: .black.opacity(0.1), radius: 3 , x : 10 , y: 10)
                    }
                    .padding(.leading)

                    Spacer()

                }
                carecterContinerView(height:  UIScreen.main.bounds.height / 2)
            }
            .frame(maxHeight: UIScreen.main.bounds.height / 1.5)

            .overlay(
               sliderListView
                .offset(y: -40)
                , alignment: .bottomLeading
            )
            Spacer()
            ZStack{
                Image("continer")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width + 8, height: 230)
                    .background(VStack{
                        Spacer()
                        Rectangle()
                            .frame(height: 230 / 2)
                            .foregroundColor(Color.white)
                    })
                if case .error(let description) = speechRecognizer.info {
                    ErrorsView(errors: [description]){
                        speechRecognizer.startListening()
                    }
                    .padding(.horizontal , 20)

                } else if case .loading = speechRecognizer.info {
                    Spacer()
                    ProgressView()
                        .tint(.KSABlueColor)
                        .scaleEffect(1.8)
                    Spacer()
                }else if case .none = speechRecognizer.info {
                    Spacer()
                    recorderView(height: 230, width: UIScreen.main.bounds.width)
                        .isHidden(speechRecognizer.isError ,remove: !speechRecognizer.isError)
                        .isHidden(!botViewModel.isBotGreeted ,remove: !botViewModel.isBotGreeted)
                }
            }
         
            
            .overlay(
                Text("* نسخة تجريبية")
                    .fontTheme(font: .medium, size: 15 , color: .gray.opacity(0.6))
                    .padding(26)
                    .padding(.bottom)
                    .padding(.leading , 6)

                
                , alignment: .bottomLeading
                )
        }
        
        .ignoresSafeArea(edges: .bottom)
        .onAppear(perform: {
            isAnimating = true
        })
        .background(
                Color.KSABlueColor
                   .ignoresSafeArea()

        )
        .sheet(isPresented: $isChatBotViewPresented) {
            ChatBotView()
        }
        .sheet(isPresented: $isLanguageViewPresented) {
            if #available(iOS 16.0, *) {
                ChatBotView()
                .presentationDetents([.medium])
            }else {
                ChatBotView()
            }
        }
        .overlay(
            VStack (spacing: 0){
                Image("sda-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(3)
                    .background(Color.white.opacity(0.2)).cornerRadius(2)
            
            }
            
            .padding()
            ,alignment: .topTrailing
        )



//        .frame(maxWidth: .infinity)
//        .frame(maxHeight: .infinity)
        .environment(\.layoutDirection, .rightToLeft)
        .preferredColorScheme(.light)
        
    }
    

    private func carecterContinerView(height : CGFloat) -> some View {
        
        VStack(spacing: 10) {
            
            ZStack{
                CircleGroupView(ShapeColor:.white, ShapeOpacity: 0.2)
                    .offset(x: imageOffset.width * -1)
                    .blur(radius: abs(imageOffset.width / 5))
                    .animation(.easeOut(duration: 1), value: imageOffset)
                 //   .frame(maxWidth: UIScreen.main.bounds.size.width / 1.5)
                    .frame(height: height - 150)
                
                carecterView
                    .frame(height: height - 40)

            }
            Button {
                botViewModel.toggleBotCarecter()
            } label: {
                Image(systemName: "arrow.left.and.right.circle")
                    .font(.system(size: 44, weight: .ultraLight))
                    .foregroundColor(.white)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeOut(duration: 1).delay(1), value: isAnimating)
            }
            .isHidden(speechRecognizer.isError ,remove: !speechRecognizer.isError)
        }
    }
    
   
    
    
 
    private var carecterView: some View {
        SwiftyGifImageView(gifName:botViewModel.bot.getGifNameStatusImage)
          // .frame(maxWidth: UIScreen.main.bounds.size.width / 2)
          // .frame(maxHeight: UIScreen.main.bounds.size.height / 2.4)
            .frame(alignment: .center)
            .opacity(isAnimating ? 1 : 0)
            .animation(.easeOut(duration: 0.5), value: isAnimating)
           .offset(x: imageOffset.width * 1.2, y: 0)
            .rotationEffect(.degrees(Double(imageOffset.width / 20)))
            .shadow(color: .black.opacity(0.1), radius: 3 , x : 0 , y: 10)
            .offset(x: 10)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if abs(imageOffset.width) <= 500 {
                            imageOffset = gesture.translation
                            
                            withAnimation(.linear(duration: 0.25)) {
                                indicatorOpacity = 0
                            }
                        }
                    }
                    .onEnded { _ in
                        imageOffset = .zero
                        withAnimation(.linear(duration: 0.25)) {
                            botViewModel.toggleBotCarecter()
                        }
                    }
            ) //: GESTURE
            .animation(.easeOut(duration: 1), value: imageOffset)
        
    }
}


    struct BootsView_Previews: PreviewProvider {
        static var previews: some View {
            VoiceBotView()
        }
    }





