package InvDB::Backend::Controller::V1;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub object_get ($self, $uuid) {
	my $object=$self->dbobject->get($uuid);
	$self->render(json => $object );
}

sub object ($self) {
	my $uuid=$self->param("uuid");

	if ($self->req->method eq 'GET') {
		return $self->object_get($uuid);
	} 

	$self->res->code(405);
	$self->render(json => { status => "Unsupported method" });
}
1;
