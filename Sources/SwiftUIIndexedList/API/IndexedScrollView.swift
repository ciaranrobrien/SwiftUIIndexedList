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
    public init(accessory: ScrollAccessory = .automatic,
                indices: Indices,
                @ViewBuilder content: @escaping () -> Content)
    {
        self.accessory = accessory
        self.content = content
        self.indices = indices
    }
    
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
    
    internal var accessory: ScrollAccessory
    internal var content: () -> Content
    internal var indices: Indices
}
