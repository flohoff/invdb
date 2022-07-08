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
	my $j=$self->req->json();
	my $uuid=$self->param("uuid");

	my $oldobject=$self->dbobject->get($uuid);

	$self->render(json => $j);
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

	$self->render(json => $object);
}
1;
