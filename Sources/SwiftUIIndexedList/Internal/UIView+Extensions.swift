/**
*  SwiftUIIndexedList
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import UIKit

internal extension UIView {
    func firstUIScrollView() -> UIScrollView? {
        for subview in subviews {
            if let scrollView = subview as? UIScrollView {
                return scrollView
            }
            else if let scrollView = subview.firstUIScrollView() {
                return scrollView
            }
        }
        
        return nil
    }
}
