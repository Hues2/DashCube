import SwiftUI
import GameKit

struct GameCenterView: UIViewControllerRepresentable {
    let menuViewmodel : MenuViewModel
    private let leaderboardVC = LeaderboardViewController()
    
    func makeUIViewController(context: Context) -> LeaderboardViewController {
        leaderboardVC.menuViewmodel = self.menuViewmodel
        return leaderboardVC
    }

    func updateUIViewController(_ uiViewController: LeaderboardViewController, context: Context) { }
}


class LeaderboardViewController: UIViewController, GKGameCenterControllerDelegate {
    var menuViewmodel : MenuViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLeaderboard()
    }
    
    func showLeaderboard() {
        let gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.modalPresentationStyle = .popover        
        present(gcViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    }
}
