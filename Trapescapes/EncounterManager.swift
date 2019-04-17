//
//  EncounterManager.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 12/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

class EncounterManager {
    let encounterNames:[String] = [
        "1",
        "2",
        "3",
        "4",
        "5"
    ]
    
    var currentEncounterIndex:Int?
    var previousEncounterIndex:Int?
    
    var encounters:[SKNode] = []
    
    //instantiate EnemyOne prototype
    let base = EnemyOne()
    
    init() {
        for encounterFileName in encounterNames {
            let encounter = SKNode()
            
            if let encounterScene = SKScene(fileNamed: encounterFileName) {
                for placeholder in encounterScene.children {
                    let node = placeholder
                        switch node.name! {
                        case "Mill":
                            let millClockWise = base.clone()
                            millClockWise.rotation = -.pi
                            millClockWise.spawn(parentNode: encounter, position: node.position)
                        case "MillAntiClock":
                            let millAntiClockWise = base.clone()
                            millAntiClockWise.spawn(parentNode: encounter, position: node.position)
                        case "Platform":
                            let platform = EnemyPlatform()
                            platform.spawn(parentNode: encounter, position: node.position)
                        case "Ghost":
                            let ghost = EnemyGhost()
                            ghost.spawn(parentNode: encounter, position: node.position)
                        case "Coin":
                            let coin = Coin()
                            coin.spawn(parentNode: encounter, position: node.position)
                        case "EnemyEagle":
                            let eagle = EnemyEagle()
                            eagle.spawn(parentNode: encounter, position: node.position)
                        default:
                            print("Wrong name used in encounters")
                        }
                }
            }
            encounters.append(encounter)
            saveSpritePositions(node: encounter)
        }
    }
    
    func addEncountersToWorld(world:SKNode) {
        var encounterYPos:Double = -2000
        for index in 0 ... encounters.count - 1 {
            // Spawn the encounters behind the action, with
            // increasing height so they do not collide:
            encounters[index].position = CGPoint(x: 375, y:
                encounterYPos)
            world.addChild(encounters[index])
            encounterYPos *= 1.67
        }
    }
    
    func saveSpritePositions(node:SKNode) {
        for sprite in node.children {
            if let spriteNode = sprite as? SKSpriteNode {
                let initialPositionValue = NSValue(cgPoint:
                    sprite.position)
                spriteNode.userData = ["initialPosition":
                    initialPositionValue]
                // Save the positions for children of this node:
                saveSpritePositions(node: spriteNode)
            }
        }
    }
    
    func resetSpritePositions(node:SKNode) {
        for sprite in node.children {
            if let spriteNode = sprite as? SKSpriteNode {
                // Remove any linear or angular velocity:
                spriteNode.physicsBody?.velocity = CGVector(dx: 0,
                                                            dy: 0)
                spriteNode.physicsBody?.angularVelocity = 0
                // Reset the rotation of the sprite:
                spriteNode.zRotation = 0
                if let initialPositionVal = spriteNode.userData?.value(forKey: "initialPosition") as? NSValue {
                    // Reset the position of the sprite:
                    spriteNode.position =
                        initialPositionVal.cgPointValue
                }
                
                // Reset positions on this node's children
                resetSpritePositions(node: spriteNode)
            }
        }
    }

    
    func placeNextEncounter(currentYPos:CGFloat) {
        // Count the encounters in a random ready type (Uint32):
        let encounterCount = UInt32(encounters.count)
        // The game requires at least 3 encounters to function
        // so exit this function if there are less than 3
        if encounterCount < 3 { return }
        
        // We need to pick an encounter that is not
        // currently displayed on the screen.
        var nextEncounterIndex:Int?
        var trulyNew:Bool?
        // The current encounter and the directly previous encounter
        // can potentially be on the screen at this time.
        // Pick until we get a new encounter
        while trulyNew == false || trulyNew == nil {
            // Pick a random encounter to set next:
            nextEncounterIndex =
                Int(arc4random_uniform(encounterCount))
            // First, assert that this is a new encounter:
            trulyNew = true
            // Test if it is instead the current encounter:
            if let currentIndex = currentEncounterIndex {
                if (nextEncounterIndex == currentIndex) {
                    trulyNew = false
                }
            }
            // Test if it is the directly previous encounter:
            if let previousIndex = previousEncounterIndex {
                if (nextEncounterIndex == previousIndex) {
                    trulyNew = false
                }
            }
        }
        previousEncounterIndex = currentEncounterIndex
        currentEncounterIndex = nextEncounterIndex
        
        // Reset the new encounter and position it ahead of the player
        let encounter = encounters[currentEncounterIndex!]
        encounter.position = CGPoint(x: 375, y: currentYPos + 1800)
        resetSpritePositions(node: encounter)
    }
}
