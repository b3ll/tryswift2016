//: Playground - noun: a place where people can play

import Pokemon
import pop
import SwiftyGestureRecognition
import UIKit
import XCPlayground

let bounds = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 568.0)
let window = UIView(frame: bounds)
window.backgroundColor = UIColor.whiteColor()

let pokeballSize = CGSize(width: 80.0, height: 80.0)
let pokeballFrame = CGRect(x: floor((bounds.size.width - pokeballSize.width) / 2.0), y: bounds.size.height - pokeballSize.height, width: pokeballSize.width, height: pokeballSize.height)
let pokeball = Pokeball(frame: pokeballFrame)
window.addSubview(pokeball)

func pokeballHitGround(pokeball: Pokeball) -> Bool {
  guard let throwAnimation = pokeball.pop_animationForKey(kPOPViewCenter) as? POPSpringAnimation else { return false }

  if throwAnimation.velocity.CGPointValue().y < 0.0 {
    return false
  }

  if pokeball.center.y < window.center.y {
    return false
  }

  return true
}

let gestureRecognizer = UIPanGestureRecognizer(view: pokeball)
  .didBegin { (gestureRecognizer) in
    (gestureRecognizer as! UIPanGestureRecognizer).setTranslation(CGPointZero, inView: window)
    pokeball.pop_removeAnimationForKey(kPOPViewCenter)
  }
  .didChange { (gestureRecognizer) in
    let location = gestureRecognizer.locationInView(window)
    pokeball.center = location
  }
  .didEnd { (gestureRecognizer) in
    let velocity = (gestureRecognizer as! UIPanGestureRecognizer).velocityInView(window)
    
    let throwAnimation = POPSpringAnimation(propertyNamed: kPOPViewCenter)
    throwAnimation.velocity = NSValue(CGPoint: velocity)
    throwAnimation.toValue = NSValue(CGPoint: window.center)
    throwAnimation.dynamicsFriction = 0.1
    throwAnimation.dynamicsMass = 0.5
    throwAnimation.dynamicsTension = 10
    throwAnimation.animationDidApplyBlock = { (anim: POPAnimation!) in
      if pokeballHitGround(pokeball).boolValue == false {
        return
      }
//
      pokeball.pop_removeAnimationForKey(kPOPViewCenter)
      pokeball.layer.pop_removeAnimationForKey(kPOPLayerRotation)
//
      pokeball.explode()
//
      dispatchAfter(0.5) {
        pokeball.reset()
        pokeball.frame = pokeballFrame
      }
    }
    pokeball.pop_addAnimation(throwAnimation, forKey: kPOPViewCenter)

    let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
    scaleAnimation.duration = 0.8
    scaleAnimation.toValue = NSValue(CGPoint: CGPoint(x: 0.8, y: 0.8))
    scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    pokeball.layer.pop_addAnimation(scaleAnimation, forKey: kPOPLayerScaleXY)

    POPLayerSetRotation(pokeball.layer, CGFloat(M_PI * 100.0))
    let spinAnimation = POPDecayAnimation(propertyNamed: kPOPLayerRotation)
    spinAnimation.velocity = 100.0
    pokeball.layer.pop_addAnimation(spinAnimation, forKey: kPOPLayerRotation)
}

XCPlaygroundPage.currentPage.liveView = window
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
