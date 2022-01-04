# SwiftUIIndexedList

Add an index bar to a SwiftUI `List` or `ScrollView`.

## Getting Started

Conform your data source to `Indexable` and `Identifiable`. Then replace `List` with `IndexedList`, or `ScrollView` with `IndexedScrollView`:

```swift
IndexedList(data) { element in
    Section {
        //Your section content
    } header: {
        //Your header content
            .id(element.id)
    }
}
```

## Requirements

* iOS 14.0+
* Xcode 13.0+

## Installation

* Install with [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).
* Import `SwiftUIIndexedList` to start using.

## Contact

[@ciaranrobrien](https://twitter.com/ciaranrobrien) on Twitter.
