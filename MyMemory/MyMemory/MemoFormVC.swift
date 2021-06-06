//
//  MemoFormVC.swift
//  MyMemory
//
//  Created by Kant on 2021/06/05.
//

import UIKit

class MemoFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var subject: String!
    
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var preview: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.contents.delegate = self
    }
    
    @IBAction func save(_ sender: Any) {
        // 내용을 입력하지 않았을 경우 경고 생성
        guard self.contents.text?.isEmpty == false else {
            // 내용이 비어있을 때의 처리과정
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let data = MemoData()
        
        data.title =  self.subject
        data.contents = self.contents.text
        data.image = self.preview.image
        data.registerDate = Date()
        
        // 앱 델리게이트 객체를 읽어온 뒤, memoList 배열에 MemoData 객체를 추가한다. (공용 저장소에 저장한다고 생각)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memoList.append(data)
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    // 카메라 버튼 눌렀을때 호출
    @IBAction func pick(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        self.present(picker, animated: false)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 이미지피커뷰에서 사용하던 형식을 UIImage 형식으로 타입 캐스팅
        self.preview.image = info[.editedImage] as? UIImage
        
        picker.dismiss(animated: false)
    }
    
    // 사용자가 텍스트 뷰에 무언가를 입력했을 경우 자동으로 이 메소드가 호출됨
    func textViewDidChange(_ textView: UITextView) {
        let contents = textView.text as NSString
        let length = ((contents.length > 15) ? 15 : contents.length)
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        
        self.navigationItem.title = self.subject
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
