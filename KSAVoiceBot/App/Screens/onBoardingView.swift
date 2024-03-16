//
//  onBoardingView.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 15/02/1445 AH.
//

import SwiftUI

struct OnboardingContent: Identifiable {
    let id = UUID()
    let backgroundImageName: String
    let imageName: String
    let title: String
    let description: String
}

class OnboardingViewModel: ObservableObject {
    @Published var currentIndex = 0
    @Published var isOnboardingComplete = false

    let onboardingContent: [OnboardingContent] = [
        OnboardingContent(backgroundImageName: "onboarding-33", imageName: "onboarding-person1", title: "المحادثة الصوتية", description: "تحدث معي عن كل ما يثير فضولك حول المملكة العربية السعودية وانا سوف احاول إجابتك فلدي الكثير من المعلومات !"),
        OnboardingContent(backgroundImageName: "onboarding-22", imageName: "onboarding-person2", title: "تبديل الشخصيات", description: "بدل بيننا عن طريق سحب الشاشة يمين او يسار وتحدث مع شخصيتك المفضلة !"),
        OnboardingContent(backgroundImageName: "onboarding-11", imageName: "onboarding-person3", title: "المحادثة النصية", description: "تستطيع ان تحدثني عن طريق المحادثة النصيه دون الحاجه لسماع صوتك!"),
    ]
    
    func goToNextSlide() {
        if currentIndex < onboardingContent.count - 1 {
            currentIndex += 1
        } else {
            isOnboardingComplete = true
        }
    }
    var isLastSlide : Bool {
        return currentIndex == onboardingContent.count - 1
    }
    
    func goToPreviousSlide() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
}


struct OnboardingView: View {
    @ObservedObject private var viewModel = OnboardingViewModel()
    @AppStorage("showWelcomeScreen") var showWelcomeScreen : Bool = true

    var body: some View {
           ZStack {
               TabView(selection: $viewModel.currentIndex) {
                   ForEach(viewModel.onboardingContent.indices, id: \.self) { index in
                       let content = viewModel.onboardingContent[index]
                       ZStack{
                                VStack(spacing: 30){
                                    Image(content.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 250 , height: 250)

                                    VStack(spacing: 13) {
                                        Text(content.title)
                                            .fontTheme(font: .bold, size: 30 , color: .white)
                                        
                                        Text(content.description)
                                            .fontTheme(font: .medium, size: 15 , color: .white)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(.horizontal , 50)
                                    Button(action: {
                                        showWelcomeScreen = false
                                    }, label: {
                                        Text("البدء الان !")
                                            .fontTheme(font: .medium, size: 16 , color: .white)
                                            .padding(.horizontal , 50)
                                            .padding(.vertical , 10)
                                            .overlay(RoundedRectangle(cornerRadius: 30).stroke())
                                            .padding(.bottom , 70)
                                            .foregroundColor(.white)
                                            
                                    })
                                }
                                   
                        //       )
                       }
                   }
               }
               .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
               .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
               .frame(maxHeight: UIScreen.main.bounds.height * 0.9)
           }
        
           .frame(maxWidth: .infinity , maxHeight: .infinity)
           .background(
            Image(viewModel.onboardingContent[viewModel.currentIndex].backgroundImageName)
            .resizable()
            .scaledToFill()
           )
//           .overlay(
//               Button(action: {
//
//               }, label: {
//                   Text("البدء الان !")
//                       .fontTheme(font: .medium, size: 16 , color: .white)
//                       .padding(.horizontal , 50)
//                       .padding(.vertical , 10)
//                       .overlay(RoundedRectangle(cornerRadius: 30).stroke())
//                       .padding(.bottom , 70)
//                       .foregroundColor(.white)
//
//               })
//               ,alignment: .bottom
//           )
       
        
           .ignoresSafeArea()

           .environment(\.layoutDirection, .rightToLeft)
           .preferredColorScheme(.light)

       }
   }

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

