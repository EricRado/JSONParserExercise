//
//  ViewResponse.swift
//  ViewParser
//
//  Created by Eric Rado on 11/6/18.
//  Copyright © 2018 Eric. All rights reserved.
//

import Foundation

struct ViewResponse: Decodable {
    let identifier: String
    let subviews: [Subview]
}

struct Subview: Decodable {
    
    let identifier: String?
    let classStr: String
    let classNames: [String]?
    let label: Label?
    let subViews: [Subview]?
    let contentView: ContentView?
    let control: Control?
    let title: Title?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try values.decodeIfPresent(String.self, forKey: .identifier)
        classStr = try values.decode(String.self, forKey: .classStr)
        classNames = try values.decodeIfPresent([String].self, forKey: .classNames)
        label = try values.decodeIfPresent(Label.self, forKey: .label)
        subViews = try values.decodeIfPresent([Subview].self, forKey: .subViews)
        contentView = try values.decodeIfPresent(ContentView.self, forKey: .contentView)
        control = try values.decodeIfPresent(Control.self, forKey: .control)
        title = try values.decodeIfPresent(Title.self, forKey: .title)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case classStr = "class"
        case classNames
        case label
        case subViews = "subviews"
        case contentView
        case control
        case title
    }
}

struct Label: Decodable {
    let text: Text
    
}

struct Text: Decodable {
    let text: String
}

struct ContentView: Decodable {
    let subViews: [Subview]
    
    enum CodingKeys: String, CodingKey {
        case subViews = "subviews"
    }
}

struct Control: Decodable {
    let classStr: String
    let varStr: String?
    let identifier: String?
    let max: Double?
    let min: Double?
    let expectsStringValue: Bool?
    let step: Int?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        classStr = try values.decode(String.self, forKey: .classStr)
        varStr = try values.decodeIfPresent(String.self, forKey: .varStr)
        identifier = try values.decodeIfPresent(String.self, forKey: .identifier)
        max = try values.decodeIfPresent(Double.self, forKey: .max)
        min = try values.decodeIfPresent(Double.self, forKey: .min)
        expectsStringValue = try values.decodeIfPresent(Bool.self, forKey: .expectsStringValue)
        step = try values.decodeIfPresent(Int.self, forKey: .step)
    }
    
    enum CodingKeys: String, CodingKey {
        case classStr = "class"
        case varStr = "var"
        case identifier
        case max
        case min
        case expectsStringValue
        case step
    }
}

struct Title: Decodable {
    let text: String
}
