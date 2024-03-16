//
//  GifImageView.swift
//  KSAVoiceBot
//
//  Created by Reenad gh on 08/02/1445 AH.
//

import Foundation
import SwiftUI
import UIKit
import SwiftyGif

struct SwiftyGifImageView: UIViewRepresentable {
     var gifName: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        DispatchQueue.global(qos: .background).async {
            if let gif = try? UIImage(gifName: self.gifName) {
                DispatchQueue.main.async {
                    let imageView = UIImageView(gifImage: gif, loopCount: -1)
                    imageView.contentMode = .scaleAspectFit
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    view.addSubview(imageView)
                    NSLayoutConstraint.activate([
                        imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
                        imageView.widthAnchor.constraint(equalTo: view.widthAnchor)
                    ])
                }
            }
        }
        
        return view
    }

    func updateUIView(_ gifImageView: UIView, context: Context) {
        // Update the GIF whenever the gifName changes
        if let imageView = gifImageView.subviews.first as? UIImageView {
            if let newGif = try? UIImage(gifName: gifName) {
                imageView.clear()
                imageView.setGifImage(newGif, loopCount: -1)
            }
        }
    }

    class Coordinator: NSObject {
        var parent: SwiftyGifImageView

        init(_ parent: SwiftyGifImageView) {
            self.parent = parent
            super.init()
        }
    }
}
