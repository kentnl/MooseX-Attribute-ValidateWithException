
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'English' => '0',
    'File::Find' => '0',
    'File::Temp' => '0',
    'Module::Build' => '0.3601',
    'Test::More' => '0.88'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'Cause validation failures to throw exception objects.',
  'dist_author' => [
    'Kent Fredric <kentnl@cpan.org>'
  ],
  'dist_name' => 'MooseX-Attribute-ValidateWithException',
  'dist_version' => '0.1.0',
  'license' => 'perl',
  'module_name' => 'MooseX::Attribute::ValidateWithException',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Data::Dump' => '0',
    'Moose' => '0',
    'Moose::Exporter' => '0',
    'Moose::Role' => '0',
    'StackTrace::Auto' => '0'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
