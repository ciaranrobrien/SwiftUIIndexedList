/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct IndexBar<Indices>: View
where Indices : Equatable,
      Indices : RandomAccessCollection,
      Indices.Element == Index
{
    var accessory: ScrollAccessory
    var indices: Indices
    var scrollView: ScrollViewProxy
    
    var body: some View {
        GeometryReader { geometry in
            if accessory.showsIndexBar(indices: indices) {
                IndexReducer(frameHeight: geometry.size.height,
                             indices: indices,
                             scrollView: scrollView)
                    .transition(.identity)
            }
        }
    }
}


internal var indexBarInsets: EdgeInsets {
    EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: labelSize.width)
}


private struct IndexReducer<Indices>: View
where Indices : Equatable,
      Indices : RandomAccessCollection,
      Indices.Element == Index
{
    var frameHeight: CGFloat
    var indices: Indices
    var scrollView: ScrollViewProxy
    
    var body: some View {
        IndexLayout(frameHeight: frameHeight,
                    indices: indices,
                    reducedIndices: reducedIndices,
                    scrollView: scrollView)
    }
    
    private var reducedIndices: [Index] {
        var innerIndices = Array(indices)
        let indexTarget = max(Int(floor((frameHeight - (stackPadding * 2)) / labelSize.height)), 2)
        
        if innerIndices.count <= indexTarget {
            return innerIndices
        }
        
        //Separate leading and trailing increased priority indices
        var leadingIndices: [Index] = []
        var trailingIndices: [Index] = []
        
        while innerIndices.first?.displayPriority == .increased {
            leadingIndices.append(innerIndices.removeFirst())
        }
        
        while innerIndices.last?.displayPriority == .increased {
            trailingIndices.insert(innerIndices.removeLast(), at: 0)
        }
        
        //Ignore priority if target is too low
        if leadingIndices.count + trailingIndices.count + min(innerIndices.count, 3) > indexTarget {
            leadingIndices = []
            trailingIndices = []
            innerIndices = Array(indices)
        }
        
        if !innerIndices.isEmpty {
            trailingIndices.insert(innerIndices.removeLast(), at: 0)
        }
        
        if innerIndices.count > 1 {
            //Set inner index target and ensure it's even
            var innerIndexTarget = indexTarget - leadingIndices.count - trailingIndices.count
            if innerIndexTarget > 2 && innerIndexTarget % 2 != 0 {
                innerIndexTarget -= 1
            }
            
            //Evenly remove indices to reach target
            let skipLimit = Double(innerIndexTarget) / Double(innerIndices.count + 1 - innerIndexTarget)
            var skipCount: Double = 0
            
            innerIndices = innerIndices
                .reduce([]) { array, index in
                    if skipCount > skipLimit {
                        skipCount -= skipLimit
                        return array
                    } else {
                        skipCount += 1
                        return array + [index]
                    }
                }
                .enumerated()
                .map {
                    $0.offset % 2 == 0
                    ? $0.element
                    : Index(separatorWith: $0.element.contentID)
                }
        }
        
        return leadingIndices + innerIndices + trailingIndices
    }
}


private struct IndexLayout<Indices>: View
where Indices : Equatable,
      Indices : RandomAccessCollection,
      Indices.Element == Index
{
    @GestureState private var currentIndex: Index? = nil
    
    var frameHeight: CGFloat
    var indices: Indices
    var reducedIndices: [Index]
    var scrollView: ScrollViewProxy
    
    var body: some View {
        IndexStack(frameHeight: frameHeight, reducedIndices: reducedIndices)
            .frame(width: max(24, labelSize.width), alignment: .trailing)
            .frame(maxHeight: .infinity)
            .background(
                Color.white
                    .opacity(0)
                    .contentShape(Rectangle())
                    .ignoresSafeArea(edges: .trailing)
            )
            .background(IndexBarBackgroundView(stackHeight: stackHeight), alignment: .trailing)
            .highPriorityGesture(dragGesture)
            .onChange(of: currentIndex, perform: onCurrentIndex)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($currentIndex, body: dragUpdating)
    }
    private var stackHeight: CGFloat {
        CGFloat(reducedIndices.count) * labelSize.height
    }
    
    private func dragUpdating(value: DragGesture.Value, currentIndex: inout Index?, transaction: inout Transaction) {
        guard !indices.isEmpty else { return }
        
        let dragLocation = value.location.y + ((stackHeight - frameHeight) / 2)
        let unboundOffset = Int(floor(dragLocation * CGFloat(indices.count) / stackHeight))
        let offset = max(min(unboundOffset, indices.count - 1), 0)
        
        currentIndex = indices
            .enumerated()
            .first { $0.offset == offset }?
            .element
    }
    private func onCurrentIndex(_ currentIndex: Index?) {
        if let currentIndex = currentIndex {
            scrollView.scrollTo(currentIndex.contentID, anchor: .topTrailing)
            selectionFeedbackGenerator.selectionChanged()
        }
    }
}


private struct IndexStack: View {
    var frameHeight: CGFloat
    var reducedIndices: [Index]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(reducedIndices, id: \.contentID) { index in
                index.label()
                    .frame(width: labelSize.width, height: labelSize.height)
                    .transition(.identity)
            }
        }
        .font(.system(size: 11).weight(.semibold))
        .imageScale(.medium)
        .labelStyle(.iconOnly)
        .foregroundColor(.accentColor)
        .multilineTextAlignment(.center)
        .animation(nil, value: frameHeight)
    }
}


private struct IndexBarBackgroundView: View {
    @Environment(\.indexBarBackground) private var background

    var stackHeight: CGFloat
    
    var body: some View {
        background.view()
            .frame(width: labelSize.width, height: height)
    }
    
    private var height: CGFloat? {
        switch background.contentMode {
        case .fit: return stackHeight + (stackPadding * 2)
        case .fill: return nil
        }
    }
}


private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()


private var labelSize: CGSize {
    switch UIDevice.current.userInterfaceIdiom {
    case .phone: return CGSize(width: 15, height: 14)
    case .pad: return CGSize(width: 30, height: 24)
    default: fatalError("Unsupported UserInterfaceIdiom \(UIDevice.current.userInterfaceIdiom).")
    }
}
private var stackPadding: CGFloat {
    switch UIDevice.current.userInterfaceIdiom {
    case .phone: return 3
    case .pad: return 6
    default: fatalError("Unsupported UserInterfaceIdiom \(UIDevice.current.userInterfaceIdiom).")
    }
}
