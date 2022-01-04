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
    
    private var accessory: ScrollAccessory
    private var content: () -> Content
    private var indices: Indices
    private var selection: Selection
}


public extension IndexedList {
    init(accessory: ScrollAccessory = .automatic,
         indices: Indices,
         selection: Binding<SelectionValue?>?,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.accessory = accessory
        self.content = content
        self.indices = indices
        self.selection = .single(value: selection)
    }
    
    init(accessory: ScrollAccessory = .automatic,
         indices: Indices,
         selection: Binding<Set<SelectionValue>>?,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.accessory = accessory
        self.content = content
        self.indices = indices
        self.selection = .multiple(value: selection)
    }
}


public extension IndexedList
where Indices == [Index]
{
    init<Data, ID, ElementContent>(_ data: Data,
                                   id: KeyPath<Data.Element, ID>,
                                   accessory: ScrollAccessory = .automatic,
                                   selection: Binding<SelectionValue?>?,
                                   @ViewBuilder content: @escaping (Data.Element) -> ElementContent)
    where
    Data : RandomAccessCollection,
    Data.Element : Indexable,
    ID : Hashable,
    ElementContent : View,
    Content == ForEach<Data, ID, ElementContent>
    {
        self.accessory = accessory
        self.content = { ForEach(data, id: id, content: content) }
        self.indices = data.compactMap(\.index)
        self.selection = .single(value: selection)
    }
    
    init<Data, ID, ElementContent>(_ data: Data,
                                   id: KeyPath<Data.Element, ID>,
                                   accessory: ScrollAccessory = .automatic,
                                   selection: Binding<Set<SelectionValue>>?,
                                   @ViewBuilder content: @escaping (Data.Element) -> ElementContent)
    where
    Data : RandomAccessCollection,
    Data.Element : Indexable,
    ID : Hashable,
    ElementContent : View,
    Content == ForEach<Data, ID, ElementContent>
    {
        self.accessory = accessory
        self.content = { ForEach(data, id: id, content: content) }
        self.indices = data.compactMap(\.index)
        self.selection = .multiple(value: selection)
    }
    
    init<Data, ElementContent>(_ data: Data,
                               accessory: ScrollAccessory = .automatic,
                               selection: Binding<SelectionValue?>?,
                               @ViewBuilder content: @escaping (Data.Element) -> ElementContent)
    where
    Data : RandomAccessCollection,
    Data.Element : Identifiable,
    Data.Element : Indexable,
    ElementContent : View,
    Content == ForEach<Data, Data.Element.ID, ElementContent>
    {
        self.accessory = accessory
        self.content = { ForEach(data, content: content) }
        self.indices = data.compactMap(\.index)
        self.selection = .single(value: selection)
    }
    
    init<Data, ElementContent>(_ data: Data,
                               accessory: ScrollAccessory = .automatic,
                               selection: Binding<Set<SelectionValue>>?,
                               @ViewBuilder content: @escaping (Data.Element) -> ElementContent)
    where
    Data : RandomAccessCollection,
    Data.Element : Identifiable,
    Data.Element : Indexable,
    ElementContent : View,
    Content == ForEach<Data, Data.Element.ID, ElementContent>
    {
        self.accessory = accessory
        self.content = { ForEach(data, content: content) }
        self.indices = data.compactMap(\.index)
        self.selection = .multiple(value: selection)
    }
    
    init<Data, ID, ElementContent>(_ data: Binding<Data>,
                                   id: KeyPath<Data.Element, ID>,
                                   accessory: ScrollAccessory = .automatic,
                                   selection: Binding<SelectionValue?>?,
                                   @ViewBuilder content: @escaping (Binding<Data.Element>) -> ElementContent)
    where
    Data : MutableCollection,
    Data : RandomAccessCollection,
    Data.Element : Indexable,
    Data.Index : Hashable,
    ID : Hashable,
    ElementContent : View,
    Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, ElementContent>
    {
        self.accessory = accessory
        self.content = { ForEach(data, id: id, content: content) }
        self.indices = data.wrappedValue.compactMap(\.index)
        self.selection = .single(value: selection)
    }
    
    init<Data, ID, ElementContent>(_ data: Binding<Data>,
                                   id: KeyPath<Data.Element, ID>,
                                   accessory: ScrollAccessory = .automatic,
                                   selection: Binding<Set<SelectionValue>>?,
                                   @ViewBuilder content: @escaping (Binding<Data.Element>) -> ElementContent)
    where
    Data : MutableCollection,
    Data : RandomAccessCollection,
    Data.Element : Indexable,
    Data.Index : Hashable,
    ID : Hashable,
    ElementContent : View,
    Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, ElementContent>
    {
        self.accessory = accessory
        self.content = { ForEach(data, id: id, content: content) }
        self.indices = data.wrappedValue.compactMap(\.index)
        self.selection = .multiple(value: selection)
    }
    
    init<Data, ElementContent>(_ data: Binding<Data>,
                               accessory: ScrollAccessory = .automatic,
                               selection: Binding<SelectionValue?>?,
                               @ViewBuilder content: @escaping (Binding<Data.Element>) -> ElementContent)
    where
    Data : MutableCollection,
    Data : RandomAccessCollection,
    Data.Element : Identifiable,
    Data.Element : Indexable,
    Data.Index : Hashable,
    ElementContent : View,
    Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, ElementContent>
    {
        self.accessory = accessory
        self.content = { ForEach(data, content: content) }
        self.indices = data.wrappedValue.compactMap(\.index)
        self.selection = .single(value: selection)
    }
    
    init<Data, ElementContent>(_ data: Binding<Data>,
                               accessory: ScrollAccessory = .automatic,
                               selection: Binding<Set<SelectionValue>>?,
                               @ViewBuilder content: @escaping (Binding<Data.Element>) -> ElementContent)
    where
    Data : MutableCollection,
    Data : RandomAccessCollection,
    Data.Element : Identifiable,
    Data.Element : Indexable,
    Data.Index : Hashable,
    ElementContent : View,
    Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, ElementContent>
    {
        self.accessory = accessory
        self.content = { ForEach(data, content: content) }
        self.indices = data.wrappedValue.compactMap(\.index)
        self.selection = .multiple(value: selection)
    }
}


