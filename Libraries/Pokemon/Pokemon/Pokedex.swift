//
//  Pokedex.swift
//  Arcanine
//
//  Created by Adam Bell on 2/23/16.
//  Copyright © 2016 Adam Bell. All rights reserved.
//

import Foundation

public class Pokedex: NSObject {

  public lazy var pokemon: [Pokemon] = {
    let csvPath = NSBundle(forClass: self.dynamicType).pathForResource("pokemon", ofType: "csv")!
    let data = try! String(contentsOfFile: csvPath)
    let rows = data.componentsSeparatedByString("\n")

    var pokemon = [Pokemon]()
    
    for i in rows.startIndex..<rows.endIndex {
      let row = rows[i]
      if i == 0 || row.isEmpty {
        continue
      }

      let elements = row.componentsSeparatedByString(",")
      let pkmn = Pokemon(ID: Int(elements[0])!, name: elements[1])
      pokemon.append(pkmn)
    }

    return pokemon
  }()

}
