/**
 A binary search tree is a special kind of binary tree (a tree in which each node has at most two children) that performs insertions and deletions such that the tree is always sorted.
 
 Notice how each left child is smaller than its parent node, and each right child is greater than its parent node. This is the key feature of a binary search tree.
 
 When performing an insertion, we first compare the new value to the root node. If the new value is smaller, we take the left branch; if greater, we take the right branch. We work our way down the tree this way until we find an empty spot where we can insert the new value.
 
 Note: The height of a node is the number of steps it takes to go from that node to its lowest leaf. The height of the entire tree is the distance from the root to the lowest leaf. Many of the operations on a binary search tree are expressed in terms of the tree's height.
 
 Searching the tree:
 To find a value in the tree, we essentially perform the same steps as with insertion:
 - If the value is less than the current node, then take the left branch.
 - If the value is greater than the current node, take the right branch.
 - And if the value is equal to the current node, we've found it.
 
 Traversing the tree:
 Sometimes you don't want to look at just a single node, but at all of them.
 There are three ways to traverse a binary tree:
 - In-order (or depth-first): first look at the left child of a node, then at the node itself, and finally at its right child.
 - Pre-order: first look at a node, then its left and right children.
 - Post-order: first look at the left and right children and process the node itself last.
 
 Deleting nodes:
 Removing nodes is also easy. After removing a node, we replace the node with either its biggest child on the left or its smallest child on the right. That way the tree is still sorted after the removal.
 Note the replacement needs to happen when the node has at least one child. If it has no child, you just disconnect it from its parent.
 */

import Foundation

/**
 A binary search tree.
 Each node stores a value and two children. The left child contains a smaller value; the right a larger (or equal) value.
 This tree allows duplicate elements.
 This tree does not automatically balance itself. To make sure it is balanced, you should insert new values in randomized order, not in sorted order.
 */
public class BinarySearchTree<T: Comparable> {
    fileprivate(set) public var value: T
    fileprivate(set) public var parent: BinarySearchTree?
    fileprivate(set) public var left: BinarySearchTree?
    fileprivate(set) public var right: BinarySearchTree?
    
    public init(value: T) {
        self.value = value
    }
    
    public convenience init(array: [T]) {
        precondition(array.count > 0)
        self.init(value: array.first!)
        for v in array.dropFirst() {
            insert(value: v)
        }
    }
    
    public var isRoot: Bool {
        return parent == nil
    }
    
    public var isLeaf: Bool {
        return left == nil && right == nil
    }
    
    public var isLeftChild: Bool {
        return parent?.left === self
    }
    
    public var isRightChild: Bool {
        return parent?.right === self
    }
    
    public var hasLeftChild: Bool {
        return left != nil
    }
    
    public var hasRightChild: Bool {
        return right != nil
    }
    
    public var hasAnyChild: Bool {
        return hasLeftChild || hasRightChild
    }
    
    public var hasBothChildren: Bool {
        return hasLeftChild && hasRightChild
    }
    
    /// How many nodes are in this subtree. Performance: O(n).
    public var count: Int {
        return (left?.count ?? 0) + 1 + (right?.count ?? 0)
    }
}

// MARK: - Adding items
extension BinarySearchTree {
    /**
     Insert a new element into the tree. You should only insert elements at the root, to make to sure this remains a valid binary tree.
     Performance: runs in O(h) time, where h is the height of the tree.
     */
    public func insert(value: T) {
        if value < self.value {
            if let left = left {
                left.insert(value: value)
            } else {
                left = BinarySearchTree(value: value)
                left?.parent = self
            }
        } else {
            if let right = right {
                right.insert(value: value)
            } else {
                right = BinarySearchTree(value: value)
                right?.parent = self
            }
        }
    }
}

// MARK: - Deleting items
extension BinarySearchTree {
    /**
     Delete a node from the tree.
     Return the node that has replaced this removed one (or nil if this was a leaf node). That is primarily useful for when you delete the root node, in which case the tree gets a new root.
     Performance: runs in O(h) time, where h is the height of the tree.
     */
    @discardableResult public func remove() -> BinarySearchTree? {
        let replacement: BinarySearchTree?
        
        // Replacement for current node can be either biggest one on the left or smallest one on the right, whichever is not nil.
        if let right = right {
            replacement = right.minimum()
        } else if let left = left {
            replacement = left.maximum()
        } else {
            replacement = nil
        }
        
        replacement?.remove()
        
        // Place the replacement on current node's position.
        replacement?.right = right
        replacement?.left = left
        right?.parent = replacement
        left?.parent = replacement
        reconnectParentTo(node:replacement)
        
        // The current node is no longer part of the tree, so clean it up.
        parent = nil
        left = nil
        right = nil
        
        return replacement
    }
    
    private func reconnectParentTo(node: BinarySearchTree?) {
        if let parent = parent {
            if isLeftChild {
                parent.left = node
            } else {
                parent.right = node
            }
        }
        node?.parent = parent
    }
}

