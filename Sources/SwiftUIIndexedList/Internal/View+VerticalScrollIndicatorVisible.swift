/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

extension View {
    @ViewBuilder func verticalScrollIndicatorVisible(_ visible: Bool) -> some View {
        if #available(iOS 16, *) {
            self.scrollIndicators(visible ? .visible : .hidden, axes: .vertical)
        } else {
            self.background(UIScrollViewCustomizer(showsVerticalScrollIndicator: visible))
        }
    }
}
