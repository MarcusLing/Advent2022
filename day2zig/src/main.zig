const std = @import("std");
const ascii = std.ascii;
const io = std.io;
const fs = std.fs;
const print = std.debug.print;

const RPS = enum(u8) { NONE = 99, ROCK = 1, PAPER = 2, SCISSORS = 3 };
const OutCome = enum(u8) { NONE = 99, WIN = 6, DRAW = 3, LOOSE = 0 };

const GamePlayPartOne = struct {
    const Self = @This();
    player: RPS,
    opponent: RPS,

    pub fn init(opponent: u8, player: u8) Self {
        return Self{
            .player = whatRPS(player),
            .opponent = whatRPS(opponent),
        };
    }

    fn whatRPS(value: u8) RPS {
        return switch (value) {
            'A', 'X' => RPS.ROCK, //ROCK
            'B', 'Y' => RPS.PAPER, //Paper
            'C', 'Z' => RPS.SCISSORS, //Scissors

            else => RPS.NONE,
        };
    }

    pub fn gameScore(self: Self) u8 {
        var score = @enumToInt(self.player);

        if ((self.player == RPS.ROCK and self.opponent == RPS.SCISSORS) or
            (self.player == RPS.PAPER and self.opponent == RPS.ROCK) or
            (self.player == RPS.SCISSORS and self.opponent == RPS.PAPER))
        {
            score += 6;
        } else if (self.player == self.opponent) {
            score += 3;
        }

        return score;
    }
};

const GamePlayPartTwo = struct {
    const Self = @This();
    player: OutCome,
    opponent: RPS,

    pub fn init(opponent: u8, player: u8) Self {
        return Self{
            .player = whatOutCome(player),
            .opponent = whatRPS(opponent),
        };
    }

    fn whatRPS(value: u8) RPS {
        return switch (value) {
            'A' => RPS.ROCK,
            'B' => RPS.PAPER,
            'C' => RPS.SCISSORS,

            else => RPS.NONE,
        };
    }

    fn whatOutCome(value: u8) OutCome {
        return switch (value) {
            'Z' => OutCome.WIN,
            'Y' => OutCome.DRAW,
            'X' => OutCome.LOOSE,

            else => OutCome.NONE,
        };
    }

    pub fn gameScore(self: Self) u8 {
        var score = @enumToInt(self.player);

        if (self.player == OutCome.WIN) {
            score += switch (self.opponent) {
                RPS.PAPER => @enumToInt(RPS.SCISSORS),
                RPS.ROCK => @enumToInt(RPS.PAPER),
                RPS.SCISSORS => @enumToInt(RPS.ROCK),

                else => 0,
            };
        } else if (self.player == OutCome.LOOSE) {
            score += switch (self.opponent) {
                RPS.PAPER => @enumToInt(RPS.ROCK),
                RPS.ROCK => @enumToInt(RPS.SCISSORS),
                RPS.SCISSORS => @enumToInt(RPS.PAPER),

                else => 0,
            };
        } else {
            score += @enumToInt(self.opponent);
        }

        return score;
    }
};

pub fn filePath(fileName: []const u8) ![]u8 {
    var bufPath: [512]u8 = undefined;
    const systemPath = (try std.fs.cwd().realpath(".", &bufPath));
    var index = systemPath.len;
    for (fileName) |value| {
        bufPath[index] = value;
        index = index + 1;
    }

    return bufPath[0..index];
}

fn summaryCaluclationPartOne(fileName: []const u8) !u32 {
    const path = try filePath(fileName);
    const dir: fs.Dir = fs.cwd();

    const file: fs.File = try dir.openFile(path, .{});
    defer file.close();
    var buf_reader = io.bufferedReader(file.reader());

    var dynamic_string = std.ArrayList(GamePlayPartOne).init(std.heap.page_allocator);
    defer dynamic_string.deinit();
    var buf: [8000]u8 = undefined;
    while (try buf_reader.reader().readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try dynamic_string.append(GamePlayPartOne.init(line[0], line[2]));
    }

    var totalScore: u32 = 0;
    while (dynamic_string.popOrNull()) |next| {
        totalScore += next.gameScore();
    }

    return totalScore;
}

fn summaryCaluclationPartTwo(fileName: []const u8) !u32 {
    const path = try filePath(fileName);
    const dir: fs.Dir = fs.cwd();

    const file: fs.File = try dir.openFile(path, .{});
    defer file.close();
    var buf_reader = io.bufferedReader(file.reader());

    var dynamic_string = std.ArrayList(GamePlayPartTwo).init(std.heap.page_allocator);
    defer dynamic_string.deinit();
    var buf: [8000]u8 = undefined;
    while (try buf_reader.reader().readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try dynamic_string.append(GamePlayPartTwo.init(line[0], line[2]));
    }

    var totalScore: u32 = 0;
    while (dynamic_string.popOrNull()) |next| {
        totalScore += next.gameScore();
    }

    return totalScore;
}

pub fn main() !void {
    print("Total score part one: {d} \n", .{try summaryCaluclationPartOne("/assets/plays.txt")});
    print("Total score part two: {d} \n", .{try summaryCaluclationPartTwo("/assets/plays.txt")});
}

test "run with mockData" {
    const value = try summaryCaluclationPartOne("/assets/test.txt");
    try std.testing.expect(value == 15);
}

test "run with realData" {
    const value = try summaryCaluclationPartOne("/assets/plays.txt");
    try std.testing.expect(value == 12276);
}
