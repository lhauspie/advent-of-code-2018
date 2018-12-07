type dependency = {src : char; dest : char;}

(* function that transforms a string of type "Step A must be finished before step B can begin." to a dependency {src='A', dest='B'} *)
let to_dependency = function s -> {src=s.[5]; dest=s.[36]};;
let display = function d -> print_char d.src; print_char d.dest; print_char '\n'

let by_source source dependency = dependency.src != source
let by_sources sources dependency = 
  match sources with
  | [] -> false
  | sources -> dependency.src != (List.hd sources)

let sources_of dependencies = List.map (function d->d.src) dependencies
let destinations_of dependencies = List.map (function d->d.dest) dependencies

let diff l1 l2 = List.filter (fun x -> not (List.mem x l2)) l1

let char_list_to_string char_list = String.concat "" (List.map (String.make 1) char_list)



let input_line_opt ic =
  try Some (input_line ic)
  with End_of_file -> None
 
let read_lines ic =
  let rec aux acc =
    match input_line_opt ic with
    | Some line -> aux (line::acc)
    | None -> (List.rev acc)
  in
  aux []

let lines_of_file filename =
  let in_chanel = open_in filename in
  let lines = read_lines in_chanel in
  close_in in_chanel;
  (lines)

let dependendcies_from_file =
  let lines = lines_of_file "input.txt" in
  List.map to_dependency lines


let char_comparator char_a char_b = (Char.code char_a) - (Char.code char_b)

(*rec stands for resursive*)
let rec extract_instructions dependencies all_sources = 
  match dependencies with 
  | [] -> 
          let sorted_sources = List.sort_uniq char_comparator all_sources in
          (* char_list_to_string *) sorted_sources
  | deps ->  
          let sources = sources_of deps in (*extract the list of all sources*)
          let destinations = destinations_of deps in  (*extract the list of all destinations*)
          let available_sources = diff sources destinations in (*extract the list of sources that are not a destination*)
          let sorted_sources = List.sort_uniq char_comparator available_sources in (*sort and deduplicate the list of available sources*)
          let filtered_deps = List.filter (by_sources sorted_sources) deps in (*remove dep with src in sources *)
          let first_source = List.hd sorted_sources in (*take only the first char*)
          let filtered_sources = List.filter (function source -> source != first_source) all_sources in
          first_source :: extract_instructions filtered_deps filtered_sources (*first_source ^ (extract_instructions filtered_deps)*)


let () =
  let dependencies = dependendcies_from_file in
  let all_sources = List.append (sources_of dependencies) (destinations_of dependencies) in
  let instructions = extract_instructions dependencies all_sources in
  print_endline (char_list_to_string instructions)