//
//  AccessibilityLargeContentView.swift
//  
//
//  Created by Ciaran O'Brien on 30/12/2021.
//

import SwiftUI

internal extension View {
    func accessibilityLargeContentView<Content>(@ViewBuilder content: @escaping () -> Content) -> some View
    where Content : View
    {
        Group {
            if #available(iOS 15, *) {
                self.accessibilityShowsLargeContentViewer(content)
            } else {
                self
            }
        }
    }
}
