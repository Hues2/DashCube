import Foundation
import SceneKit

class TileManager {
    // Scene
    private let scene : SCNScene
    
    // Tiles
    private var tileNodes : [TileNode] = []
    private var tileCoordinates = TileCoordinates()
    
    init(scene : SCNScene) {
        self.scene = scene
        setUpInitialTileNodes()
    }
}

// MARK: - Add Tile Node
extension TileManager {
    func addNewTile(_ tileId : UUID?) {
        guard let firstTileNode = tileNodes.first else { return }
        removeTileNode(firstTileNode)
        addTileNode()
        removeDeadZoneNode(tileId)
    }
    
    private func addTileNode(_ isInitialTile : Bool = false) {
        guard let tilePosition = TilePosition.allCases.randomElement() else { return }
        let tileNode = TileNode(tilePosition: tilePosition)
        tileNode.contactHandled = isInitialTile // This stops 1 point being added at start of game
        self.tileNodes.append(tileNode)
        setTilePosition(tileNode)
        Utils.addNodeToScene(scene, tileNode)
    }
    
    private func setTilePosition(_ tileNode : TileNode) {
        tileNode.position = SCNVector3(tileCoordinates.xPosition, tileCoordinates.yPosition, tileCoordinates.zPosition)
        tileCoordinates.yPosition -= 2 // Next block should always be place below current block
        tileCoordinates.xPosition = tileNode.tilePosition == .right ? (tileCoordinates.xPosition + 4) : tileCoordinates.xPosition
        tileCoordinates.zPosition = tileNode.tilePosition == .right ? tileCoordinates.zPosition : (tileCoordinates.zPosition + 4)
    }
}

// MARK: - Remove nodes
private extension TileManager {
    private func removeTileNode(_ tileNode : TileNode) {
        if self.tileNodes.count > Constants.maxNumberOfTiles {
            tileNode.removeFromParentNode()
            tileNodes.removeFirst()
        }
    }
    
    private func removeDeadZoneNode(_ tileId : UUID?) {
        let contactedTile = tileNodes.first(where: { $0.id == tileId })
        guard let contactedTile else { return }
        contactedTile.deadZoneNode.removeFromParentNode()
    }
}

// MARK: - Set up initial tile nodes
private extension TileManager {
    private func setUpInitialTileNodes() {
        for i in Constants.rangeOfInitialNodes {
            addTileNode((i == 0))
        }
    }
}

// MARK: - Restart Game
extension TileManager {
    func reset() {
        // This is to replay the exact same layout of tiles
        // Although, if you keep replaying, the tile nodes will keep dissapearing from under the player
        // As the number of tiles on the list has reached the Constants.maxNumberOfTiles
        
//        self.tileNodes = self.tileNodes.map({ tileNode in
//            var newTileNode = tileNode
//            newTileNode.contactHandled = false
//            return newTileNode
//        })      
        for tileNode in tileNodes {
            tileNode.removeFromParentNode()
        }
        self.tileNodes.removeAll()
        self.tileCoordinates = TileCoordinates()
        self.setUpInitialTileNodes()
    }
}

enum TilePosition : CaseIterable {
    case left, right
}
