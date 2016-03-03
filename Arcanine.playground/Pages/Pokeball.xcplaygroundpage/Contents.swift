//: [Previous](@previous)

import Foundation
import UIKit
import XCPlayground

let bounds = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 568.0)
let window = UIView(frame: bounds)
window.backgroundColor = UIColor.whiteColor()

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
    topHalf.tintColor = UIColor.redColor()
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
}

let pokeball = Pokeball(frame: CGRect(x: 0, y: 0, width: 320.0, height: 320.0))
window.addSubview(pokeball)

XCPlaygroundPage.currentPage.liveView = window
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

