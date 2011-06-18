use strict;
use warnings;

package MooseX::Attribute::ValidateWithException::Exception;
BEGIN {
  $MooseX::Attribute::ValidateWithException::Exception::VERSION = '0.1.0';
}

# ABSTRACT: An Exception object to represent "Normal" moose validation failures.

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
  return 'Attribute (' . $self->attribute_name . ') does not pass the type constraint because: ' . $self->constraint_message;
}

#with 'StackTrace::Auto';

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
no Moose;
1;


__END__
=pod

=head1 NAME

MooseX::Attribute::ValidateWithException::Exception - An Exception object to represent "Normal" moose validation failures.

=head1 VERSION

version 0.1.0

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

