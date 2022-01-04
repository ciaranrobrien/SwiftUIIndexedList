/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct IndexedScrollView<Indices, Content>: View
where Indices : Equatable,
      Indices : RandomAccessCollection,
      Indices.Element == Index,
      Content : View
{
    public var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.vertical, showsIndicators: accessory.showsScrollIndicator(indices: indices)) {
                VStack(content: content)
                    .frame(maxWidth: .infinity)
            }
            .overlay(IndexBar(accessory: accessory, indices: indices, scrollView: scrollView))
            .environment(\.internalIndexBarInsets, accessory.showsIndexBar(indices: indices) ? indexBarInsets : nil)
        }
    }
    
    private var accessory: ScrollAccessory
    private var content: () -> Content
    private var indices: Indices
}


public extension IndexedScrollView {
    init(accessory: ScrollAccessory = .automatic,
         indices: Indices,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.accessory = accessory
        self.content = content
        self.indices = indices
    }
}


public extension IndexedScrollView
where Indices == [Index]
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
    }
}
