use std::collections::HashMap;
use std::env;
use std::fs;

fn blink(stones: &[String], cache: &mut HashMap<String, Vec<String>>) -> Vec<String> {
    let mut new_stones = Vec::new();

    for stone in stones {
        if let Some(cached) = cache.get(stone) {
            // Use cached result
            new_stones.extend(cached.clone());
        } else {
            // Compute and store result in cache
            let result = if stone == "0" {
                vec!["1".to_string()]
            } else if stone.len() % 2 == 0 {
                let mid = stone.len() / 2;
                vec![
                    stone[0..mid].to_string(),
                    stone[mid..].to_string(),
                ]
            } else {
                vec![(stone.parse::<u64>().unwrap() * 2024).to_string()]
            };
            cache.insert(stone.clone(), result.clone());
            new_stones.extend(result);
        }
    }

    new_stones
}

fn main() {
    // Read input file
    let args: Vec<String> = env::args().collect();
    let default_input = "input".to_string();
    let input_file = args.get(1).unwrap_or(&default_input);
    let line = fs::read_to_string(input_file).expect("Failed to read input file");
    let mut stones: Vec<String> = line.trim().split_whitespace().map(String::from).collect();

    // Initialize cache
    let mut cache: HashMap<String, Vec<String>> = HashMap::new();
    cache.insert("0".to_string(), vec!["1".to_string()]);

    // Perform 25 blinks
    for _ in 0..25 {
        stones = blink(&stones, &mut cache);
    }

    println!("Total stones after 25 blinks: {}", stones.len());

    // Perform additional 50 blinks and collect statistics
    let mut totals = Vec::new();
    for i in 0..50 {
        stones = blink(&stones, &mut cache);
        totals.push(stones.len());
        if i > 0 {
            let diff = totals[i] as i64 - totals[i - 1] as i64;
            println!(
                "{} {} diff: {} cache_size: {}",
                i, totals[i], diff, cache.len()
            );
        }
    }

    println!("Final total stones count: {}", stones.len());
}
