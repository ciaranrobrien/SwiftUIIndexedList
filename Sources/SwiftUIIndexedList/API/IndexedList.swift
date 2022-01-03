/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct IndexedList<SelectionValue, Indices, Content>: View
where SelectionValue : Hashable,
      Indices : Equatable,
      Indices : RandomAccessCollection,
      Indices.Element == Index,
      Content : View
{
    public init(accessory: ScrollAccessory = .automatic,
                indices: Indices,
                selection: Binding<SelectionValue?>?,
                @ViewBuilder content: @escaping () -> Content)
    {
        self.accessory = accessory
        self.content = content
        self.indices = indices
        self.selection = .single(value: selection)
    }
    
    public init(accessory: ScrollAccessory = .automatic,
                indices: Indices,
                selection: Binding<Set<SelectionValue>>?,
                @ViewBuilder content: @escaping () -> Content)
    {
        self.accessory = accessory
        self.content = content
        self.indices = indices
        self.selection = .multiple(value: selection)
    }
    
    public var body: some View {
        ScrollViewReader { scrollView in
            Group {
                switch selection {
                case .none: List(content: content)
                case let .single(value): List(selection: value, content: content)
                case let .multiple(value): List(selection: value, content: content)
                }
            }
            .background(UITableViewCustomizer(showsVerticalScrollIndicator: accessory.showsScrollIndicator(indices: indices)))
            .overlay(IndexBar(accessory: accessory, indices: indices, scrollView: scrollView))
            .environment(\.internalIndexBarInsets, accessory.showsIndexBar(indices: indices) ? indexBarInsets : nil)
        }
    }
    
    internal var accessory: ScrollAccessory
    internal var content: () -> Content
    internal var indices: Indices
    internal var selection: Selection
    
    internal enum Selection {
        case none
        case single(value: Binding<SelectionValue?>?)
        case multiple(value: Binding<Set<SelectionValue>>?)
    }
}
