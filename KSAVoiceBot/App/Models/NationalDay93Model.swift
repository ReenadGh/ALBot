//
//  NationalDay93Model.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 11/02/1445 AH.
//

import Foundation


enum NationalDay93 : CaseIterable {
    case diriyahGateProject
    case AlshubiaSolarPower
    case AlulaDevelopment
    case KindomAstronautProgram
    case cubeProject
    case electricCars
    case theLine
    case Sindalah
    case alsoudah
    case salmanPark
    case sportsBoulevard
    
    
    var title: String {
        switch self {
        case .diriyahGateProject:
            return "مشروع بوابة الدرعية"
        case .AlshubiaSolarPower:
            return "مشروع الشعبية للطاقة الشمسية"
        case .AlulaDevelopment:
            return "مشروع تطوير العلا"
        case .KindomAstronautProgram:
            return "برنامج المملكة لرواد الفضاء"
        case .cubeProject:
            return "مشروع المكعب"
        case .electricCars:
            return " مشروع السيارات الكهربائية"
        case .theLine:
            return "مشروع ذا لاين"
        case .Sindalah:
            return "مشروع سندالة"
        case .alsoudah:
            return "مشروع السودة للتطوير"
        case .salmanPark:
            return "مشروع حديقة الملك سلمان"
        case .sportsBoulevard:
            return "مشروع المسار الرياضي"
        }
    }
    
    var imageName: String {
        switch self {
        case .diriyahGateProject:
            return "Artboard 5"
        case .AlshubiaSolarPower:
            return "Artboard 9"
        case .AlulaDevelopment:
            return "Artboard 3"
        case .KindomAstronautProgram:
            return "Artboard 2"
        case .cubeProject:
            return "Artboard 1"
        case .electricCars:
            return "Artboard 12"
        case .theLine:
            return "Artboard 11"
        case .Sindalah:
            return "Artboard 10"
        case .alsoudah:
            return "Artboard 1"
        case .salmanPark:
            return "Artboard 8"
        case .sportsBoulevard:
            return "Artboard 7"
        }
    }
}
