/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public extension View {
    func indexBarBackground(
        contentMode: ContentMode = .fit,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View
    {
        environment(\.indexBarBackground, IndexBarBackground(contentMode: contentMode, view: { AnyView(content()) }))
    }
}
