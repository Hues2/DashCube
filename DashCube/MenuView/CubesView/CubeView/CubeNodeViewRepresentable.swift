import SwiftUI
import SceneKit

struct CubeNodeViewRepresentable: UIViewRepresentable {
    let basicCube : BasicCube
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = SCNScene()
        sceneView.backgroundColor = .clear
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = false
        sceneView.showsStatistics = false
        
        let cubeNode = cubeNode()
        animateCube(cubeNode)
        cubeNode.position.y = -0.5
        let cameraNode = cameraNode()
        let ambientLightNode = ambientLightNode()
        let directionalLightNode = directionalLightNode()
        
        sceneView.scene?.rootNode.addChildNode(cubeNode)
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        sceneView.scene?.rootNode.addChildNode(ambientLightNode)
        sceneView.scene?.rootNode.addChildNode(directionalLightNode)
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update the SCNView if needed
        // Update the cube's material with the new color
        if let cubeNode = uiView.scene?.rootNode.childNode(withName: Constants.NodeName.playerCubeNodeName, recursively: true) {
            self.resetCubeNode(cubeNode)
        }
    }
    
    private func resetCubeNode(_ cubeNode : SCNNode) {
        cubeNode.removeAllAnimations()
        cubeNode.removeAllActions()
//        cubeNode.eulerAngles = SCNVector3Zero
        cubeNode.position = SCNVector3Zero
        cubeNode.rotation = SCNVector4Zero
        cubeNode.geometry?.firstMaterial?.diffuse.contents = UIColor(basicCube.cubeColor.color)
        self.animateCube(cubeNode)
    }
    
    private func cubeNode() -> SCNNode {
        // Create a box geometry
        let boxGeometry = SCNBox(width: Constants.Node.tileSize - 0.25,
                                 height: Constants.Node.tileSize - 0.25,
                                 length: Constants.Node.tileSize - 0.25,
                                 chamferRadius: 0.0)
        
        // Create a material for the box
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(basicCube.cubeColor.color)
        
        // Apply the material to the box
        boxGeometry.materials = [material]
        
        // Create the cube node & set the name
        let cubeNode = SCNNode(geometry: boxGeometry)
        cubeNode.name = Constants.NodeName.playerCubeNodeName
        return cubeNode
    }
    
    private func cameraNode() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        let rotationAngle = SCNVector3Make(-0.3, 0.6, 0)
        cameraNode.eulerAngles = rotationAngle
        cameraNode.position.y = 1.25
        cameraNode.position.z = 4
        cameraNode.position.x = 2.4
        return cameraNode
    }
    
    private func ambientLightNode() -> SCNNode {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .ambient
        lightNode.light?.color = UIColor.darkGray
        return lightNode
    }
    
    private func directionalLightNode() -> SCNNode {
        let initialPosition : SCNVector3 = SCNVector3(x: 0, y: 15, z: 0)
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .directional
        lightNode.light?.intensity = 1000
        lightNode.light?.color = UIColor.white.cgColor
        lightNode.light?.castsShadow = true
        lightNode.position = initialPosition
        let rotationAngle = SCNVector3Make(-1, 0, 0)
        lightNode.eulerAngles = rotationAngle
        return lightNode
    }
    
    
    private func animateCube(_ node : SCNNode) {
        node.runAction(basicCube.animation.displayAction)
    }
}
