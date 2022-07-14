package InvDB::Backend::Controller::V1;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub object_get ($self) {
	my $uuid=$self->param("uuid");

	my $object=$self->dbobject->get_with_neighbours($uuid);

	if (defined($object)) {
		return $self->render(json => $object );
	}

	$self->res->code(405);
	$self->render(json => { status => "Unsupported method" });
}

sub return_error($self, $error, $message) {
	$self->res->code($error);
	$self->render(json => { status => $message });
}

sub object_post_uuid($self) {
	my $new=$self->req->json();
	my $uuid=$self->param("uuid");

	my $old=$self->dbobject->get($uuid);

	if ($new->{uuid} ne $old->{uuid}) {
		return $self->return_error(400, "New and old uuid do not match");
	}
	if ($new->{version} ne $old->{version}) {
		return $self->return_error(400, "New and old version do not match");
	}
	if (!defined($new->{type})) {
		return $self->return_error(400, "Need object type");
	}
	if (!defined($new->{attributes})) {
		return $self->return_error(400, "Needs at least an empty attributes key");
	}

	my $object=$self->dbobject->update($uuid, $new);

	$self->render(json => $object);
}

sub object_post($self) {
	my $j=$self->req->json();

	if (defined($j->{version})) {
		return $self->return_error(400, "New object must not have version");
	}
	if (defined($j->{uuid})) {
		return $self->return_error(400, "New object must not have uuid");
	}

	if (!defined($j->{type})) {
		return $self->return_error(400, "Need object type");
	}
	if (!defined($j->{attributes})) {
		return $self->return_error(400, "Needs at least an empty attributes key");
	}

	my $object=$self->dbobject->add($j);

	# Add to opensearch
	$self->os->add($j->{uuid}, $j);

	$self->render(json => $object);
}

sub search($self) {
	my $query=$self->param("q");
	my $result=$self->os->search($query);
	$self->render(json => $result);
}
1;
