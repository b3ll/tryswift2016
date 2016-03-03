//
//  PokemonCollectionView.swift
//  Arcanine
//
//  Created by Adam Bell on 2/23/16.
//  Copyright © 2016 Adam Bell. All rights reserved.
//

import Pokemon
import UIKit

public class PokemonCollectionViewController: UICollectionViewController {
  
  private let cellReuseIdentifier = "pkmn"
  
  public var pokemon: [Pokemon]? {
    didSet {
      collectionView?.reloadData()
    }
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = UIColor.whiteColor()
    collectionView?.showsHorizontalScrollIndicator = false
    collectionView?.showsVerticalScrollIndicator = false
    
    collectionView?.registerClass(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
  }
  
  public override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pokemon?.count ?? 0
  }

  public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! PokemonCollectionViewCell
    cell.pokemonNameLabel.text = pokemon?[indexPath.row].name
    return cell
  }
  
  public func pokeballAtPoint(point: CGPoint) -> (pokeball: Pokeball?, indexPath: NSIndexPath?) {
    guard let indexPath = collectionView?.indexPathForItemAtPoint(point) else { return (nil, nil) }
    guard let pokeball = (collectionView?.cellForItemAtIndexPath(indexPath) as? PokemonCollectionViewCell)?.pokeball else { return (nil, nil) }
    return (pokeball, indexPath)
  }
  
}
