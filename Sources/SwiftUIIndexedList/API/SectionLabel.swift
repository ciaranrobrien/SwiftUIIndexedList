//
//  SectionLabel.swift
//  
//
//  Created by Ciaran O'Brien on 30/12/2021.
//

import SwiftUI

public struct SectionLabel: Equatable, Identifiable {
    init<ID: Hashable>(id: ID, title: String, image name: String? = nil) {
        self.id = AnyHashable(id)
        self.image = name
        self.systemImage = nil
        self.title = title
        self.titleKey = nil
    }
    init<ID: Hashable>(id: ID, title: String, systemImage name: String) {
        self.id = AnyHashable(id)
        self.image = nil
        self.systemImage = name
        self.title = title
        self.titleKey = nil
    }
    init<ID: Hashable>(id: ID, titleKey: LocalizedStringKey, image name: String? = nil) {
        self.id = AnyHashable(id)
        self.image = name
        self.systemImage = nil
        self.title = nil
        self.titleKey = titleKey
    }
    init<ID: Hashable>(id: ID, titleKey: LocalizedStringKey, systemImage name: String) {
        self.id = AnyHashable(id)
        self.image = nil
        self.systemImage = name
        self.title = nil
        self.titleKey = titleKey
    }
    
    public let id: AnyHashable
    private let image: String?
    private let systemImage: String?
    private let title: String?
    private let titleKey: LocalizedStringKey?
    
    @ViewBuilder internal func view() -> some View {
        if let title = title {
            if let image = image {
                Label {
                    Text(title)
                } icon: {
                    Image(image)
                        .renderingMode(.template)
                }
            }
            else if let systemImage = systemImage {
                Label {
                    Text(title)
                } icon: {
                    Image(systemName: systemImage)
                        .renderingMode(.template)
                }
            }
            else {
                Text(title)
            }
        }
        else if let titleKey = titleKey {
            if let image = image {
                Label {
                    Text(titleKey)
                } icon: {
                    Image(image)
                        .renderingMode(.template)
                }
            }
            else if let systemImage = systemImage {
                Label {
                    Text(titleKey)
                } icon: {
                    Image(systemName: systemImage)
                        .renderingMode(.template)
                }
            }
            else {
                Text(titleKey)
            }
        }
    }
}
