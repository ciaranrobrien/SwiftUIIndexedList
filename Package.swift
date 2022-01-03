// swift-tools-version:5.5

/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import PackageDescription

let package = Package(
    name: "SwiftUIIndexedList",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SwiftUIIndexedList",
            targets: ["SwiftUIIndexedList"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftUIIndexedList",
            dependencies: []
        )
    ]
)
