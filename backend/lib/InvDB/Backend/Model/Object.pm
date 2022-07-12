package InvDB::Backend::Model::Object;
use strict;
use Mojo::Base -base, -signatures;
use Mojo::JSON qw/decode_json encode_json/;
use OSSP::uuid;

has 'pg';

sub get_links_from($self, $id) {
	my $rows=$self->pg->db->query("
		select	l.link link,
			o.object
		from	links l
			join objects o
				on ( l.to_objectid = o.id )
		where l.from_objectid = (?);
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
				on ( l.from_objectid = o.id )
		where l.to_objectid = (?);
		", $id)->hashes;

	my @links=map {
		$_->{link}=decode_json($_->{link});
		$_->{object}=decode_json($_->{object});
		$_; } @{$rows};

	return \@links;
}

sub get_with_neighbours($self, $uuid) {
	my $row=$self->pg->db->select('objects', '*', { uuid => $uuid })->hash;
	my $object=decode_json($row->{object});
	$object->{links}{from}=$self->get_links_from($row->{id});
	$object->{links}{to}=$self->get_links_to($row->{id});
	return $object;
}

sub get($self, $uuid) {
	my $row=$self->pg->db->select('objects', '*', { uuid => $uuid })->hash;
	my $object=decode_json($row->{object});
	return $object;
}

sub uuid_v4($self) {
	my $uuid=new OSSP::uuid;
	$uuid->make("v4");
	return $uuid->export("str");
}

sub update($self, $uuid, $newobject) {
	my $newversion=$self->uuid_v4();
	$newobject->{version}=$newversion;

	$self->pg->db->update('objects', {
			version => $newversion,
			object => encode_json($newobject)
		}, { uuid => $uuid });

	return $self->get($uuid);
}

sub add($self, $newobject) {

	my $newuuid=$self->uuid_v4();
	my $newversion=$self->uuid_v4();

	$newobject->{version}=$newversion;
	$newobject->{uuid}=$newuuid;

	my $uuid=$self->pg->db->insert('objects', {
			uuid => $newuuid,
			version => $newversion,
			object => encode_json($newobject)
		}, { returning => 'uuid' })->hash->{uuid};

	my $storedobject=$self->get($uuid);

	return $storedobject;
}

1;
