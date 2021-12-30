//
//  IndexBar.swift
//  
//
//  Created by Ciaran O'Brien on 30/12/2021.
//

import SwiftUI

internal struct IndexBar<SectionLabels>: View
where SectionLabels : RandomAccessCollection,
      SectionLabels.Element == SectionLabel
{
    @State private var selectedLabel: SectionLabel? = nil
    
    var sectionLabels: SectionLabels
    var scrollView: ScrollViewProxy
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(sectionLabels) { sectionLabel in
                sectionLabel.view()
            }
            .frame(width: 16, height: titleHeight)
        }
        .font(.system(size: 11).weight(.semibold))
        .imageScale(.medium)
        .foregroundColor(.accentColor)
        .multilineTextAlignment(.center)
        .frame(width: 32, alignment: .trailing)
        .background(Color.red)
        .contentShape(Rectangle())
        .highPriorityGesture(dragGesture)
        .accessibilityLargeContentView {
            selectedLabel?.view()
        }
    }
    
    private let titleHeight: CGFloat = 14
    private let selectionFeedback = UISelectionFeedbackGenerator()
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged(dragChanged)
            .onEnded(dragEnded)
    }
    
    private func dragChanged(_ value: DragGesture.Value) {
        let unboundOffset = Int(floor(value.location.y / titleHeight))
        let offset = max(min(unboundOffset, sectionLabels.count - 1), 0)
        let label = sectionLabels
            .enumerated()
            .first { $0.offset == offset }?
            .element
        
        if let label = label, selectedLabel?.id != label.id {
            selectedLabel = label
            scrollView.scrollTo(label.id, anchor: .topTrailing)
            selectionFeedback.selectionChanged()
        }
    }
    private func dragEnded(_ value: DragGesture.Value) {
        selectedLabel = nil
    }
}
