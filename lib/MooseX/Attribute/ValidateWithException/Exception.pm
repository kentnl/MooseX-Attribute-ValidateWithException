## no critic (Moose::RequireMakeImmutable)
use 5.006;    # warnings
use strict;
use warnings;

package MooseX::Attribute::ValidateWithException::Exception;

our $VERSION = 'v0.4.0';

# ABSTRACT: An Exception object to represent "Normal" moose validation failures.

# AUTHORITY

use Moose qw( extends has );

#with 'StackTrace::Auto';

extends 'Throwable::Error';

has 'attribute_name' => (
  isa      => 'Str',
  required => 1,
  is       => 'ro',
);

has 'data' => (
  is       => 'ro',
  required => 1,
);

has 'constraint_message' => (
  is       => 'ro',
  required => 1,
);

# has 'constraint' => (
#  is       => 'ro',
#  required => 1,
#);

has 'constraint_name' => (
  isa      => 'Str',
  is       => 'ro',
  required => 1,
);

has message => (
  isa     => 'Str',
  is      => 'ro',
  lazy    => 1,
  builder => '_generate_message',
);

sub _generate_message {
  my ($self) = shift;
  return sprintf 'Attribute (%s) does not pass the type constraint because: %s', $self->attribute_name, $self->constraint_message;
}

#with 'StackTrace::Auto';

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
no Moose;
1;

