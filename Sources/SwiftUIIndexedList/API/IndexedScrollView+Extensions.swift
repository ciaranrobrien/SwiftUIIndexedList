/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

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
}
