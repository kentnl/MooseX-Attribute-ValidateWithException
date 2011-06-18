
use strict;
use warnings;

package MooseX::Attribute::ValidateWithException::AttributeRole;
BEGIN {
  $MooseX::Attribute::ValidateWithException::AttributeRole::VERSION = '0.1.1';
}
use Moose::Role;

override '_inline_check_constraint' => sub {

  #    my $orig = shift;
  my $self = shift;
  my ( $value, $tc, $tc_obj ) = @_;

  my $attribute_name = quotemeta( $self->name );
  return unless $self->has_type_constraint;

  ## no critic ( ProhibitImplicitNewlines RequireInterpolationOfMetachars )
  return (
    sprintf q|
       if ( ! %s->( %s ) ) {
          my $message = %s->get_message( %s );
          if( ref $message ){
            %s
          } else {
            require MooseX::Attribute::ValidateWithException::Exception;
            %s
          }
       }
    |,
    $tc     => $value,
    $tc_obj => $value,
    $self->_inline_throw_error('$message'),
    $self->_inline_throw_error(
      sprintf q|
        MooseX::Attribute::ValidateWithException::Exception->new(
          attribute_name => '%s',
          data => %s,
          constraint_message => $message,
          constraint => %s,
          constraint_name => %s->name ,
        )
    |, $attribute_name, $value, $tc_obj, $tc_obj
    ),
  );
};

override 'verify_against_type_constraint' => sub {
  my $self = shift;
  my $val  = shift;

  return 1 if !$self->has_type_constraint;

  my $type_constraint = $self->type_constraint;

  if ( not $type_constraint->check($val) ) {
    my $message = $type_constraint->get_message($val);
    if ( ref $message ) {
      $self->throw_error($message);
    }
    else {
      require MooseX::Attribute::ValidateWithException::Exception;
      $self->throw_error(
        MooseX::Attribute::ValidateWithException::Exception->new(
          attribute_name     => $self->name,
          data               => $val,
          constraint_message => $message,
          constraint         => $type_constraint,
          constraint_name    => $type_constraint->name
        )
      );
    }
  }
};

no Moose::Role;

1;

__END__
=pod

=head1 NAME

MooseX::Attribute::ValidateWithException::AttributeRole

=head1 VERSION

version 0.1.1

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

