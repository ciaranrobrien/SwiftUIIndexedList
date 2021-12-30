//
//  IndexedScrollView.swift
//
//
//  Created by Ciaran O'Brien on 30/12/2021.
//

import SwiftUI

public struct IndexedScrollView<SectionLabels, Content>: View
where SectionLabels : RandomAccessCollection,
      SectionLabels.Element == SectionLabel,
      Content : View
{
    init(sectionLabels: SectionLabels, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.sectionLabels = sectionLabels
    }
    
    public var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(content: content)
                    .frame(maxWidth: .infinity)
            }
            .overlay(IndexBar(sectionLabels: sectionLabels, scrollView: scrollView), alignment: .trailing)
        }
    }
    
    private var content: () -> Content
    private var sectionLabels: SectionLabels
}
