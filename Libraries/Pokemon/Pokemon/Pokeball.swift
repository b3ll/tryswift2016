import Foundation
import pop
import UIKit

public class Pokeball: UIView {
  public class PokeballHalf: CALayer {
    var tintColor = UIColor.whiteColor() {
      didSet {
        self.setNeedsDisplay()
      }
    }
    
    public override func drawInContext(ctx: CGContext) {
      super.drawInContext(ctx)
      
      CGContextSetFillColorWithColor(ctx, tintColor.CGColor)
      CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
      CGContextSetAllowsAntialiasing(ctx, true)
      
      let lineWidth: CGFloat = floor(8.0 * (bounds.size.width / 100.0))
      CGContextSetLineWidth(ctx, lineWidth)
      
      let padding: CGFloat = floor(lineWidth / 1.5)
      
      let bigRadius = floor(bounds.size.width / 2.0)
      let bigArc = UIBezierPath(arcCenter: CGPoint(x: bigRadius, y: bounds.size.height), radius: bigRadius - padding, startAngle: CGFloat(0.0), endAngle: CGFloat(M_PI), clockwise: false)
      bigArc.closePath()
      CGContextAddPath(ctx, bigArc.CGPath)
      CGContextFillPath(ctx)
      
      CGContextAddPath(ctx, bigArc.CGPath)
      CGContextStrokePath(ctx)
      
      let smallRadius: CGFloat = floor(10.0 * (bounds.size.width / 100.0))
      let smallArc = UIBezierPath(arcCenter: CGPoint(x: bigRadius, y: bounds.size.height), radius: smallRadius, startAngle: CGFloat(0.0), endAngle: CGFloat(M_PI), clockwise: false)
      smallArc.closePath()
      
      CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor)
      
      CGContextAddPath(ctx, smallArc.CGPath)
      CGContextStrokePath(ctx)
      
      CGContextAddPath(ctx, smallArc.CGPath)
      CGContextFillPath(ctx)
    }
  }
  
  public lazy var topHalf: PokeballHalf = {
    let topHalf = PokeballHalf()
    topHalf.tintColor = UIColor.pokeballRed()
    topHalf.masksToBounds = false
    topHalf.rasterizationScale = UIScreen.mainScreen().scale
    topHalf.shouldRasterize = true
    self.layer.addSublayer(topHalf)
    return topHalf
  }()
  
  public lazy var bottomHalf: PokeballHalf = {
    let bottomHalf = PokeballHalf()
    bottomHalf.tintColor = UIColor.whiteColor()
    bottomHalf.masksToBounds = false
    bottomHalf.transform = CATransform3DMakeScale(1.0, -1.0, 1.0)
    bottomHalf.rasterizationScale = UIScreen.mainScreen().scale
    bottomHalf.shouldRasterize = true
    self.layer.addSublayer(bottomHalf)
    return bottomHalf
  }()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    
    layer.rasterizationScale = UIScreen.mainScreen().scale
    layer.shouldRasterize = true
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    
    topHalf.position = CGPoint(x: floor(bounds.size.height / 2.0), y: floor(bounds.size.height / 4.0))
    topHalf.bounds = CGRectMake(0.0, 0.0, bounds.size.width, floor(bounds.size.height / 2.0))
    
    bottomHalf.position = CGPoint(x: floor(bounds.size.height / 2.0), y: floor(bounds.size.height * 0.75))
    bottomHalf.bounds = topHalf.bounds
  }
  
  public func explode() {
    //POPLayerSetRotation(topHalf, CGFloat(M_PI * 100.0))
    //POPLayerSetRotation(bottomHalf, CGFloat(M_PI * 100.0))
    
    let topHalfSpinAnimation = POPDecayAnimation(propertyNamed: kPOPLayerRotation)
    topHalfSpinAnimation.velocity = 15
    topHalf.pop_addAnimation(topHalfSpinAnimation, forKey: kPOPLayerRotation)
    
    let bottomHalfSpinAnimation = POPDecayAnimation(propertyNamed: kPOPLayerRotation)
    bottomHalfSpinAnimation.velocity = -15
    bottomHalf.pop_addAnimation(bottomHalfSpinAnimation, forKey: kPOPLayerRotation)
    
    let velocity: CGFloat = 190.0
    let offscreenAmount: CGFloat = 568.0
    
    let mass: CGFloat = 1.0
    let tension: CGFloat = 150
    let friction: CGFloat = 40
    
    let topHalfThrowAnimation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
    topHalfThrowAnimation.toValue = NSValue(CGPoint: CGPoint(x: -offscreenAmount, y: 0.0))
    topHalfThrowAnimation.velocity = NSValue(CGPoint: CGPoint(x: -velocity, y: velocity))
    topHalfThrowAnimation.dynamicsMass = mass
    topHalfThrowAnimation.dynamicsTension = tension
    topHalfThrowAnimation.dynamicsFriction = friction
    topHalf.pop_addAnimation(topHalfThrowAnimation, forKey: kPOPLayerTranslationXY)
    
    let bottomHalfThrowAnimation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
    bottomHalfThrowAnimation.toValue = NSValue(CGPoint: CGPoint(x: offscreenAmount, y: 0.0))
    bottomHalfThrowAnimation.velocity = NSValue(CGPoint: CGPoint(x: velocity, y: velocity))
    bottomHalfThrowAnimation.dynamicsMass = mass
    bottomHalfThrowAnimation.dynamicsTension = tension
    bottomHalfThrowAnimation.dynamicsFriction = friction
    bottomHalf.pop_addAnimation(bottomHalfThrowAnimation, forKey: kPOPLayerTranslationXY)
  }
  
  public func unexplode() {
    topHalf.pop_removeAllAnimations()
    bottomHalf.pop_removeAllAnimations()

    UIView.animateWithDuration(0.0) { 
      self.topHalf.transform = CATransform3DIdentity
      self.topHalf.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
      
      self.bottomHalf.transform = CATransform3DIdentity
      self.bottomHalf.transform = CATransform3DMakeScale(1.0, -1.0, 1.0)
      
      self.topHalf.removeAllAnimations()
      self.bottomHalf.removeAllAnimations()
    }
    
    setNeedsLayout()
  }

  public func reset() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    unexplode()
    layer.transform = CATransform3DIdentity
    CATransaction.commit()
  }
}
