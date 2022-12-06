import std.stdio;
import std.file;

void main()
{
    File file = File("real.txt", "r");
    char[] test = file.readln().dup;

    bool partOne = false;

    int startPos = 0;
    int readExtraBytes = 4;

    if (!partOne)
    {
        readExtraBytes = 14;
    }

    while ((startPos + readExtraBytes) < test.length)
    {
        char[] match = test[startPos .. (startPos + readExtraBytes)];

        if (findFirstPackage(match))
        {
            writeln(startPos + readExtraBytes);
            break;
        }
        startPos++;
    }
}

bool findFirstPackage(char[] data)
{
    // if we have more then 1 match its not unique char array
    int matches = 0;
    int index = 0;

    while (index < data.length)
    {
        char compare = data[index];

        for (int i = 0; i < data.length; i++)
        {
            if (i != index && compare == data[i])
            {
                matches++;
            }
        }
        index++;
    }
    return matches < 2;
}
