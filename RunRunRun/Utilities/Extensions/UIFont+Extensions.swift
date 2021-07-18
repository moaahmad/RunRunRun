//
//  UIFont+Extensions.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 9/8/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

extension UIFont {
    enum Montserrat: String {
        case light = "Montserrat Light"
        case medium = "Montserrat Medium"
        case regular = "Montserrat Regular"
        case italic = "Montserrat Italic"
        case semiBold = "Montserrat SemiBold"
        case bold = "Montserrat Bold"
    }

    enum Poppins: String {
        case light = "Montserrat Light"
        case medium = "Montserrat Medium"
        case regular = "Montserrat Regular"
        case italic = "Montserrat Italic"
        case semiBold = "Montserrat SemiBold"
        case bold = "Montserrat Bold"
    }

    static var h1: UIFont { return poppins(.bold, size: 32) }
    static var h2: UIFont { return poppins(.bold, size: 28) }
    static var h3: UIFont { return poppins(.semiBold, size: 23) }
    static var p1: UIFont { return montserrat(.regular, size: 17) }
    static var p2: UIFont { return montserrat(.regular, size: 16) }
    static var p3: UIFont { return montserrat(.regular, size: 14) }
    static var p4: UIFont { return montserrat(.medium, size: 11) }
    static var cta: UIFont { return montserrat(.medium, size: 16) }

    static func poppins(_ style: Poppins, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: style.rawValue, size: size) else {
            fatalError("\(style.rawValue) is missing from the project.")
        }
        return font
    }

    static func montserrat(_ style: Montserrat, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: style.rawValue, size: size) else {
            fatalError("\(style.rawValue) is missing from the project.")
        }
        return font
    }
}
