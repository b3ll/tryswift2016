//
//  UIVerticalPanGestureRecognizer.swift
//  Arcanine
//
//  Created by Adam Bell on 2/25/16.
//  Copyright © 2016 Adam Bell. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class UIVerticalPanGestureRecognizer: UIPanGestureRecognizer {

  override var state: UIGestureRecognizerState {
    set(state) {
      let translation = translationInView(view)
      if fabs(translation.x) >= fabs(translation.y) && state == .Began {
        super.state = .Failed
      } else {
        super.state = state
      }
    }
    get {
      return super.state
    }
  }

}
