//
//  FormViewController.swift
//  LBTATools
//
//  Created by Brian Voong on 5/16/19.
//

import UIKit

open class FormViewController: UIViewController {
    
    var lowestElement: UIView!
    public lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        if #available(iOS 11.0, *) {
            sv.contentInsetAdjustmentBehavior = .never
        }
        sv.contentSize = view.frame.size
        sv.keyboardDismissMode = .interactive
        return sv
    }()
    
    public let stackView = UIStackView()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        setupKeyboardNotifications()
    }
    
    var extraBottomPadding: CGFloat = 16
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = distanceToBottom
    }
    
    lazy var distanceToBottom = self.distanceFromLowestElementToBottom()
    
    fileprivate func distanceFromLowestElementToBottom() -> CGFloat {
        if lowestElement != nil {
            guard let frame = lowestElement.superview?.convert(lowestElement.frame, to: view) else { return 0 }
            let distance = view.frame.height - frame.origin.y - frame.height
            return distance
        }
        
        return view.frame.height - stackView.bounds.height
    }
    
    fileprivate func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        
        scrollView.contentInset.bottom = keyboardFrame.height + extraBottomPadding
        if distanceToBottom > 0 {
            scrollView.contentInset.bottom -= distanceToBottom
        }
        
        self.scrollView.scrollIndicatorInsets.bottom = keyboardFrame.height
    }
    
    @objc fileprivate func handleKeyboardHide() {
        self.scrollView.contentInset.bottom = 0
        self.scrollView.scrollIndicatorInsets.bottom = 0
    }
}
