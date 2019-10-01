//
//  Bullet.swift
//  Alien Isolation
//
//  Created by mike on 2019-10-01.
//  Copyright © 2019 Michael Phuong. All rights reserved.
//

import Foundation
import GameplayKit

class Bullet: SKSpriteNode {
    
    let spriteTexture = SKTexture(imageNamed: "bullet")
    
    init(){
        
        super.init(texture: spriteTexture, color: UIColor.clear, size: spriteTexture.size())
        
        // set up bullet's physical properties
        self.size =  CGSize(width: 25, height: 25)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveUp(_ screenSize: CGSize,_ bulletSize: CGSize){
        // move the bullet upwards, and removes it once it leaves the screen
        let travelUp = SKAction.moveTo(y: (screenSize.height/2), duration: Double(1.5))
        let travelSequence = SKAction.sequence([travelUp, SKAction.removeFromParent()])
        
        run(travelSequence)
    }
    
}



