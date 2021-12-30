//
//  IndexedList.swift
//  
//
//  Created by Ciaran O'Brien on 30/12/2021.
//

import SwiftUI

public struct IndexedList<SelectionValue, SectionLabels, Content>: View
where SelectionValue : Hashable,
      SectionLabels : RandomAccessCollection,
      SectionLabels.Element == SectionLabel,
      Content : View
{
    public init(selection: Binding<SelectionValue?>?,
         sectionLabels: SectionLabels,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.content = content
        self.sectionLabels = sectionLabels
        self.selection = .single(value: selection)
    }
    
    public init(selection: Binding<Set<SelectionValue>>?,
         sectionLabels: SectionLabels,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.content = content
        self.sectionLabels = sectionLabels
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
            .background(UITableViewCustomizer())
            .overlay(IndexBar(sectionLabels: sectionLabels, scrollView: scrollView), alignment: .trailing)
        }
    }
    
    internal var content: () -> Content
    internal var sectionLabels: SectionLabels
    internal var selection: Selection
    
    internal enum Selection {
        case none
        case single(value: Binding<SelectionValue?>?)
        case multiple(value: Binding<Set<SelectionValue>>?)
    }
}
