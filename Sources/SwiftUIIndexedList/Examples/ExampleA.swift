/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Pass in data from a parent view, view model, `FetchRequest`, `Query` etc.
private struct ContentView: View {
    var rows: [FooRow]
    
    var body: some View {
        IndexedList(sections) { section in
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
    
    private var sections: [FooSection] {
        rows
            .sorted { $0.title < $1.title }
            .reduce(into: [FooSection]()) { sections, row in
                let sectionTitle = row.title.prefix(1).localizedUppercase
                
                guard !sectionTitle.isEmpty
                else { return }
                
                if let lastIndex = sections.indices.last,
                   sections[lastIndex].title == sectionTitle
                {
                    sections[lastIndex].rows.append(row)
                } else {
                    let section = FooSection(rows: [row], title: sectionTitle)
                    sections.append(section)
                }
            }
    }
}


private struct FooRow: Identifiable {
    let id: UUID
    let title: String
}


private struct FooSection: Identifiable, Indexable {
    var rows: [FooRow]
    let title: String
    
    var id: String {
        title
    }
    var index: Index? {
        Index(title, contentID: id)
    }
}
