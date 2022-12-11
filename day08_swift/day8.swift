import Foundation

let fileURL: URL = URL(fileURLWithPath: CommandLine.arguments[1])

let fileContents: String = try String(contentsOf: fileURL)

let lines: [String] = fileContents.components(separatedBy: .newlines)

var forest: [[(height: Int, visible: Bool, view: [Int])]] = 
    lines.map { line in line.compactMap { 
        Int(String($0)) 
    }.map { 
        (height: $0, visible: false, view: [0, 0, 0, 0]) }
    }

// part 1: nice

// LR vis check pass
for i: Int in 0..<forest.count {
    var rowBigDawg: Int = -1
    for j: Int in 0..<forest[0].count {
        let thisTreesHeight: Int = forest[i][j].height
        if thisTreesHeight > rowBigDawg {
            forest[i][j].visible = true
            rowBigDawg = thisTreesHeight
        }
    }
}

// RL vis check pass
for i: Int in 0..<forest.count {
    var rowBigDawg: Int = -1
    for j: Int in (0..<forest[0].count).reversed() { // what is this shit
        let thisTreesHeight: Int = forest[i][j].height
        if thisTreesHeight > rowBigDawg {
            forest[i][j].visible = true
            rowBigDawg = thisTreesHeight
        }
    }
}

// TD vis check pass
for i: Int in 0..<forest[0].count {
    var rowBigDawg: Int = -1
    for j: Int in (0..<forest.count) { 
        let thisTreesHeight: Int = forest[j][i].height
        if thisTreesHeight > rowBigDawg {
            forest[j][i].visible = true
            rowBigDawg = thisTreesHeight
        }
    }
}

// DT vis check pass
for i: Int in 0..<forest[0].count {
    var rowBigDawg: Int = -1
    for j: Int in (0..<forest.count).reversed() { 
        let thisTreesHeight: Int = forest[j][i].height
        if thisTreesHeight > rowBigDawg {
            forest[j][i].visible = true
            rowBigDawg = thisTreesHeight
        }
    }
}

// part 2: probably not optimal idk
for i: Int in 0..<forest.count {
    for j: Int in 0..<forest[0].count {
        // go right
        let thisTreesHeight: Int = forest[i][j].height
        var seent: Bool = false
        var count: Int = 0
        for k: Int in j+1..<forest[0].count {
            if !seent {
                if forest[i][k].height < thisTreesHeight {
                    count += 1
                } else {
                    count += 1
                    seent = true
                }
            }
        }
        forest[i][j].view[0] = count

        // go left
        seent = false
        count = 0
        for k: Int in (0..<j).reversed() {
            if !seent {
                if forest[i][k].height < thisTreesHeight {
                    count += 1
                } else {
                    count += 1
                    seent = true
                }
            }
        }
        forest[i][j].view[1] = count

        // go down
        seent = false
        count = 0
        for k: Int in i+1..<forest.count {
            if !seent {
                if forest[k][j].height < thisTreesHeight {
                    count += 1
                } else {
                    count += 1
                    seent = true
                }
            }
        }
        forest[i][j].view[2] = count

        // go up
        seent = false
        count = 0
        for k: Int in (0..<i).reversed() {
            if !seent {
                if forest[k][j].height < thisTreesHeight {
                    count += 1
                } else {
                    count += 1
                    seent = true
                }
            }
        }
        forest[i][j].view[3] = count
    }
}

// get answer
var visibleCount:Int = 0
var maxScore:Int = 0
for row in forest {
    for tree in row {
        if tree.visible {
            visibleCount += 1
        }
        maxScore = max(maxScore, tree.view.reduce(1, *)) // ok this is dope
    }
}
print("There are \(visibleCount) visible trees.")
print("The highest scenic score is \(maxScore)!")

