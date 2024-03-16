//
//  Created by Robert Petras
//  Credo Academy ♥ Design and Code
//  https://credo.academy
//

import SwiftUI


enum micStatus {
    case recording
    case stopped
    
    
    var backgroundColor: Color {
        switch self {
        case .recording:
            return Color.green
        case .stopped:
            return Color.gray.opacity(0.5)
        }
    }
    
    var userMessage: String {
        switch self {
        case .recording:
            return "تحدث"
        case .stopped:
            return "إضغط للتحدث"
        }
    }

    
}
struct MicView: View {
  // MARK: - PROPERTIES
  
  @State private var animation: Double = 0.0
  let micStatus: micStatus
    let action : ()-> Void

  // MARK: - BODY

  var body: some View {
          Button {
              
              action()
              
          } label: {
              VStack(spacing: 10) {

          ZStack {
              if micStatus == .recording {
                  Circle()
                      .foregroundColor(Color.green.opacity(0.4))
                      .frame(width: 52, height: 52, alignment: .center)
                      .scaleEffect(1 + CGFloat(animation))
                      .opacity(1 - animation)
              }
            Circle()
            .foregroundColor(micStatus.backgroundColor)
            .frame(width: 54, height: 54, alignment: .center)
            .shadow(color: .black.opacity(0.1), radius: 3 , x : 10 , y: 10)

         
              Image(systemName: micStatus == .recording ? "pause.fill" : "mic.fill")
                    .font(.system(size: 30, weight: .light))
                .foregroundColor(.white)
            }
              Text(micStatus.userMessage)
                      .fontTheme(font: .medium, size: 15 , color: micStatus.backgroundColor.opacity(0.6))
          
      
        } //: ZSTACK
              .onChange(of: micStatus, perform: { _ in
                  if animation == 1 {
                      animation = 0
                  }
                  withAnimation(Animation.easeOut(duration: 2).repeatForever(autoreverses: false)) {
                      
                    animation = 1
                  }
                  
              })
              .onAppear{
                  withAnimation(Animation.easeOut(duration: 2).repeatForever(autoreverses: false)) {
                      
                    animation = 1
                  }
              }

      }
  }
}

// MARK: - PREVIEW

struct MicView_Previews: PreviewProvider {
  
  static var previews: some View {
      MicView(micStatus:.recording ){
          
      }
      .previewLayout(.sizeThatFits)
      .padding(60)
      .background(.white)
  }
}
