//
//  BotAppErorr.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 07/02/1445 AH.
//

import Foundation

enum BotAppError : Error {

    case noInternetConection
    case noRecordAuthintication
    case sessionEnd
    case otherError
    
    var message: String {
        switch self {
        case .noInternetConection:
            return "الرجاء التأكد من توفر الانترنت "
        case .noRecordAuthintication:
           return "لا يمكن تسجيل صوتك ، اذهب الى الاعدادات واسمح للوصول للميكروفون"
        case .sessionEnd:
            return "انتهت الجلسه ، قم باغلاق التطبيق واعادة فتحه"
        case .otherError:
            return "حدث خطأ ما ، حاول مره اخرى لاحقا"
        }
    }
}
