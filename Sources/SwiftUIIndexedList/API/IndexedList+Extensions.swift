//
//  IndexedList+Extensions.swift
//  
//
//  Created by Ciaran O'Brien on 30/12/2021.
//

import SwiftUI

public extension IndexedList
where SelectionValue == Never
{
    init(sectionLabels: SectionLabels, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.sectionLabels = sectionLabels
        self.selection = .none
    }
}
