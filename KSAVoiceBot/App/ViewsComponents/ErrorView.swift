//
//  ErrorView.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 11/02/1445 AH.
//

import SwiftUI


struct ErrorsView : View {
    
     var errors: [String]
    var action: ()-> Void
    var body: some View {

        HStack {
            VStack (alignment: .leading, spacing: 7){
                VStack {
                    ForEach(errors , id : \.self) { item in
                        HStack {
                            Image(systemName : "exclamationmark.triangle.fill")
                            Text(item)
                                .multilineTextAlignment(.leading)
                                .fontTheme(font: .regular, size: 13 , color : .red)
                        }
                        .foregroundColor(.red)
                    }
                }
            }
                Spacer()
                  Button {
                                    action()
                                } label: {
                                    Image(systemName: "arrow.clockwise")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width : 20)
                                        .foregroundColor(Color.white)
                                        .shadow(color: .black.opacity(0.3), radius: 6 , x : 4 , y : 10)
                                }
        }
            
            .padding()
        .background(
            ZStack {
                Color.white
                Color.red.opacity(0.13)
            }
        )
        .overlay(
            
        RoundedRectangle(cornerRadius: 10)
            .stroke()
            .foregroundColor(Color.red.opacity(0.8))
        
        )
    .cornerRadius(10)
    
    }
}

struct Errors_Previews: PreviewProvider {
    static var previews: some View {
        ErrorsView(errors: ["error"]){
            
        }
    }
}
