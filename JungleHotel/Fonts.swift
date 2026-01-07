//
//  Fonts.swift
//  JungleHotel
//
//  Created by TS2 on 10/23/25.
//

import SwiftUI
struct ThemeFont {
    static let titleFont:Font = Font.largeTitle
    static let smallText: Font = Font.caption2
    
    // Attempting to match the filename found in bundle
    static let montserratUnderline: Font = Font.custom("MontserratUnderline-Regular", size: 20)
}

// Helper to print font names to console
func printAllFonts() {
    for family in UIFont.familyNames.sorted() {
        let names = UIFont.fontNames(forFamilyName: family)
        print("Family: \(family) Font names: \(names)")
    }
}
