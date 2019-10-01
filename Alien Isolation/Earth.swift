//
//  Earth.swift
//  Alien Isolation
//
//  Created by mike on 2019-10-01.
//  Copyright © 2019 Michael Phuong. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit

class Earth: Player {
    
    let spriteTexture = SKTexture(imageNamed: "earth")
    
    init(sizeOfScreen: CGSize){
        
        super.init(texture: spriteTexture, color: UIColor.clear, size: spriteTexture.size())
        
        // set up the Earth's physical properties
        self.name = "earth"
        self.size = CGSize(width: 260, height: 150)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.position = CGPoint(x: 0, y: (-sizeOfScreen.height/2 - 25))
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

