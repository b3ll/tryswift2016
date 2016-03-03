//
//  PokedexViewController.swift
//  Arcanine
//
//  Created by Adam Bell on 2/15/16.
//  Copyright © 2016 Adam Bell. All rights reserved.
//

import pop
import Pokemon
import UIKit

class PokedexViewController: UIViewController, UICollectionViewDelegate, UIGestureRecognizerDelegate {
  
  var pokedex = Pokedex()
  
  var pokedexInfoView: PokedexInfoView?
  var pokemonCollectionViewController: PokemonCollectionViewController?
  
  let itemSize = CGSize(width: 80.0, height: 100.0)
  let pokeballCollectionViewPadding = CGFloat(20.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Arcanine | ウインディ"
    view.backgroundColor = UIColor.whiteColor()
    
    setupPokedexInfoView()
    setupCollectionView()
    setupGestureRecognizer()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let bounds = view.bounds
    
    guard let pokemonCollectionViewController = pokemonCollectionViewController else { return }
    
    pokemonCollectionViewController.view.frame = CGRect(x: 0.0, y: bounds.size.height - itemSize.height - pokeballCollectionViewPadding, width: bounds.size.width, height: itemSize.height)
    
    pokedexInfoView?.frame = CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: bounds.size.height - pokemonCollectionViewController.view.bounds.size.height - pokeballCollectionViewPadding)
  }
  
  private func setupPokedexInfoView() {
    let pokedexInfoView = PokedexInfoView()
    view.addSubview(pokedexInfoView)
    self.pokedexInfoView = pokedexInfoView
  }
  
  private func setupCollectionView() {
    let collectionViewLayout = UICollectionViewFlowLayout()
    collectionViewLayout.itemSize = itemSize
    collectionViewLayout.scrollDirection = .Horizontal
    
    let pokemonCollectionViewController = PokemonCollectionViewController(collectionViewLayout: collectionViewLayout)
    pokemonCollectionViewController.collectionView?.delegate = self
    pokemonCollectionViewController.collectionView?.clipsToBounds = false
    view.addSubview(pokemonCollectionViewController.view)
    self.pokemonCollectionViewController = pokemonCollectionViewController
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
      guard let pokemon = self?.pokedex.pokemon else { return }
      dispatch_async(dispatch_get_main_queue(), {
        self?.pokemonCollectionViewController?.pokemon = pokemon
      })
    }
  }
  
  private func setupGestureRecognizer() {
    if isAppBoring {
      return
    }
    
    let verticalPanGestureRecognizer = UIVerticalPanGestureRecognizer(target: self, action: #selector(PokedexViewController.didPan(_:)))
    pokemonCollectionViewController?.collectionView?.panGestureRecognizer.requireGestureRecognizerToFail(verticalPanGestureRecognizer)
    pokemonCollectionViewController?.collectionView?.addGestureRecognizer(verticalPanGestureRecognizer)

    verticalPanGestureRecognizer.delegate = self
  }
  
  @objc internal func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    pokedexInfoView?.pokemon = pokedex.pokemon[indexPath.row]
  }
  
  private var startLocation: CGPoint = CGPointZero
  @objc internal func didPan(gestureRecognizer: UIVerticalPanGestureRecognizer) {
    let location = gestureRecognizer.locationInView(view)
    if gestureRecognizer.state == .Began {
      startLocation = location
    }
    
    let translation = gestureRecognizer.translationInView(view)
    let velocity = gestureRecognizer.velocityInView(view)

    let startLocationInsideCollectionView = view.convertPoint(startLocation, toView: pokemonCollectionViewController?.collectionView)
    let grabbedPokeball = pokemonCollectionViewController?.pokeballAtPoint(startLocationInsideCollectionView)
    guard let pokeball = grabbedPokeball?.pokeball else { return }
    guard let grabbedIndexPath = grabbedPokeball?.indexPath else { return }

    let neededTranslation = CGPoint(x: view.center.x - startLocation.x, y: view.center.y - startLocation.y)

    switch gestureRecognizer.state {
    case .Began:
      break
    case .Changed:
      POPLayerSetTranslationXY(pokeball.layer, translation)
      break
    case .Ended:
      POPLayerSetRotation(pokeball.layer, CGFloat(M_PI * 100.0))

      let spinAnimation = POPDecayAnimation(propertyNamed: kPOPLayerRotation)
      spinAnimation.velocity = velocity.y * 0.05 * (velocity.x > 0 ? -1.0 : 1.0)
      pokeball.layer.pop_addAnimation(spinAnimation, forKey: kPOPLayerRotation)

      let throwAnimation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
      throwAnimation.velocity = NSValue(CGPoint: velocity)
      throwAnimation.toValue = NSValue(CGPoint: neededTranslation)
      throwAnimation.dynamicsFriction = 0.1
      throwAnimation.dynamicsMass = 0.5
      throwAnimation.dynamicsTension = 10
      throwAnimation.animationDidApplyBlock = { [weak self] (anim: POPAnimation!) in
        if self?.pokeballHitGround(pokeball).boolValue == false {
          return
        }

        pokeball.layer.pop_removeAnimationForKey(kPOPLayerTranslationXY)
        pokeball.layer.pop_removeAnimationForKey(kPOPLayerRotation)

        UIApplication.sharedApplication().keyWindow?.flash()
        
        pokeball.explode()

        self?.pokedexInfoView?.pokemon = self?.pokedex.pokemon[grabbedIndexPath.row]

        dispatchAfter(0.5) {
          pokeball.reset()
        }
      }
      pokeball.layer.pop_addAnimation(throwAnimation, forKey: kPOPLayerTranslationXY)
      gestureRecognizer.setTranslation(CGPointZero, inView: view)
      break
    case .Cancelled, .Failed:
      pokeball.reset()
      gestureRecognizer.setTranslation(CGPointZero, inView: view)
      break
    default:
      break
    }
  }

  private func pokeballHitGround(pokeball: Pokeball) -> Bool {
    guard let throwAnimation = pokeball.layer.pop_animationForKey(kPOPLayerTranslationXY) as? POPSpringAnimation else { return false }

    if throwAnimation.velocity.CGPointValue().y < 0.0 {
      return false
    }

    guard let pokeballFrame = pokemonCollectionViewController?.collectionView?.convertRect(pokeball.layer.frame, toView: view) else { return false }
    if CGRectGetMaxY(pokeballFrame) < view.center.y {
      return false
    }

    return true
  }

}
