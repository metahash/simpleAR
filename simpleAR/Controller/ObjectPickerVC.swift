//
//  ObjectPickerVC.swift
//  simpleAR
//
//  Created by Victor.
//  Copyright © 2017 Виктор. All rights reserved.
//

import UIKit
import SceneKit

class ObjectPickerVC: UIViewController {
    
    var sceneView: SCNView!
    var size: CGSize!
    weak var objectPlacerVC : ObjectPlacerVC!
    
    init (size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        
        preferredContentSize = size
        
        let scene = SCNScene(named: "art.scnassets/background.scn")!
        sceneView.scene = scene
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
        
        let plant = Object.getPlant()
        Object.startRotation(node: plant)
        scene.rootNode.addChildNode(plant)
        
        let house = Object.getHouse()
        Object.startRotation(node: house)
        scene.rootNode.addChildNode(house)
        
        let meat = Object.getMeat()
        Object.startRotation(node: meat)
        scene.rootNode.addChildNode(meat)
    }
    
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let pointLocation = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(pointLocation, options: [:])
        if hitResults.count > 0 {
            let node = hitResults[0].node
            objectPlacerVC.onObjectSelected(node.name!)
            dismiss(animated: true, completion: nil)
        }
    }
    
}
