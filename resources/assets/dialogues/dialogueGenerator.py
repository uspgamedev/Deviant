import sys
import json

FUNCTIONS = {
    'faceShow' : [('char', 'name'), ('pos', 'num')],
    'faceHide' : [('char', 'name'), ('pos', 'num')],
    'dialogueShow' : [('pos', 'num'), ('text', 'strlist')],
    'choose' : [('text', 'str'), ('opts', 'strlist'), ('goto', 'strlist')],
    'say' : [('text', 'strlist')],
    'special' : [('targ', 'name')],
    'changeDialogue' : [('char', 'name'), ('dial', 'str')],
    'jump' : [('to', 'num')],
    'End' : []
}

ORDINAL = ["first", "second", "third"]

def divide(s, idx):
    return [s[:idx], s[idx:]]

def read_until(s, chars):
    i = 0
    while (i < len(s) and ((s[i] not in chars) or (i != 0 and s[i-1] == "\\"))):
        i += 1
    return i

def main():
    if (len(sys.argv) < 2):
        print("You have to specify an input file and an output file!!")
        exit()
    f = open(sys.argv[1])
    out_file = {}
    for i, line in enumerate(f, start=1):
        j = read_until(line, ["(", "\n"])
        i = str(i)
        if (line[j] == "\n"):
            print(f"Error: Can't identify the function at line {i}")
            f.close()
            exit()
        func, args = divide(line, j)
        func = func.strip()
        args = args.strip().strip("()")
        arg_types = FUNCTIONS.get(func)
        if (arg_types == None):
            print(f"Error: Don't know the function {func} at line {i}")
            f.close()
            exit()
        out_file[i] = {}
        out_file[i]["func"] = func
        for k, pair in enumerate(arg_types):
            name, t = pair
            if not args:
                print(f"Error: Wrong number of arguments for function {func} at line {i}, expected {len(arg_types)}, got {k}")
            if t == "num":
                j = read_until(args, ",")
                num = args[:j].strip()
                args = args[j+1:]
                if not num.isnumeric():
                    print(f"Error: Expected number as {ORDINAL[k]} argument of function {func} at line {i}")
                    f.close()
                    exit()
                out_file[i][name] = int(num)
            elif t == "str":
                j = read_until(args, "\"")
                args = args[j+1:]
                j = read_until(args, "\"")
                s = args[:j]
                args = args[j+1:]
                if not s and j != 0:
                    print(f"Error: Expected string as {ORDINAL[k]} argument of function {func} at line {i}")
                    f.close()
                    exit()
                j = read_until(args, ",")
                args = args[j+1:]
                out_file[i][name] = s
            elif t == "name":
                j = read_until(args, ",")
                s = args[:j].strip()
                args = args[j+1:]
                if " " in s:
                    print(f"Error: Not expected space at the {ORDINAL[k]} argument of function {func} at line {i}")
                    f.close()
                    exit()
                out_file[i][name] = s
            elif t == "strlist":
                j = read_until(args, "[")
                args = args[j+1:]
                j = read_until(args, "]")
                s = args[:j]
                args = args[j+1:]
                l = []
                while s:
                    j = read_until(s, "\"")
                    s = s[j+1:]
                    if not s:
                        break
                    j = read_until(s, "\"")
                    l.append(s[:j])
                    s = s[j+1:]
                    j = read_until(s, ",")
                    s = s[j+1:]
                out_file[i][name] = l
            elif t == "numlist":
                j = read_until(args, "[")
                args = args[j+1:]
                j = read_until(args, "]")
                s = args[:j]
                args = args[j+1:]
                l = []
                while s:
                    j = read_until(args, ",")
                    num = args[:j].strip()
                    args = args[j+1:]
                    if (not num.isnumeric()):
                        print(f"Error: Expected a list of numbers as {ORDINAL[k]} argument of function {func} at line {i}")
                        f.close()
                        exit()
                    l.append(int(num))
            else:
                print("You ta de frescation with me >:(")
    g = open(sys.argv[2], "wb+")
    g.write(json.dumps(out_file, indent=4, ensure_ascii=False).encode("utf8"))
    g.close()
    f.close()

if __name__ == "__main__":
    main()
