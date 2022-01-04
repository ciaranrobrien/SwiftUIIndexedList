/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public extension View {
    func indexBarBackground<Content>(contentMode: ContentMode = .fit,
                                     @ViewBuilder content: @escaping () -> Content) -> some View
    where Content : View
    {
        environment(\.indexBarBackground, IndexBarBackground(contentMode: contentMode, view: { AnyView(content()) }))
    }
}
