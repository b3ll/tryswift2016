//
//  UIWindow+Flash.swift
//  Arcanine
//
//  Created by Adam Bell on 2/26/16.
//  Copyright © 2016 Adam Bell. All rights reserved.
//

import UIKit

public extension UIWindow {

  public func flash() {
    let flashView = UIView(frame: bounds)
    flashView.userInteractionEnabled = false
    flashView.backgroundColor = UIColor.whiteColor()
    addSubview(flashView)
    
    UIView.animateWithDuration(0.75, delay: 0.0, options: .CurveEaseOut, animations: {
        flashView.alpha = CGFloat(0.0)
    }, completion: { (finished) in
      flashView.removeFromSuperview()
    })
  }
  
}
