import SwiftUI
import UIKit

// https://stackoverflow.com/a/71577189

struct UIKitAppear: UIViewControllerRepresentable {
    let viewDidAppearAction: ((UIViewController) -> Void)?
    let viewWillAppearAction: ((UIViewController) -> Void)?
    let viewDidDisappearAction: ((UIViewController) -> Void)?
    let viewWillDisappearAction: ((UIViewController) -> Void)?
    
    func makeUIViewController(context: Context) -> UIAppearViewController {
        let vc = UIAppearViewController()
        vc.delegate = context.coordinator
        return vc
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewDidAppearAction: self.viewDidAppearAction, viewWillAppearAction: viewWillAppearAction, viewDidDisappearAction : self.viewDidDisappearAction, viewWillDisappearAction: self.viewWillDisappearAction)
    }
    
    func updateUIViewController(_ controller: UIAppearViewController, context: Context) {}
    
    class Coordinator: ActionRepresentable {
        func viewWillDisappearAction(_ vc: UIViewController) {
            viewWillDisappearAction?(vc)
        }
        
        func viewDidDisappearAction(_ vc: UIViewController) {
            viewDidDisappearAction?(vc)
        }
        func viewDidAppearAction(_ vc: UIViewController) {
            viewDidAppearAction?(vc)
        }
        func viewWillAppearAction(_ vc: UIViewController) {
            viewWillAppearAction?(vc)
        }
        
        var viewDidAppearAction: ((UIViewController) -> Void)?
        var viewWillAppearAction: ((UIViewController) -> Void)?
        var viewDidDisappearAction: ((UIViewController) -> Void)?
        var viewWillDisappearAction: ((UIViewController) -> Void)?
        
        init(
            viewDidAppearAction: ((UIViewController) -> Void)? = nil,
            viewWillAppearAction: ((UIViewController) -> Void)? = nil,
            viewDidDisappearAction : ((UIViewController)->Void)? = nil,
            viewWillDisappearAction: ((UIViewController) -> Void)? = nil
        ) {
            self.viewDidAppearAction = viewDidAppearAction
            self.viewWillAppearAction = viewWillAppearAction
            self.viewDidDisappearAction = viewDidDisappearAction
            self.viewWillDisappearAction = viewWillDisappearAction
        }
    }
}

protocol ActionRepresentable: AnyObject {
    func viewWillAppearAction(_ vc: UIViewController)
    func viewDidAppearAction(_ vc: UIViewController)
    func viewDidDisappearAction(_ vc: UIViewController)
    func viewWillDisappearAction(_ vc: UIViewController)
}

class UIAppearViewController: UIViewController {
    weak var delegate: ActionRepresentable?
    var savedView: UIView?
    
    override func viewDidLoad() {
        self.savedView = UILabel()
        
        if let _view = self.savedView {
            view.addSubview(_view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return}
            self.delegate?.viewWillAppearAction(self)
        }
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return}
            self.delegate?.viewDidAppearAction(self)
        }
        super.viewDidAppear(animated)
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return}
            self.delegate?.viewDidDisappearAction(self)
        }
        
        super.viewDidDisappear(animated)
        self.view.removeFromSuperview()
        savedView?.removeFromSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return}
            self.delegate?.viewWillDisappearAction(self)
        }
        super.viewWillDisappear(animated)
    }
}

public extension View {
    
    func onUIKitAppear(
        viewDidAppearAction: ((UIViewController) -> Void)? = nil,
        viewWillAppearAction: ((UIViewController) -> Void)? = nil,
        viewDidDisappearAction: ((UIViewController) -> Void)? = nil,
        viewWillDisappearAction: ((UIViewController) -> Void)? = nil
    ) -> some View {
        self.background(UIKitAppear(viewDidAppearAction: viewDidAppearAction,
                                    viewWillAppearAction: viewWillAppearAction, viewDidDisappearAction: viewDidDisappearAction, viewWillDisappearAction: viewWillDisappearAction))
    }
}