// MARK: - Searching
extension BinarySearchTree {
    /**
     Finds the "highest" node with the specified value.
     Performance: runs in O(h) time, where h is the height of the tree.
     */
    public func search(value: T) -> BinarySearchTree? {
        var node: BinarySearchTree? = self
        while case let n? = node {
            if value < n.value {
                node = n.left
            } else if value > n.value {
                node = n.right
            } else {
                return node
            }
        }
        return nil
    }
    
    /*
    // Recursive version of search
    public func search(value: T) -> BinarySearchTree? {
        if value < self.value {
            return left?.search(value)
        } else if value > self.value {
            return right?.search(value)
        } else {
            return self  // found it!
        }
    }
    */
    
    /**
     Contrain this value or not
     */
    public func contains(value: T) -> Bool {
        return search(value: value) != nil
    }
    
    /**
     Return the left most descendent. O(h) time.
     */
    public func minimum() -> BinarySearchTree {
        var node = self
        while case let next? = node.left {
            node = next
        }
        return node
    }
    
    /**
     Return the right most descendent. O(h) time.
     */
    public func maximum() -> BinarySearchTree {
        var node = self
        while case let next? = node.right {
            node = next
        }
        return node
    }
    
    /**
     Calculate the depth of this node, i.e. the distance to the root.
     Take O(h) time.
     */
    public func depth() -> Int {
        var node = self
        var edges = 0
        while case let parent? = node.parent {
            node = parent
            edges += 1
        }
        return edges
    }
    
    /**
     Calculate the height of this node, i.e., the distance to the lowest leaf.
     Since this looks at all children of this node, performance is O(n).
     */
    public func height() -> Int {
        if isLeaf {
            return 0
        } else {
            return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
        }
    }
    
    /**
     Find the node whose value precedes our value in sorted order.
     */
    public func predecessor() -> BinarySearchTree<T>? {
        if let left = left {
            return left.maximum()
        } else {
            var node = self
            while case let parent? = node.parent {
                if parent.value < value { return parent }
                node = parent
            }
            return nil
        }
    }
    
    /*
     Find the node whose value succeeds our value in sorted order.
     */
    public func successor() -> BinarySearchTree<T>? {
        if let right = right {
            return right.minimum()
        } else {
            var node = self
            while case let parent? = node.parent {
                if parent.value > value { return parent }
                node = parent
            }
            return nil
        }
    }
}

// MARK: - Traversal
extension BinarySearchTree {
    public func traverseInOrder(process: (T) -> Void) {
        left?.traverseInOrder(process: process)
        process(value)
        right?.traverseInOrder(process: process)
    }
    
    public func traversePreOrder(process: (T) -> Void) {
        process(value)
        left?.traversePreOrder(process: process)
        right?.traversePreOrder(process: process)
    }
    
    public func traversePostOrder(process: (T) -> Void) {
        left?.traversePostOrder(process: process)
        right?.traversePostOrder(process: process)
        process(value)
    }
    
    /**
     Perform an in-order traversal and collects the results in an array.
     It calls the formula closure on each node in the tree and collects the results in an array. map() works by traversing the tree in-order.
     */
    public func map(formula: (T) -> T) -> [T] {
        var a = [T]()
        if let left = left { a += left.map(formula: formula) }
        a.append(formula(value))
        if let right = right { a += right.map(formula: formula) }
        return a
    }
}

/**
 Is this binary tree a valid binary search tree?
 */
extension BinarySearchTree {
    public func isBST(minValue: T, maxValue: T) -> Bool {
        if value < minValue || value > maxValue { return false }
        let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
        let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
        return leftBST && rightBST
    }
}

// MARK: - Debugging
extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        var s = ""
        if let left = left {
            s += "(\(left.description)) <- "
        }
        s += "\(value)"
        if let right = right {
            s += " -> (\(right.description))"
        }
        return s
    }
    
    public func toArray() -> [T] {
        return map { $0 }
    }
}

let tree = BinarySearchTree<Int>(value: 7)
tree.insert(value: 2)
tree.insert(value: 5)
tree.insert(value: 10)
tree.insert(value: 9)
tree.insert(value: 1)

let toDelete = tree.search(value: 1)
toDelete?.remove()
tree

let tree2 = BinarySearchTree<Int>(array: [7, 2, 5, 10, 9, 1])

tree.search(value: 5)
tree.search(value: 2)
tree.search(value: 7)
tree.search(value: 6)

tree.traverseInOrder { value in print(value) }

tree.toArray()

tree.minimum()
tree.maximum()

if let node2 = tree.search(value: 2) {
    node2.remove()
    node2
    print(tree)
}

tree.height()
tree.predecessor()
tree.successor()

if let node10 = tree.search(value: 10) {
    node10.depth() // 1
    node10.height() // 1
    node10.predecessor()
    node10.successor() // nil
}

if let node9 = tree.search(value: 9) {
    node9.depth() // 2
    node9.height() // 0
    node9.predecessor()
    node9.successor()
}

if let node1 = tree.search(value: 1) {
    // This makes it an invalid binary search tree because 100 is greater than the root, 7, and so must be in the right branch not in the left.
    tree.isBST(minValue: Int.min, maxValue: Int.max)  // true
    node1.insert(value: 100)
    tree.search(value: 100) // nil
    tree.isBST(minValue: Int.min, maxValue: Int.max)  // false
}
