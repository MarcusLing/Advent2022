use std::collections::HashMap;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    let mut map: HashMap<u8, Vec<char>> = HashMap::new();
    let part_one = false;

    if let Ok(lines) = read_lines("./dataInput.txt") {
        let mut parsed_map = false;
        for line in lines {
            if let Ok(line) = line {
                if line.len() > 0 {
                    let chars: Vec<_> = line.chars().collect();
                    if !parsed_map {
                        let chucks = chars.chunks(4);

                        let mut index: u8 = 0;

                        for chunk in chucks {
                            index += 1;

                            let mut contain: Vec<char> = Vec::new();
                            if let Some(v) = map.get(&index) {
                                contain = v.to_vec();
                            }

                            if chunk[0] == '[' {
                                contain.insert(0, chunk[1]);
                            }

                            map.insert(index, contain);
                        }
                    } else {
                        let mut select: u32 = 0;

                        let mut from_index = 0;
                        let mut to_index = 0;

                        let mut value_placement = 0;
                        if line.len() > 18 {
                            value_placement += 1;
                        }

                        if let Some(v) = chars[12 + value_placement].to_digit(10) {
                            from_index = v as u8;
                        }
                        if let Some(v) = chars[17 + value_placement].to_digit(10) {
                            to_index = v as u8;
                        }

                        if let Some(v) = chars[5 + value_placement].to_digit(10) {
                            if value_placement > 0 {
                                if let Some(adder) = chars[5].to_digit(10) {
                                    select = v + adder * 10;
                                }
                            } else {
                                select = v;
                            }
                        }

                        let mut from_vec: Vec<char>;

                        if let Some(v) = map.get(&from_index) {
                            from_vec = v.to_vec();
                        } else {
                            from_vec = Vec::new();
                        }

                        let mut to_vec: Vec<char>;

                        if let Some(v) = map.get(&to_index) {
                            to_vec = v.to_vec();
                        } else {
                            to_vec = Vec::new();
                        }

                        let mut add: Vec<char> = Vec::new();
                        for _ in 0..select {
                            match from_vec.pop() {
                                Some(value) => {
                                    if part_one {
                                        to_vec.push(value);
                                    } else {
                                        add.insert(0, value);
                                    }
                                }
                                None => (),
                            }
                        }

                        map.insert(from_index, from_vec);
                        if part_one {
                            map.insert(to_index, to_vec);
                        } else {
                            map.insert(to_index, [to_vec, add].concat());
                        }
                    }
                } else {
                    parsed_map = true;
                }
            }
        }
    }
    print_result(map.clone());
}


fn print_result(map: HashMap<u8, Vec<char>>) {
    for i in 0..map.len() + 1 {
        if let Some(v) = map.get(&(i as u8)) {
            if let Some(last) = v.last() {
                print!("{}", last);
            }
        }
    }

    println!();
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}
