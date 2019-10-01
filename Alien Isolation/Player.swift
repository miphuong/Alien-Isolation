//
//  Player.swift
//  Alien Isolation
//
//  Created by mike on 2019-10-01.
//  Copyright © 2019 Michael Phuong. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit

class Player: SKSpriteNode{
    // each player has 50 health
    private var health:Int = 50
    
    func decreaseHealth(attackDamage: Int){
        // decrease health of the player
        health = health - attackDamage
    }
    
    func getHealth() -> Int{
        return health
    }
    
}
