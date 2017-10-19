//
//  Object.swift
//  simpleAR
//
//  Created by Victor.
//  Copyright © 2017 Виктор. All rights reserved.
//

import Foundation
import SceneKit

class Object {
    
    class func getRumpForName(objectName: String) -> SCNNode {
        switch objectName {
        case "plant":
            return Object.getPlant()
        case "house":
            return Object.getHouse()
        case "meat":
            return Object.getMeat()
        default:
            return Object.getMeat()
        }
    }
    
    class func getPlant() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/plant.dae")
        let node = obj?.rootNode.childNode(withName: "plant", recursively: true)!
        node?.scale = SCNVector3Make(0.1, 0.1, 0.1)
        node?.position = SCNVector3Make(-1, 0.4, -1)
        return node!
    }
    
    
    class func getHouse() -> SCNNode {
        let obj =  SCNScene(named: "art.scnassets/house.dae")
        let node = obj?.rootNode.childNode(withName: "house", recursively: true)!
        node?.scale = SCNVector3Make(0.1, 0.1, 0.1)
        node?.position = SCNVector3Make(-1, -0.7, -1)
        return node!
    }
    
    class func getMeat() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/meat.dae")
        let node = obj?.rootNode.childNode(withName: "meat", recursively: true)!
        
        node?.scale = SCNVector3Make(0.1, 0.1, 0.1)
        node?.position = SCNVector3Make(-1, -2, -1)
        return node!
    }
    
    class func startRotation(node: SCNNode) {
        let rotate =  SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))
        node.runAction(rotate)
    }
}
