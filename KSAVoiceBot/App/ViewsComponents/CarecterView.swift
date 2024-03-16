import SwiftUI
import AVKit
import AVFoundation

struct CarecterView: View {
    var videoName: String

    var body: some View {
        VStack {
            //Text(videoName)
            PlayerView(videoName: videoName)
                .frame(width: 200, height: 400)
                .overlay(RoundedRectangle(cornerRadius: 1).stroke(lineWidth: 30).opacity(0.3).foregroundColor(.white))

                .background(.black)
                .padding(60)
                .background(Color.clear)
                .clipped()
            
        }
        .padding()
        .background(Image("onboarding-11").resizable())
    }
}

struct CarecterView_Previews: PreviewProvider {
    static var previews: some View {
        CarecterView(videoName: "saud-listening3")
    }
}


struct PlayerView: UIViewRepresentable {
    var videoName: String

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
        // Update the video whenever the videoName changes
        if let playerUIView = uiView as? LoopingPlayerUIView {
            playerUIView.updateVideo(with: videoName)
        }
    }

    func makeUIView(context: Context) -> UIView {
        let playerUIView = LoopingPlayerUIView(videoName: videoName)
        context.coordinator.playerUIView = playerUIView // Store the reference to the UIView
        return playerUIView
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator {
        var parent: PlayerView
        var playerUIView: LoopingPlayerUIView?

        init(_ parent: PlayerView) {
            self.parent = parent
        }
    }
}


class LoopingPlayerUIView: UIView {
    var videoName: String {
        didSet {
            updateVideo(with: videoName)
        }
    }

    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?

    required init?(coder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }

    init(videoName: String) {
        self.videoName = videoName
        super.init(frame: .zero)

        setupPlayer(with: videoName)
    }

    private func setupPlayer(with videoName: String) {
        let fileUrl = Bundle.main.url(forResource: videoName, withExtension: "mp4")!
        let asset = AVAsset(url: fileUrl)
        let item = AVPlayerItem(asset: asset)

        let player = AVQueuePlayer()
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)

        playerLooper = AVPlayerLooper(player: playerLayer.player as! AVQueuePlayer, templateItem: item)

        player.play()
    }

    func updateVideo(with newVideoName: String) {
        guard videoName != newVideoName else {
            return // No need to update if the videoName is the same
        }

        videoName = newVideoName

        // Load the new resource
        setupPlayer(with: newVideoName)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
