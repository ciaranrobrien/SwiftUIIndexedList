/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI
import SwiftUIIntrospect

internal extension Index {
    init(separatorWith contentID: AnyHashable) {
        self.contentID = contentID
        self.displayPriority = .standard
        self.icon = nil
        self.title = nil
    }
    
    @ViewBuilder func label() -> some View {
        if let title {
            if let icon {
                Label { title } icon: { icon }
            } else {
                title
            }
        } else {
            Circle()
                .frame(width: 6, height: 6)
        }
    }
}


internal extension IndexedList {
    enum Selection {
        case none
        case single(value: Binding<SelectionValue?>?)
        case multiple(value: Binding<Set<SelectionValue>>?)
    }
    
    @ViewBuilder
    func listContent() -> some View {
        switch selection {
        case .none: List(content: content)
        case let .single(value): List(selection: value, content: content)
        case let .multiple(value): List(selection: value, content: content)
        }
    }
}


internal extension ScrollAccessory {
    func showsIndexBar<Indices>(indices: Indices) -> Bool
    where Indices : RandomAccessCollection
    {
        switch self {
        case .automatic: return !indices.isEmpty
        case .indexBar: return true
        case .scrollIndicator: return false
        case .none: return false
        }
    }
    
    func showsScrollIndicator<Indices>(indices: Indices) -> Bool
    where Indices : RandomAccessCollection
    {
        switch self {
        case .automatic: return indices.isEmpty
        case .indexBar: return false
        case .scrollIndicator: return true
        case .none: return false
        }
    }
}


internal extension View {
    @ViewBuilder func verticalScrollIndicatorVisible(_ visible: Bool) -> some View {
        if #available(iOS 16, *) {
            self.scrollIndicators(visible ? .visible : .hidden, axes: .vertical)
        } else {
            self.introspect(.scrollView, on: .iOS(.v14, .v15)) { scrollView in
                scrollView.showsVerticalScrollIndicator = visible
            }
        }
    }
}


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
