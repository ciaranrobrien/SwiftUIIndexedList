/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal extension EnvironmentValues {
    var indexBarBackground: IndexBarBackground {
        get { self[IndexBarBackgroundKey.self] }
        set { self[IndexBarBackgroundKey.self] = newValue }
    }
    var internalIndexBarInsets: EdgeInsets? {
        get { self[IndexBarInsetsKey.self] }
        set { self[IndexBarInsetsKey.self] = newValue }
    }
}


private struct IndexBarBackgroundKey: EnvironmentKey {
    static let defaultValue = IndexBarBackground(contentMode: .fit, view: { AnyView(EmptyView()) })
}


private struct IndexBarInsetsKey: EnvironmentKey {
    static let defaultValue: EdgeInsets? = nil
}
