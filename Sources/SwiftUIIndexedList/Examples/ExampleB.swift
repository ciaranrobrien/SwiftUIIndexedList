/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

private struct ContentView: View {
    @State private var selection = Set<FooRow.ID>()
    
    var rows: [FooRow]
    
    var body: some View {
        let sections = sections
        let indices = indices(for: sections)
        
        IndexedList(indices: indices, selection: $selection) {
            Section {
                /// Add Button
            } header: {
                Text("Add")
                    .id(topSectionID)
            }
            
            ForEach(sections) { section in
                Section {
                    ForEach(section.rows) { row in
                        /// Row View
                    }
                } header: {
                    Text(section.title)
                        .id(section.id)
                }
            }
        }
    }
    
    private let topSectionID = "Add"
    
    private var sections: [FooSection] {
        rows
            .sorted { $0.title < $1.title }
            .reduce(into: [FooSection]()) { sections, row in
                guard let character = row.title.first
                else { return }
                
                let sectionTitle = character.isLetter ? String(character).localizedUppercase : "#"
                
                if let sectionIndex = sections.firstIndex(where: { $0.title == sectionTitle }) {
                    sections[sectionIndex].rows.append(row)
                } else {
                    let section = FooSection(rows: [row], title: sectionTitle)
                    sections.append(section)
                }
            }
    }
    
    private func indices(for sections: [FooSection]) -> [Index] {
        sections.reduce(into: [Index]()) { indices, section in
            if indices.isEmpty {
                let topIndex = Index(
                    "Add",
                    systemImage: "plus",
                    displayPriority: .increased, /// Prevent truncating this section in the index bar when vertical space is limited
                    contentID: topSectionID
                )
                indices.append(topIndex)
            }
            
            let index = Index(
                section.title,
                displayPriority: section.title == "#" ? .increased : .standard,
                contentID: section.id
            )
            indices.append(index)
        }
    }
}


private struct FooRow: Identifiable {
    let id: UUID
    let title: String
}


private struct FooSection: Identifiable {
    var rows: [FooRow]
    let title: String
    
    var id: String { title }
}
