//
// Copyright (c) 2018 Muukii <muukii.app@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
import Foundation
import PixelEngine

open class RootControlBase : ControlBase {

    let preImageView: ImagePreviewView
    
    public required init(context: PixelEditContext, colorCubeControl: ColorCubeControlBase, previewImageView: ImagePreviewView) {
        self.preImageView = previewImageView
        super.init(context: context)
  }
}

final class RootControl : RootControlBase {

  public enum DisplayType {
    case filter
    case edit
    case waterMark
  }

  public var displayType: DisplayType = .filter {
    didSet {
      guard oldValue != displayType else { return }
      set(displayType: displayType)
    }
  }

  public let filtersButton = UIButton(type: .custom)

  public let editButton = UIButton(type: .custom)

  public let waterMarkButton = UIButton(type: .custom)

  private let containerView = UIView()

  public let colorCubeControl: ColorCubeControlBase

  public lazy var editView = context.options.classes.control.editMenuControl.init(context: context)

  // MARK: - Initializers

  public required init(context: PixelEditContext, colorCubeControl: ColorCubeControlBase, previewImageView: ImagePreviewView) {
    self.colorCubeControl = colorCubeControl

    super.init(context: context, colorCubeControl: colorCubeControl, previewImageView: previewImageView)

    backgroundColor = Style.default.control.backgroundColor

    layout: do {

      let stackView = UIStackView(arrangedSubviews: [filtersButton, editButton, waterMarkButton])
      stackView.axis = .horizontal
      stackView.distribution = .fillEqually

      addSubview(containerView)
      addSubview(stackView)

      containerView.translatesAutoresizingMaskIntoConstraints = false
      stackView.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([

        containerView.topAnchor.constraint(equalTo: containerView.superview!.topAnchor),
        containerView.leftAnchor.constraint(equalTo: containerView.superview!.leftAnchor),
        containerView.rightAnchor.constraint(equalTo: containerView.superview!.rightAnchor),

        stackView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
        stackView.leftAnchor.constraint(equalTo: stackView.superview!.leftAnchor),
        stackView.rightAnchor.constraint(equalTo: stackView.superview!.rightAnchor),
        stackView.bottomAnchor.constraint(equalTo: stackView.superview!.bottomAnchor),
        stackView.heightAnchor.constraint(equalToConstant: 50),
        ])

    }

    body: do {
//        if L10n.getCurrentLanguage() == "en" {
//            filtersButton.setTitle(L10n.filter, for: .normal)
//            editButton.setTitle(L10n.edit, for: .normal)
//            waterMarkButton.setTitle("sss", for: .normal)
//        }
//        else {
//            filtersButton.setTitle("滤镜", for: .normal)
//            editButton.setTitle("编辑", for: .normal)
//            waterMarkButton.setTitle("sss", for: .normal)
//        }
                
        
        filtersButton.setImage(UIImage(named: "editorfiltericonwhite", in: bundle, compatibleWith: nil)!, for: .normal)
        filtersButton.setImage(UIImage(named: "editorfiltericonyellow", in: bundle, compatibleWith: nil)!, for: .selected)

        editButton.setImage(UIImage(named: "editoradjusticonwhite", in: bundle, compatibleWith: nil)!, for: .normal)
        editButton.setImage(UIImage(named: "editoradjusticonyellow", in: bundle, compatibleWith: nil)!, for: .selected)
        
        waterMarkButton.setImage(UIImage(named: "Frameiconwhite", in: bundle, compatibleWith: nil)!, for: .normal)
        waterMarkButton.setImage(UIImage(named: "Frameiconyellow", in: bundle, compatibleWith: nil)!, for: .selected)

        
//      filtersButton.tintColor = .clear
//      editButton.tintColor = .clear
//      waterMarkButton.tintColor = .clear
//        
//      filtersButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
//      editButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
//        waterMarkButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
//
//      filtersButton.setTitleColor(.white, for: .selected)
//      editButton.setTitleColor(.white, for: .selected)
//        waterMarkButton.setTitleColor(.white, for: .selected)
//        
//      filtersButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
//      editButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
//        waterMarkButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)

      filtersButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
      editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        waterMarkButton.addTarget(self, action: #selector(didTapWaterMarkButton), for: .touchUpInside)
    }

  }

  // MARK: - Functions

  override func didMoveToSuperview() {
    super.didMoveToSuperview()

    if superview != nil {
      set(displayType: displayType)
    }
  }

  @objc
  private func didTapFilterButton() {

    displayType = .filter
  }

  @objc
  private func didTapEditButton() {

    displayType = .edit
  }

    @objc
    private func didTapWaterMarkButton() {
        displayType = .waterMark
        
    }

  private func set(displayType: DisplayType) {

    containerView.subviews.forEach { $0.removeFromSuperview() }

    filtersButton.isSelected = false
    editButton.isSelected = false
    waterMarkButton.isSelected = false
      
    switch displayType {
    case .filter:
      
      colorCubeControl.frame = containerView.bounds
      colorCubeControl.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      containerView.addSubview(colorCubeControl)
      subscribeChangedEdit(to: colorCubeControl)

        let watermarketstatus = false // 你的bool值
        let userInfo: [AnyHashable: Any] = ["watermarketstatus": watermarketstatus]
        let notification = Notification(name: .customNotification, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(notification)
      filtersButton.isSelected = true

    case .edit:
      
      editView.frame = containerView.bounds
      editView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      
      containerView.addSubview(editView)
      subscribeChangedEdit(to: editView)
    
        let watermarketstatus = false // 你的bool值
        let userInfo: [AnyHashable: Any] = ["watermarketstatus": watermarketstatus]
        let notification = Notification(name: .customNotification, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
      editButton.isSelected = true
    case .waterMark:
        // 在适当的地方发送通知
        waterMarkButton.isSelected = true
        
        let watermarketstatus = true // 你的bool值
        let userInfo: [AnyHashable: Any] = ["watermarketstatus": watermarketstatus]
        let notification = Notification(name: .customNotification, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(notification)

    }
  
  }

}
