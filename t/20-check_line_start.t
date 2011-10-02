#!/usr/bin/perl

use Test::More;
use Text::Parts;
use strict;

my $p = Text::Parts->new();

my @test =
  (
   {
    t => "111111111111111111111111111111111\n1111111111111111\n111",
    seek => 5,
   },
   {
    #     123456789012345678901234567890
    t => "111111111111111111111111111111111\n1111111111111111\n111",
    seek => 33,
   },
   {
    #     123456789012345678901234567890123
    t => "111111111111111111111111111111111\n1111111111111111\n111",
    seek => 35,
   },
   {
    #     123456789012345678901234567890123
    t => join("\n", map {$_ x 600} (1 .. 3)),
    seek => 1000,
   },
  );

my @answer =
  (
   "111111111111111111111111111111111\n",
   "111111111111111111111111111111111\n",
   "1111111111111111\n",
   ("2" x 600 . "\n"),
  );


for my $i (0 .. $#test) {
  my $txt = $test[$i]->{t};
  open my $fh, '<', \$txt or die $!;
  seek $fh, $test[$i]->{seek}, 0;
  $p->_move_line_start($fh);
  is scalar <$fh>, $answer[$i], "test $i";
}

done_testing;
