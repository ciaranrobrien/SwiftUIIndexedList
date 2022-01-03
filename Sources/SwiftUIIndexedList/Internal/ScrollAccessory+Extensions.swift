/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import Foundation

internal extension ScrollAccessory {
    func showsIndexBar<Indices>(indices: Indices) -> Bool
    where Indices : RandomAccessCollection
    {
        switch self {
        case .automatic: return !indices.isEmpty
        case .indexBar: return true
        case .scrollIndicator: return false
        case .none: return false
        }
    }
    
    func showsScrollIndicator<Indices>(indices: Indices) -> Bool
    where Indices : RandomAccessCollection
    {
        switch self {
        case .automatic: return indices.isEmpty
        case .indexBar: return false
        case .scrollIndicator: return true
        case .none: return false
        }
    }
}
