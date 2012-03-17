
use strict;
use warnings;

package MooseX::Attribute::ValidateWithException::AttributeRole;
BEGIN {
  $MooseX::Attribute::ValidateWithException::AttributeRole::AUTHORITY = 'cpan:KENTNL';
}
{
  $MooseX::Attribute::ValidateWithException::AttributeRole::VERSION = '0.2.1';
}
use Moose::Role;

sub __generate_exception {
  my ( $self, %params ) = @_;
  return 'require MooseX::Attribute::ValidateWithException::Exception; ' .

    $self->_inline_throw_error(<<"EXCEPTION");

  MooseX::Attribute::ValidateWithException::Exception->new(
    attribute_name     => $params{attribute_name},
    data               => $params{data},
    constraint_message => $params{constraint_message},
    constraint_name    => $params{constraint_name},
  )

EXCEPTION
}

sub __generate_check {
  my ( $self, %params ) = @_;
  if ( $self->type_constraint->can_be_inlined ) {
    ## no critic (ProtectPrivateSubs)
    return '! ( ' . $self->type_constraint->_inline_check( $params{value} ) . ')';
  }
  else {
    return '! ( ' . $params{tc} . '->(' . $params{value} . ') )';
  }
}

sub __generate_check_exception {
  my ( $self, %params ) = @_;
  return <<"CHECKCODE";
  if( $params{check} ) {
    my $params{message_variable} = $params{get_message};
    if ( ref $params{message_variable} ) {
      $params{ref_handler}
    } else {
      $params{nonref_handler}
    }
  }
CHECKCODE
}

override '_inline_check_constraint' => sub {

  #    my $orig = shift;
  my $self = shift;
  my ( $value, $tc, $message, $is_lazy ) = @_;

  my $attribute_name = quotemeta( $self->name );

  return unless $self->has_type_constraint;

  my $tc_obj  = $self->type_constraint;
  my $tc_name = quotemeta( $tc_obj->name );

  ## no critic ( ProhibitImplicitNewlines RequireInterpolationOfMetachars )

  return $self->__generate_check_exception(
    check => $self->__generate_check(
      value => $value,
      tc    => $tc,
    ),
    message_variable => '$message',
    get_message      => "do { local \$_ = ${value}; ${message}->( ${value} ) }",
    ref_handler      => $self->_inline_throw_error('$message'),
    nonref_handler   => $self->__generate_exception(
      attribute_name     => "'$attribute_name'",
      data               => $value,
      constraint_message => '$message',
      constraint_name    => "'$tc_name'",
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

version 0.2.1

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

