//
//  GameSprite.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 08/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameSprite {
    var textureAtlas: SKTextureAtlas {
        get set
    }
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize)
}
