//
//  EtimadIndividualsFontTheme.swift
//  SwiftuiTemplateiOS
//
//  Created by Reenad gh on 27/08/1444 AH.
//

import SwiftUI


extension View {

        
        func fontTheme(font: DinNextArabicFontText ,size: CGFloat , color: Color? = nil ) -> some View {
            self.modifier(TextStyle(font:.custom(font.name, size: size), color: color ))
        }

    }

    struct TextStyle: ViewModifier {
        let font: Font
        let color: Color?
        var textAlignment: TextAlignment = .center
        
        func body(content: Content) -> some View {
                      content
                          .font(font)
                          .foregroundColor(color ?? Color.clear)
                          .multilineTextAlignment(textAlignment)
               
            }
        }
