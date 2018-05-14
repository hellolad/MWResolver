//
//  MWResolver.swift
//  MWResolver
//
//  Created by 赵恒 on 2018/5/14.
//  Copyright © 2018年 hellolad. All rights reserved.
//

import Foundation

struct MWResolver {
    var data: Data
    
    func parse(query: String) -> [MWResolverElement] {
        guard let arrays = PerformHTMLXPathQuery(data, query) else { return [] }
        var elements = [MWResolverElement]()
        for (_, value) in arrays.enumerated() {
            guard let node = value as? [String: Any] else { return [] }
            let element = MWResolverElement(node: node)
            elements.append(element)
        }
        return elements
    }
    
    func peekParse(query: String) -> MWResolverElement? {
        guard let element = parse(query: query).first else { return nil }
        return element
    }
    
    enum Key {
        static let nodeName = "nodeName"
        static let nodeContent = "nodeContent"
        static let nodeAttributeArray = "nodeAttributeArray"
        static let attributeName = "attributeName"
        static let nodeChildArray = "nodeChildArray"
    }
}

class MWResolverElement {
    /// 节点
    var node: [String: Any]
    
    /// 父节点
    var parent: MWResolverElement?
    
    init(node: [String: Any]) {
        self.node = node
        self.parent = nil
    }
    
    /// 标签名字
    var tag: String {
        guard let nodeName = node[MWResolver.Key.nodeName] as? String else { return "" }
        return nodeName
    }
    
    /// 内容
    var content: String {
        guard let nodeContent = node[MWResolver.Key.nodeContent] as? String else { return "" }
        return nodeContent
    }
    
    /// attributes
    var attributes: [String: String] {
        guard let nodeAttributeArray = node[MWResolver.Key.nodeAttributeArray] as? [Any] else { return [:] }
        var atts = [String: String]()
        for (_, value) in nodeAttributeArray.enumerated() {
            guard let dict = value as? [String: String] else { return [:] }
            guard let attName = dict[MWResolver.Key.attributeName], let content = dict[MWResolver.Key.nodeContent] else {
                return [:]
            }
            atts[attName] = content
        }
        return atts
    }
    
    /// children
    var children: [MWResolverElement] {
        guard let nodeChildArray = node[MWResolver.Key.nodeChildArray] as? [Any] else { return [] }
        var elements = [MWResolverElement]()
        for (_, value) in nodeChildArray.enumerated() {
            guard let node = value as? [String: Any] else { return [] }
            let element = MWResolverElement(node: node)
            element.parent = self
            elements.append(element)
        }
        return elements
    }
    
    /// firstChild
    var firstChild: MWResolverElement? {
        guard let element = self.children.first else {
            return nil
        }
        return element
    }
    
    /// haschildren
    var hasChildren: Bool {
        guard let nodeChildArray = node[MWResolver.Key.nodeChildArray] as? [Any] else { return false }
        if nodeChildArray.isEmpty {
            return false
        }
        return true
    }
}
