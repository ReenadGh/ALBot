//
//  Font.swift
//  SwiftuiTemplateiOS
//
//  Created by Reenad gh on 27/08/1444 AH.
//

import Foundation

protocol FontName {
    var name: String { get }
}

enum DinNextArabicFontText : String , FontName  {
    
    case bold = "DINNEXTLTARABIC-Bold"
    case medium = "DINNEXTLTARABIC-Medium"
    case regular = "DINNEXTLTARABIC-Regular"
    case light = "DINNEXTLTARABIC-Light"
    
    var name: String {
        return self.rawValue
    }
}
