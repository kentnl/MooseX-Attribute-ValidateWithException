
use strict;
use warnings;

use Test::More;

{

  package Example;
  use Moose;
  use MooseX::Attribute::ValidateWithException;

  has 'foo' => (
    isa      => 'Str',
    is       => 'rw',
    required => 1,
  );
  __PACKAGE__->meta->make_immutable;
  no Moose;
}

my $instance = Example->new( 
  foo => [ ],
);

done_testing;

