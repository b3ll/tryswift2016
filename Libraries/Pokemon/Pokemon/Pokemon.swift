//
//  Pokemon.swift
//  Arcanine
//
//  Created by Adam Bell on 2/23/16.
//  Copyright © 2016 Adam Bell. All rights reserved.
//

import Foundation

public struct Pokemon {

  public let ID: Int
  public let name: String
  public var image: UIImage? {
    get {
      return UIImage(named: "\(ID).png", inBundle:NSBundle(forClass: Pokedex.self), compatibleWithTraitCollection: nil)
    }
  }

}
