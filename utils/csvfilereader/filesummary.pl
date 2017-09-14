my $n = 0;
my @words = ();

open(FILE, $ARGV[0]);
while ($row=<FILE>) {
    if ($. eq 1) {
        @words = split($ARGV[1],$row);
        $n = @words;
    }
};
print "$. $n";