public extension IndexedList
where SelectionValue == Never
{
    init(accessory: ScrollAccessory = .automatic,
         indices: Indices,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.accessory = accessory
        self.content = content
        self.indices = indices
        self.selection = .none
    }
}


public extension IndexedList
where SelectionValue == Never,
      Indices == [Index]
{
    init<Data, ID, ElementContent>(_ data: Data,
                                   id: KeyPath<Data.Element, ID>,
                                   accessory: ScrollAccessory = .automatic,
                                   @ViewBuilder content: @escaping (Data.Element) -> ElementContent)
    where
    Data : RandomAccessCollection,
    Data.Element : Indexable,
    ID : Hashable,
    ElementContent : View,
    Content == ForEach<Data, ID, ElementContent>
    {
        self.accessory = accessory
        self.content = { ForEach(data, id: id, content: content) }
        self.indices = data.compactMap(\.index)
        self.selection = .none
    }
    
    init<Data, ElementContent>(_ data: Data,
                               accessory: ScrollAccessory = .automatic,
                               @ViewBuilder content: @escaping (Data.Element) -> ElementContent)
    where
    Data : RandomAccessCollection,
    Data.Element : Identifiable,
    Data.Element : Indexable,
    ElementContent : View,
    Content == ForEach<Data, Data.Element.ID, ElementContent>
    {
        self.accessory = accessory
        self.content = { ForEach(data, content: content) }
        self.indices = data.compactMap(\.index)
        self.selection = .none
    }
    
    init<Data, ID, ElementContent>(_ data: Binding<Data>,
                                   id: KeyPath<Data.Element, ID>,
                                   accessory: ScrollAccessory = .automatic,
                                   @ViewBuilder content: @escaping (Binding<Data.Element>) -> ElementContent)
    where
    Data : MutableCollection,
    Data : RandomAccessCollection,
    Data.Element : Indexable,
    Data.Index : Hashable,
    ID : Hashable,
    ElementContent : View,
    Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, ID)>, ID, ElementContent>
    {
        self.accessory = accessory
        self.content = { ForEach(data, id: id, content: content) }
        self.indices = data.wrappedValue.compactMap(\.index)
        self.selection = .none
    }
    
    init<Data, ElementContent>(_ data: Binding<Data>,
                               accessory: ScrollAccessory = .automatic,
                               @ViewBuilder content: @escaping (Binding<Data.Element>) -> ElementContent)
    where
    Data : MutableCollection,
    Data : RandomAccessCollection,
    Data.Element : Identifiable,
    Data.Element : Indexable,
    Data.Index : Hashable,
    ElementContent : View,
    Content == ForEach<LazyMapSequence<Data.Indices, (Data.Index, Data.Element.ID)>, Data.Element.ID, ElementContent>
    {
        self.accessory = accessory
        self.content = { ForEach(data, content: content) }
        self.indices = data.wrappedValue.compactMap(\.index)
        self.selection = .none
    }
}


private extension IndexedList {
    enum Selection {
        case none
        case single(value: Binding<SelectionValue?>?)
        case multiple(value: Binding<Set<SelectionValue>>?)
    }
}
