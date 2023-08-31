//
//  ViewController.swift
//  iOSPaintBrush
//
//  Created by Angelos Staboulis on 18/8/23.
//

import UIKit
import PencilKit
class ViewController: UIViewController, PKToolPickerObserver {
    var canvas = PKCanvasView()
    var toolPicker = PKToolPicker()
    var imageView:UIImageView!
    var toolbar = UIToolbar(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 100))
    var scrollView:UIScrollView!
    var btnOpenFile:UIButton!
    var btnSaveFile:UIButton!
    var btnCut:UIButton!
    var btnCopy:UIButton!
    var btnPaste:UIButton!
    let pasteboard = UIPasteboard.general
    override func viewDidLoad() {
        super.viewDidLoad()
        initialCanvas()
        initialView()
        // Do any additional setup after loading the view.
    }
    
    
}
extension ViewController {
    func initialCanvas(){
        canvas.drawingPolicy = .anyInput
        canvas.isOpaque = true
        canvas.backgroundColor = UIColor.clear
        
        canvas.frame = view.frame
        canvas.tool = PKInkingTool(.pen, color: .black, width: 30)
        self.view.addSubview(canvas)
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
    }
    func initialButtons(){
        self.navigationItem.title = "iOSPaintBrush"
        btnOpenFile = UIButton(frame: CGRect(x: 25, y: 30, width: 150, height: 50))
        btnOpenFile.backgroundColor = .red
        btnOpenFile.setTitle("Open File", for: .normal)
        btnOpenFile.isUserInteractionEnabled = true
        btnOpenFile.addTarget(self, action: #selector(clickOpenFile), for: .touchDown)
        btnOpenFile.layer.cornerRadius = 22
        btnSaveFile = UIButton(frame: CGRect(x: 165, y: 30, width: 150, height: 50))
        btnSaveFile.backgroundColor = .red
        btnSaveFile.setTitle("Save File", for: .normal)
        btnSaveFile.isUserInteractionEnabled = true
        btnSaveFile.addTarget(self, action: #selector(clickSaveFile), for: .touchDown)
        btnSaveFile.layer.cornerRadius = 22
        btnCut = UIButton(frame: CGRect(x: 310, y: 30, width: 150, height: 50))
        btnCut.backgroundColor = .red
        btnCut.setTitle("Cut", for: .normal)
        btnCut.isUserInteractionEnabled = true
        btnCut.addTarget(self, action: #selector(clickCut), for: .touchDown)
        btnCut.layer.cornerRadius = 22
        btnCopy = UIButton(frame: CGRect(x: 445, y: 30, width: 150, height: 50))
        btnCopy.backgroundColor = .red
        btnCopy.setTitle("Copy", for: .normal)
        btnCopy.isUserInteractionEnabled = true
        btnCopy.addTarget(self, action: #selector(clickCopy), for: .touchDown)
        btnCopy.layer.cornerRadius = 22
        btnPaste = UIButton(frame: CGRect(x: 580, y: 30, width: 150, height: 50))
        btnPaste.backgroundColor = .red
        btnPaste.setTitle("Paste", for: .normal)
        btnPaste.isUserInteractionEnabled = true
        btnPaste.addTarget(self, action: #selector(cickPaste), for: .touchDown)
        btnPaste.layer.cornerRadius = 22
    }
    func initialView(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        initialButtons()
        scrollView.addSubview(btnOpenFile)
        scrollView.addSubview(btnSaveFile)
        scrollView.addSubview(btnCut)
        scrollView.addSubview(btnCopy)
        scrollView.addSubview(btnPaste)
        toolbar.backgroundColor = .red
        toolbar.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: 2000, height: 0)
        self.view.addSubview(toolbar)
        
    }
    @objc func clickOpenFile(){
        do{
            canvas.drawing = PKDrawing()
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let image = UIImage(contentsOfFile:documentDirectory.path+"/"+"draw.png")
            let imageView = UIImageView(image: image)
            imageView.frame = canvas.frame
            canvas.addSubview(imageView)
        }catch{
            debugPrint("went wrong!!!"+error.localizedDescription)
        }
    }
    @objc func clickSaveFile(){
        let alert = UIAlertController(title: "Save File", message: "File Saved!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            do{
                let drawingArea = self.canvas.drawing.image(from: self.view.frame, scale: 100)
                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                FileManager.default.createFile(atPath:documentDirectory.path+"/"+"draw.png", contents: drawingArea.pngData(), attributes: [:])
            }catch{
                debugPrint("something went wrong!!!")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func clickCut(){
        if canvas.drawing.strokes.count == 1 {
            let image =  canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
            pasteboard.setData(image.pngData()!, forPasteboardType: "Image")
            canvas.drawing = PKDrawing()
        }
        
        
    }
    @objc func clickCopy(){
        if canvas.drawing.strokes.count == 1 {
            let image =  canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
            pasteboard.setData(image.pngData()!, forPasteboardType: "Image")
        }
    }
    @objc func cickPaste(){
        let image = pasteboard.data(forPasteboardType: "Image")!
        let imageView = UIImageView(image: UIImage(data: image))
        imageView.center = canvas.center
        canvas.insertSubview(imageView, aboveSubview: canvas)
        
    }
}
