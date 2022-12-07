def toString(s):
    returnSr =""
    for str in s:
        returnSr += "/" + str

    if len(returnSr) == 0:
        returnSr ="/"
    return returnSr

f = open("real.txt", "r")
lines = f.readlines()

folders = {}


path = "/"
folderSize = {}
for line in lines:
    if(line.strip()[0] == "$"):
        command = line.strip()[2:4]
        if command == "cd":
            input = line.strip()[5:]
            folderSize = {}
            if input == "..":   
                paths =  path.split("/")
                if len(paths) > 1:
                    path = toString(paths[1:(len(paths)-1)])
            else:
                if path != input:
                    if input == "/":
                        path = "/"
                    elif path == "/":
                        path += input
                    else:
                        path += "/" +input
                if path not in folders:
                    folders[path] = {}
            
    else:
        if line.strip()[0].isnumeric():
            file = line.strip().split(" ")
            folderSize[file[1]] = file[0]
            folders[path] =folderSize

folderSum = {}

for key in folders:
    data = folders[key]
    value = 0
    for file in data:
        value += int(data[file])
    folderSum[key] = value

def allSubDir(path):
    if(path == "/"):
        return []
    folders = path.split("/")[1:]
    returnFolders = []
    currentFolder=""
    for folder in folders:
        currentFolder += "/" + folder
        if currentFolder !=path:
            returnFolders += [ currentFolder]
    return ["/"] + returnFolders

def addForSubDir(key):
    dirs = allSubDir(key)
    for dir in dirs:
        sum = folderSum[dir]
        sum += folderSum[key]
        folderSum[dir] = sum
        

for key in folderSum:
    addForSubDir(key)

partOneSum = 0

for key in folderSum:
    if folderSum[key] < 100000:
        partOneSum+=folderSum[key]

print("partOne: ",partOneSum)

print("total free space : ", 70000000 - folderSum["/"] )
spaceNeed =  30000000 - (70000000 - folderSum["/"])
print("space needed: ", spaceNeed)
closest = 0
for key in folderSum:
    if folderSum[key] > spaceNeed:
        if closest == 0 or folderSum[key] < closest:
            closest = folderSum[key]

print("part two:", closest)