//
//  main.swift
//  codingtext
//
//  Created by 박경준 on 2023/01/15.
//

import Foundation

class Node{
    var value: String?
    
    var next: Node?
    weak var previous: Node?
    
    init(value: String){
        self.value = value
    }
}

// 커서 a 커서 b 커서 c 커서
class LinkedList {
    
    var head: Node?
    
    var cursor = 0
    
    var count: Int {
        get{
            guard var node = head else {return 0}
            
            var count = 1
            while let next = node.next {
                node = next
                count += 1
            }
            
            return count
        }
    }
    
    var last: Node?{
        get{
            guard var node = head else {return nil}
            
            while let next = node.next {
                node = next
            }
            
            return node
        }
    }
    
    func append(value: String){
        let newNode = Node(value: value)
        // 라스트노드가 있으면 라스트노드를 newNode에 맞춘다.
        if let node = last{
            newNode.previous = node
            newNode.next = nil
            node.next = newNode
            
            if(cursor <= count){
                cursor += 1
            }
        }else{
            
            head = newNode
            if(cursor <= count){
                cursor += 1
            }
        }
    }
    
    // 커서 왼쪽에 존재하는 문자 리턴
    func getNodeByCursorLeft() -> Node?{
        print("hello")
        if(cursor - 1 <= 0){
            return head
        }else if(cursor - 1 > count){
            return last
        }else {
            guard var node = head else {return nil}
            
            for _ in 1..<cursor {
                node = node.next!
            }
            
            return node
        }
    }
    
    func removeElementByCursorLeft(){
        if(cursor - 1 <= 0){
            cursor = 0
        }else if(cursor - 1 > count){
            last?.previous?.next = nil
            cursor = count
        }else {
            guard var node = head else {return}
            
            for _ in 1..<cursor {
                node = node.next!
            }
            // a b(node) 커서 c
            print("removed: \(node.value!)")
            
            
            // TODO: 0번째 인덱스 삭제하는 로직 구현
            if let previous = node.previous {
                let next = node.next
                previous.next = next
                next?.previous = previous
            }else{
                head = node
                node.previous = nil
            }
            
            if(cursor > 0){
                cursor -= 1
            }
            
        }
    }
    
    
    // a b 커서 c
    func insertElementByCursorLeft(char: String){
        let newNode = Node(value: char)
        
        // 헤드노드가 없을때
        guard let headNode = head else {
            head = newNode
            return
        }
        
        
        if(cursor - 1 <= 0){
            newNode.next = headNode
            headNode.previous = newNode
            head = newNode
            
            cursor = 1
        }else if(cursor - 1 >= count){
            last?.next = newNode
            newNode.previous = last
            
            // 커서 왼쪽에 문자가 삽입되는 것이므로 커서 위치도 + 1 해줘야함
            if(cursor <= count){
                cursor += 1
            }
        }else {
            guard var node = head else {return}
            
            for _ in 1..<cursor {
                node = node.next!
            }
            
            let next = node.next
            
            newNode.next = next
            newNode.previous = node.previous
            node.next = newNode
            next?.previous = newNode
            
            if(cursor <= count){
                cursor += 1
            }
        }
        
    }
    
    func printAllNode(){
        guard var node = self.head else {return}
        
        while let next = node.next{
            print(node.value!, terminator: "")
            node = next
        }
        print(node.value!)
        
    }
    
    
}

let list = LinkedList()

// 문자 입력받았으면 한글자씩 쪼개서 노드로 만들기
let inputString = readLine()!

let commandNumber = Int(readLine()!)!



let stringArray = inputString.map{ String($0) }

for index in 0 ..< stringArray.count{
    list.append(value: stringArray[index])
}

for _ in 0..<commandNumber {
    let command = readLine()!.split(separator: " ").map{ String($0) }

    if(command.count == 1){
        switch command[0] {
        case "L":
            if(list.cursor <= 0){
                break
            }
            list.cursor -= 1
        case "D":
            if(list.cursor >= list.count){
                break
            }
            list.cursor += 1
        case "B":
            list.removeElementByCursorLeft()
        default:
            break
        }
        list.printAllNode()
    }else{
        
        list.insertElementByCursorLeft(char: command[1])
        list.printAllNode()
    }
}
