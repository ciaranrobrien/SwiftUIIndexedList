/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import UIKit

internal extension UIView {
    func firstUITableView() -> UIScrollView? {
        for subview in subviews {
            if let scrollView = subview as? UITableView {
                return scrollView
            }
            else if let scrollView = subview.firstUITableView() {
                return scrollView
            }
        }
        
        return nil
    }
}
