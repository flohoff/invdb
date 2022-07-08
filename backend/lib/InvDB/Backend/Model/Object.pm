package InvDB::Backend::Model::Object;
use strict;
use Mojo::Base -base, -signatures;
use Mojo::JSON qw/decode_json/;

has 'pg';

sub get_links_from($self, $id) {
	my $rows=$self->pg->db->query("
		select	l.link link,
			o.object
		from	links l
			join objects o
				on ( l.idb = o.id )
		where l.ida = (?);
		", $id)->hashes;

	my @links=map {
		$_->{link}=decode_json($_->{link});
		$_->{object}=decode_json($_->{object});
		$_; } @{$rows};

	return \@links;
}

sub get_links_to($self, $id) {
	my $rows=$self->pg->db->query("
		select	l.link link,
			o.object
		from	links l
			join objects o
				on ( l.ida = o.id )
		where l.idb = (?);
		", $id)->hashes;

	my @links=map {
		$_->{link}=decode_json($_->{link});
		$_->{object}=decode_json($_->{object});
		$_; } @{$rows};

	return \@links;
}
sub get ($self, $uuid) {
	my $row=$self->pg->db->select('objects', '*', { uuid => $uuid })->hash;
	my $object=decode_json($row->{object});
	$object->{links}{from}=$self->get_links_from($row->{id});
	$object->{links}{to}=$self->get_links_to($row->{id});
	return $object;
}

1;
