
import Foundation
import SwiftyGestureRecognition
import XCPlayground

let bounds = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 568.0)
let window = UIView(frame: bounds)
window.backgroundColor = UIColor.whiteColor()

let tapGestureRecognizer = UITapGestureRecognizer(view: window).didEnd { (gestureRecognizer) in
  print("ohai")
}

XCPlaygroundPage.currentPage.liveView = window
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
