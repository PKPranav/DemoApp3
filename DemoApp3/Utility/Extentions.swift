//
//  Extentions.swift
//  DemoApp3
//
//  Created by Pramod Kumar Pranav on 09/09/19.
//  Copyright © 2019 Pramod Kumar Pranav. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIFont extension
extension UIFont {
    var bold: UIFont {
        return with(traits: .traitBold)
    } // bold
    
    var italic: UIFont {
        return with(traits: .traitItalic)
    } // italic
    
    var boldItalic: UIFont {
        return with(traits: [.traitBold, .traitItalic])
    } // boldItalic
    
    
    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        } // guard
        
        return UIFont(descriptor: descriptor, size: 0)
    } // with(traits:)
} // extension


// MARK: - UITextView extension
extension UITextView {
    func increaseFontSize () {
        self.font =  UIFont(name: self.font!.fontName, size: self.font!.pointSize+1)!
    }
    func decreaseFontSize () {
        self.font =  UIFont(name: self.font!.fontName, size: self.font!.pointSize-1)!
    }
}
