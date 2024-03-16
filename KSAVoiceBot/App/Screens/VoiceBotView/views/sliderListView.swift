//
//  sliderListView.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 14/02/1445 AH.
//

import SwiftUI

extension VoiceBotView {
     var sliderListView: some View {
        HStack{
            ScrollView (.horizontal , showsIndicators: false) {
                HStack(alignment: .top , spacing: 5){
                    ForEach(NationalDay93.allCases, id: \.self) { project in
             Button {
                            botViewModel.letBotTalkAbout(message: project.title)
                            
                        } label: {
                            VStack(alignment: .center , spacing: 4) {
                                Image(project.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60 , height: 60)
                                    .cornerRadius(8)
                                Text(project.title)
                                    .fontTheme(font: .medium, size: 10 , color: .gray.opacity(0.8))
                        }
                        }
                        .frame(width : 80)

                    }
                }
            }
            Button {
                withAnimation(.linear(duration: 0.6)){
                    isSliderViewPresented.toggle()
                }
            } label: {
                HStack (spacing: 0){
                    
                    if !isSliderViewPresented {
                        Image("logo-green")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70)
                    }
                    Image(systemName: isSliderViewPresented ? "chevron.right" : "chevron.left")
                        .foregroundColor(.gray)
                    .imageScale(.medium)
                    .frame(width: 5)
                }
                .frame(maxHeight: 100)
                .frame(minHeight: 50)

            }
        }
        .padding(.horizontal)
        .padding(.vertical , 10)
        .background()
        .cornerRadius(12)
        .offset(x : isSliderViewPresented ? -20 : -(UIScreen.main.bounds.width - 100))
        .frame(maxHeight: 140)
        .frame(minHeight: 120)

        .shadow(color: .black.opacity(0.2), radius: 5 , x : 10 , y: 10)
        .environment(\.layoutDirection, .rightToLeft)

    }

}

struct sliderListView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceBotView().sliderListView
    }
}
