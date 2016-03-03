//
//  Utils.swift
//  Arcanine
//
//  Created by Adam Bell on 2/24/16.
//  Copyright © 2016 Adam Bell. All rights reserved.
//

import Foundation

public func dispatchAfter(delay: NSTimeInterval, block:(() -> ())) {
  let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * NSTimeInterval(NSEC_PER_SEC)))
  dispatch_after(dispatchTime, dispatch_get_main_queue(), block)
}
