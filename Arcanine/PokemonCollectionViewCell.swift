//
//  PokemonCollectionViewCell.swift
//  Arcanine
//
//  Created by Adam Bell on 2/23/16.
//  Copyright © 2016 Adam Bell. All rights reserved.
//

import Pokemon
import UIKit

public class PokemonCollectionViewCell: UICollectionViewCell {
  
  public lazy var pokeball: Pokeball = {
    let pokeball = Pokeball(frame: CGRectZero)
    pokeball.clipsToBounds = false
    
    if !isAppBoring {
      self.addSubview(pokeball)
    }
    
    return pokeball
  }()

  public lazy var pokemonNameLabel: UILabel = {
    let pokemonNameLabel = UILabel(frame: CGRectZero)
    pokemonNameLabel.textAlignment = .Center
    self.addSubview(pokemonNameLabel)
    return pokemonNameLabel
  }()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)

    clipsToBounds = false
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    let bounds = self.bounds
    
    pokeball.layer.position = CGPoint(x: floor(bounds.size.width / 2.0), y: floor(bounds.size.height / 2.0) - 10.0)
    pokeball.bounds = CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: bounds.size.width)
    
    pokemonNameLabel.sizeToFit()
    pokemonNameLabel.frame = CGRect(x: 0.0, y: bounds.size.height - pokemonNameLabel.bounds.size.height + 8.0, width: bounds.size.width, height: pokemonNameLabel.bounds.size.height)
  }

  public override func prepareForReuse() {
    super.prepareForReuse()

    pokeball.reset()
  }

}
