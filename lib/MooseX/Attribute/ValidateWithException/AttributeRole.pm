use 5.006;    # warnings
use strict;
use warnings;

package MooseX::Attribute::ValidateWithException::AttributeRole;
use Moose::Role qw( override );

sub __generate_check {
  my ( $self, %params ) = @_;
  if ( $self->type_constraint->can_be_inlined ) {
    ## no critic (ProtectPrivateSubs)
    return sprintf '( %s )', $self->type_constraint->_inline_check( $params{value} );
  }
  else {
    return sprintf '( %s->( %s ) )', $params{tc}, $params{value};
  }
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

  my $check_code       = $self->__generate_check( value => $value, tc => $tc, );
  my $message_variable = '$message';
  my $get_message_code = ( sprintf 'do { local $_ = %s; %s->( %s ) }', $value, $message, $value );

  return <<"CHECKCODE";
  if( ! $check_code ) {
    my $message_variable = $get_message_code;
    if ( ref $message_variable ) {
      die $message_variable;
    } else {
      require MooseX::Attribute::ValidateWithException::Exception;
      die MooseX::Attribute::ValidateWithException::Exception->new(
        attribute_name     => '$attribute_name',
        data               => $value,
        constraint_message => $message_variable,
        constraint_name    => '$tc_name',
      );
    }
  }
CHECKCODE
};

override 'verify_against_type_constraint' => sub {
  my $self = shift;
  my $val  = shift;

  return 1 if !$self->has_type_constraint;

  my $type_constraint = $self->type_constraint;

  if ( not $type_constraint->check($val) ) {
    my $message = $type_constraint->get_message($val);
    if ( ref $message ) {
      die $message;
    }
    else {
      require MooseX::Attribute::ValidateWithException::Exception;
      die MooseX::Attribute::ValidateWithException::Exception->new(
        attribute_name     => $self->name,
        data               => $val,
        constraint_message => $message,
        constraint         => $type_constraint,
        constraint_name    => $type_constraint->name
      );
    }
  }
};

no Moose::Role;

1;
