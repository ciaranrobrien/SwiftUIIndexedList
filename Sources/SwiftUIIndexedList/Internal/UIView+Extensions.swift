/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import UIKit

internal extension UIView {
    func firstUITableView() -> UITableView? {
        for subview in subviews {
            if let tableView = subview as? UITableView {
                return tableView
            }
            else if let tableView = subview.firstUITableView() {
                return tableView
            }
        }
        
        return nil
    }
}
