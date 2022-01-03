/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public struct Index: Equatable {
    public init<ID>(id: ID,
             title: String,
             displayPriority: DisplayPriority = .standard)
    where ID : Hashable
    {
        self.displayPriority = displayPriority
        self.id = AnyHashable(id)
        self.image = nil
        self.text = Text(title)
    }
    
    public init<ID>(id: ID,
             image name: String,
             displayPriority: DisplayPriority = .standard)
    where ID : Hashable
    {
        self.displayPriority = displayPriority
        self.id = AnyHashable(id)
        self.image = Image(name)
        self.text = nil
    }
    
    public init<ID>(id: ID,
             systemImage name: String,
             displayPriority: DisplayPriority = .standard)
    where ID : Hashable
    {
        self.displayPriority = displayPriority
        self.id = AnyHashable(id)
        self.image = Image(systemName: name)
        self.text = nil
    }
    
    public enum DisplayPriority: Equatable, Hashable {
        case standard
        case increased
    }
    
    internal let displayPriority: DisplayPriority
    internal let id: AnyHashable
    
    private let image: Image?
    private let text: Text?
}


internal extension Index {
    init(separatorWith id: AnyHashable) {
        self.displayPriority = .standard
        self.id = id
        self.image = nil
        self.text = nil
    }
    
    @ViewBuilder func label() -> some View {
        if let image = image {
            image
        } else if let text = text {
            text
        } else {
            Circle()
                .frame(width: 6, height: 6)
        }
    }
}
