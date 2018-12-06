sub stripchars {
    my ($s, $chars) = @_;
    $s =~ s/[$chars]//g;
    return $s;
}
 
print stripchars("She was xX a soul striXxpper. She took my xxheart!", "aei"), "\n";