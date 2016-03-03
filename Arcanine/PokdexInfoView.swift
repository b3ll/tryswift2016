//
//  PokdexInfoView.swift
//  Arcanine
//
//  Created by Adam Bell on 2/24/16.
//  Copyright © 2016 Adam Bell. All rights reserved.
//

import Pokemon
import UIKit

public class PokedexInfoView: UIView {
  
  public var pokemon: Pokemon? {
    didSet {
      updatePokedexInfo()
    }
  }
  
  private let pokemonImageViewSize = CGSize(width: 250.0, height: 250.0)
  
  private lazy var pokemonImageView: UIImageView = {
    let pokemonImageView = UIImageView(frame: CGRectZero)
    pokemonImageView.contentMode = .ScaleAspectFill
    pokemonImageView.backgroundColor = UIColor.clearColor()
    pokemonImageView.layer.magnificationFilter = kCAFilterNearest
    self.addSubview(pokemonImageView)
    return pokemonImageView
  }()
  
  
  private lazy var pokemonNameLabel: UILabel = {
    let pokemonNameLabel = UILabel()
    pokemonNameLabel.font = UIFont.boldSystemFontOfSize(30.0)
    pokemonNameLabel.textColor = UIColor.blackColor()
    pokemonNameLabel.textAlignment = .Center
    self.addSubview(pokemonNameLabel)
    return pokemonNameLabel
  }()
  
  private func updatePokedexInfo() {
    pokemonImageView.image = pokemon?.image
    pokemonNameLabel.text = pokemon?.name.capitalizedString
    setNeedsLayout()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    let bounds = self.bounds
    
    pokemonImageView.frame = CGRect(x: floor((bounds.size.width - pokemonImageViewSize.width) / 2.0), y: floor((bounds.size.height - pokemonImageViewSize.height) / 2.0), width: pokemonImageViewSize.width, height: pokemonImageViewSize.height)
    
    pokemonNameLabel.sizeToFit()
    pokemonNameLabel.frame = CGRect(x: 0.0, y: bounds.size.height - pokemonNameLabel.bounds.size.height - 100.0, width: bounds.size.width, height: pokemonNameLabel.bounds.size.height)
  }
  
}
