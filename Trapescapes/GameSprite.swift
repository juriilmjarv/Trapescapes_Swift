//
//  GameSprite.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 08/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

//Protocol class for all the game objects. Every object will have texture and spawn function.
protocol GameSprite {
    var textureAtlas: SKTextureAtlas {
        get set
    }
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize)
}
