import std/strutils

let f = splitLines(readFile("real.txt"))

type
  Vec = tuple[x:int,y:int, value:int, visable:bool ]

var
  trees: seq[Vec]
proc reverse*(str: string): string =
    result = ""
    for index in countdown(str.high, 0):
        result.add(str[index])

proc isVisable(vec:Vec,data:string ): bool =
    var shouldAdd:bool = true
    for x, elem in data:
        if x == vec.x:
            #we should add since if we find biggest from left first we break
            break
        elif parseInt($elem) >= vec.value:
            shouldAdd = false
            break
            
    if shouldAdd:
        return true
    
    var count = data.len-1
    shouldAdd = true

    while (vec.x-count) != 0:
        if parseInt($data[count]) >= vec.value:
            shouldAdd= false
            break
        count -= 1

    if shouldAdd:
        return true

    return false

var maxY=0
var maxX=0

#count other visable 
for y, elem in f:
    if y > maxY:
        maxY = y
    for x, innerElem in elem:
        if x > maxX:
            maxX = x
        var vec:Vec
        vec.x = x
        vec.y = y
        vec.value = parseInt($innerElem)    
        if x == 0 or y == 0 or x == (elem.len-1) or y == f.len-1:
            vec.visable = true
        else:
           vec.visable = isVisable(vec,elem)

        trees.insert(vec)
            

for y,_ in f:
    var str = ""
    for elem in trees:
        if elem.x == y:
            str.add($elem.value)

    for i in 0..(trees.len-1):
        let tempTree =trees[i]
        if tempTree.x == y and tempTree.visable == false:
            let reversed = str.reverse()
            #reverse x,y 
            let xySwap:Vec =(x:tempTree.y, y:tempTree.x, value:tempTree.value, visable:false)
            trees[i].visable = isVisable(xySwap, reversed)


var visable = 0

for tree in trees:
    if tree.visable:
        visable += 1

echo "Part one: ", visable


proc findTree(x:int, y:int):Vec =
    for tree in trees:
        if tree.x == x and tree.y == y:
            return tree

proc distanceView(tree:Vec):int = 
    

    
    var up,down,left,right = 0

    #up
    var count = tree.y-1
    while count >= 0:
        up+=1
        let tempTree = findTree(tree.x,count)
        if(tempTree.value >= tree.value):
            break;
        count-=1

    #down
    count = tree.y+1
    for i in count..maxY:
        down+=1
        let tempTree = findTree(tree.x,i)
        if(tempTree.value >= tree.value):
                break;

    #left
    count = tree.x-1
    while count >= 0:
        left+=1
        
        let tempTree = findTree(count, tree.y)
        if(tempTree.value >= tree.value):
            break;
        count-=1
        
       

    #right
    count = tree.x+1
    for i in count..maxX:
        right+=1
        let tempTree = findTree(i, tree.y)
        if(tempTree.value >= tree.value):
            break;
        

    let score = up * left *  down * right
    return score 


var biggest = 0
var biggestVec:Vec

for tree in trees:
    let score = distanceView(tree)
    if score > biggest:
        biggest = score
        biggestVec = tree

echo "Part two:", biggest



