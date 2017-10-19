//
//  ViewController.swift
//  simpleAR
//
//  Created by Victor.
//  Copyright © 2017 Виктор. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ObjectPlacerVC: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var controls: UIStackView!
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    
    var selectedObjectName: String?
    var selectedObject: SCNNode?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        /// Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneView.autoenablesDefaultLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene

        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        let gesture3 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        gesture1.minimumPressDuration = 0.1
        gesture2.minimumPressDuration = 0.1
        gesture3.minimumPressDuration = 0.1
        rotateBtn.addGestureRecognizer(gesture1)
        upBtn.addGestureRecognizer(gesture2)
        downBtn.addGestureRecognizer(gesture3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        placeObject(position: hitPosition)

    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    @IBAction func onObjectButtonPressed(_ sender: UIButton) {
        let objectPickerVC = ObjectPickerVC(size: CGSize(width: 250, height: 500))
        objectPickerVC.objectPlacerVC = self
        objectPickerVC.modalPresentationStyle = .popover
        objectPickerVC.popoverPresentationController?.delegate = self
        present(objectPickerVC, animated: true, completion: nil)
        objectPickerVC.popoverPresentationController?.sourceView = sender
        objectPickerVC.popoverPresentationController?.sourceRect = sender.bounds
    }


    func onObjectSelected(_ objectName: String) {
        selectedObjectName = objectName
    }

    func placeObject(position: SCNVector3) {
        if let objectName = selectedObjectName {
            controls.isHidden = false
            let object = Object.getRumpForName(objectName: objectName)
            selectedObject = object 
            object.position = position
            object.scale = SCNVector3Make(0.01, 0.01, 0.01)
            sceneView.scene.rootNode.addChildNode(object)
        }

    }

    @IBAction func onRemovePressed(_ sender: UIButton) {
        if let object = selectedObject {
            object.removeFromParentNode()
            object.removeFromParentNode()
            selectedObject = nil
        }
    }

    @objc func onLongPress(gesture: UILongPressGestureRecognizer) {
        if let object = selectedObject {
            if gesture.state == .ended {
                object.removeAllActions()
            } else if gesture.state == .began {
                if gesture.view === rotateBtn {
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                    object.runAction(rotate)
                }   else if gesture.view === upBtn {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    object.runAction(move)
                } else if gesture.view === downBtn {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    object.runAction(move)
                }
            }
        }
    }

}
