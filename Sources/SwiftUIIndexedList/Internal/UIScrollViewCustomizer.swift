/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct UIScrollViewCustomizer: UIViewRepresentable {
    var showsVerticalScrollIndicator: Bool
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isAccessibilityElement = false
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        DispatchQueue.main.async {
            guard let scrollView = view.superview?.superview?.firstUIScrollView()
            else { return }
            
            scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        }
    }
}
