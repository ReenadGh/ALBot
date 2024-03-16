//#imageLiteral(resourceName: "simulator_screenshot_4DDA592F-DB63-44DE-84EF-BE41993B2408.png")
//  KSAVoiceBotApp.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 24/01/1445 AH.
//

import SwiftUI


enum AppLanguage: String{
    case arabic = "عربي"
    case english = "English"
}

@main
struct KSAVoiceBotApp: App {
    @AppStorage("showWelcomeScreen") var showWelcomeScreen : Bool = true
    @AppStorage("AppLanguage") var appLanguage: AppLanguage = .arabic

    var body: some Scene {
        WindowGroup {
            if showWelcomeScreen {
                OnboardingView()
            }else {
                VoiceBotView()
            }
        }
    }
}
