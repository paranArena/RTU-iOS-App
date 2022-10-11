//
//  CustomPicker.swift
//  UIPractice
//
//  Created by 노우영 on 2022/09/03.
//

import SwiftUI

struct CustomPicker: UIViewRepresentable {
    
    let rowDatas = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    @Binding var values : [Int]
    
    //makeCoordinator()
    func makeCoordinator() -> CustomPicker.Coordinator {
        print("makeCoordinator called")
        return CustomPicker.Coordinator(self)
    }
    

    //updateUIView(_:context:)
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<CustomPicker>) {
//        print("updateUIView is called! \(values[0]) \(values[1])")
    }
    

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: CustomPicker
        init(_ pickerView: CustomPicker) {
            self.parent = pickerView
//            print("Coordinator Init, [\(parent.values[0]), \(parent.values[1])")
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
            parent.values[component] = parent.rowDatas[row]
        }
        
        //Number Of Components:
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }

        //Number Of Rows In Component:
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return 10
        }

        //Width for component:
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return UIScreen.main.bounds.width/5
        }

        //Row height:
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 30
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            
            pickerView.subviews.forEach {
                $0.backgroundColor = .clear
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: 30))
            let pickerLabel = UILabel(frame: view.bounds)
            pickerLabel.text = "\(parent.rowDatas[row])"

            pickerLabel.adjustsFontSizeToFitWidth = true
            pickerLabel.textAlignment = .center
            pickerLabel.lineBreakMode = .byWordWrapping
            pickerLabel.numberOfLines = 0
            

            view.addSubview(pickerLabel)
            view.clipsToBounds = true
            view.layer.cornerRadius = view.bounds.height * 0.1
            
            
            
            if parent.rowDatas[row] == parent.values[component] {
                print("\(component) selected \(row)")
                pickerView.selectRow(row, inComponent: component, animated: false)
            }

            return view
        }
    }
    
    //makeUIView(context:)
    func makeUIView(context: UIViewRepresentableContext<CustomPicker>) -> UIPickerView {
//        print("makeUIView called")
        let picker = UIPickerView(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        
        return picker
    }
}

extension CustomPicker {
    func customHide(selectedValue: Int?, value: Int) -> some View {
        self
            .isHidden(hidden: selectedValue == nil || (selectedValue != nil && selectedValue != value) )
    }
}
