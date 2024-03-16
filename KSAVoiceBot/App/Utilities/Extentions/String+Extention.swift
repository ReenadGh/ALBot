//
//  String+Extention.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 03/02/1445 AH.
//

import Foundation
extension String {
    func isEmptyOrWhitespace() -> Bool {
        
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}
