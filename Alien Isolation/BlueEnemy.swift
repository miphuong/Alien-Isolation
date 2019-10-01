//
//  BlueEnemy.swift
//  Alien Isolation
//
//  Created by mike on 2019-10-01.
//  Copyright © 2019 Michael Phuong. All rights reserved.
//

import Foundation
import GameplayKit

class BlueEnemy: Enemy{
    
    let spriteTexture = SKTexture(imageNamed: "blueEnemy")
    
    init(sizeOfScreen: CGSize){
        super.init(texture: spriteTexture, color: UIColor.clear, size: spriteTexture.size())
        
        // set up BlueEnemy's physical properties
        self.size = CGSize(width: 50, height: 50)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        
        // set up the BlueEnemy's postion
        let minScreenWidth = (-Double(sizeOfScreen.width)/2 + 40)
        let maxScreenWidth = Double(sizeOfScreen.width)/2 - 40
        let randomPosition = Double.random(in: minScreenWidth..<maxScreenWidth)
        self.position = CGPoint(x: randomPosition, y: Double(sizeOfScreen.height))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

