package InvDB::Backend::Model::Object;
use strict;
use Mojo::Base -base, -signatures;
use Mojo::JSON qw/decode_json/;

has 'pg';

sub get ($self, $uuid) {
  my $row=$self->pg->db->select('objects', '*', { uuid => $uuid })->hash;
  my $object=decode_json($row->{object});
  $object->{uuid}=$row->{uuid};
  return $object;
}

1;
