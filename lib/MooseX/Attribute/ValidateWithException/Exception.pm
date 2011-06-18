use strict;
use warnings;

package MooseX::Attribute::ValidateWithException::Exception;
use Moose;

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

has 'constraint' => (
  is       => 'ro',
  required => 1,
);

has 'constraint_name' => (
  isa      => 'Str',
  is       => 'ro',
  required => 1,
);

has message => (
  isa     => 'Str',
  is      => 'ro',
  builder => '_generate_message',
);

sub _generate_message {
  my ($self) = shift;
  return "Attribute (" . $self->attribute_name . ") does not pass the type constraint because: " . $self->constraint_message;
}

#with 'StackTrace::Auto';

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;

