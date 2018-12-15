fn main() {
    println!("{:?}", calculate_recipes(793031));
    println!("{:?}", find_recipes(vec![7,9,3,0,3,1]));
}


fn score(scoreboard:&mut Vec<usize>, first_elve_index: usize, second_elve_index: usize) {
    let new_score;
    { // this block of code is used to be able to get values from mutable vec ==> https://stackoverflow.com/a/47619305
        let first_score = scoreboard.get(first_elve_index).unwrap();
        let second_score = scoreboard.get(second_elve_index).unwrap();
        new_score = first_score + second_score;
    }
    
    let tens = new_score / 10;
    if tens > 0 {
        scoreboard.push(tens);
    }
    scoreboard.push(new_score % 10);
}

fn new_elves_index(scoreboard:&mut Vec<usize>, first_elve_index: usize, second_elve_index: usize) -> (usize, usize) {
    let first_score = scoreboard.get(first_elve_index).unwrap();
    let second_score = scoreboard.get(second_elve_index).unwrap();

    let mut new_first_elve_index = first_elve_index + first_score + 1;
    let mut new_second_elve_index = second_elve_index + second_score + 1;

    if new_first_elve_index >= scoreboard.len() {
        new_first_elve_index = new_first_elve_index % scoreboard.len();
    }

    if new_second_elve_index >= scoreboard.len() {
        new_second_elve_index = new_second_elve_index % scoreboard.len();
    }

    return (new_first_elve_index, new_second_elve_index);
}

fn calculate_recipes(input:usize) -> Vec<usize> {
    let mut scoreboard = vec![3, 7];
    let mut first_elve_index = 0;
    let mut second_elve_index = 1;

    while scoreboard.len() < (input+10) {
        score(&mut scoreboard, first_elve_index, second_elve_index);
        let elves = new_elves_index(&mut scoreboard, first_elve_index, second_elve_index);
        first_elve_index = elves.0;
        second_elve_index = elves.1;
    }

    let ten_scores = scoreboard.get(input..input+10).unwrap();
    return ten_scores.to_vec();
}

fn find_recipes(recipes:Vec<usize>) -> usize {
    let recipes_length = recipes.len();
    let recipes_to_search = Some(recipes);

    let mut scoreboard = vec![3, 7];
    let mut first_elve_index = 0;
    let mut second_elve_index = 1;

    let mut scoreboard_length;
    let mut ten_scores = None;
    let mut recipe_found = 0;
    while ten_scores != recipes_to_search {
        score(&mut scoreboard, first_elve_index, second_elve_index);
        let elves = new_elves_index(&mut scoreboard, first_elve_index, second_elve_index);
        first_elve_index = elves.0;
        second_elve_index = elves.1;
        
        scoreboard_length = scoreboard.len();
        if scoreboard_length > recipes_length {
            ten_scores = scoreboard.get(scoreboard_length-recipes_length..scoreboard_length).map(|scores| scores.to_vec());
            recipe_found = scoreboard_length - recipes_length;
            // as making new recipes can add 2 recipe we also have to check the previous list of recipes (index - 1)
            if ten_scores != recipes_to_search {
                ten_scores = scoreboard.get(scoreboard_length-recipes_length-1..scoreboard_length-1).map(|scores| scores.to_vec());
                recipe_found = scoreboard_length - recipes_length -1;
            }
        }
    }

    return recipe_found;
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn first_score_3_7() {
        let mut scoreboard = vec![3, 7];
        score(&mut scoreboard, 0, 1);
        println!("{:?}", scoreboard);
        assert_eq!(scoreboard.len(), 4);
        assert_eq!(scoreboard.get(2).map(|&score| score), Some(1));
        assert_eq!(scoreboard.get(3).map(|&score| score), Some(0));
    }

    #[test]
    fn first_score_1_0() {
        let mut scoreboard = vec![1, 0];
        score(&mut scoreboard, 0, 1);
        assert_eq!(scoreboard.len(), 3);
        assert_eq!(scoreboard.get(2).map(|&score| score), Some(1));
    }

    #[test]
    fn new_elves_index_3_7() {
        let mut scoreboard = vec![3, 7];
        let new_elves_index = new_elves_index(&mut scoreboard, 0, 1);
        assert_eq!(new_elves_index.0, 0);
        assert_eq!(new_elves_index.1, 1);
    }

    #[test]
    fn new_elves_index_1_0() {
        let mut scoreboard = vec![1, 0];
        let new_elves_index = new_elves_index(&mut scoreboard, 0, 1);
        assert_eq!(new_elves_index.0, 0);
        assert_eq!(new_elves_index.1, 0);
    }

    #[test]
    fn calculate_recipes_9() {
        let ten_scores = calculate_recipes(9);
        assert_eq!(ten_scores, vec![5,1,5,8,9,1,6,7,7,9])
    }

    #[test]
    fn find_recipes_7_1_0_1_0_1_2_4_5_1() {
        let recipe = find_recipes(vec![7,1,0,1,0,1,2,4,5,1]);
        assert_eq!(recipe, 1);
    }

    #[test]
    fn find_recipes_7_1_0_1() {
        let recipe = find_recipes(vec![7,1,0,1]);
        assert_eq!(recipe, 1);
    }

    #[test]
    fn find_recipes_5_1_5_8_9_1_6_7_7_9() {
        let recipe = find_recipes(vec![5,1,5,8,9,1,6,7,7,9]);
        assert_eq!(recipe, 9);
    }

    #[test]
    fn find_recipes_6_7_7_9() {
        let recipe = find_recipes(vec![6,7,7,9]);
        assert_eq!(recipe, 15);
    }
}