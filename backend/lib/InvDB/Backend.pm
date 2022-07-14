package InvDB::Backend;
use Mojo::Base 'Mojolicious', -signatures;
use Mojo::Pg;
use InvDB::Backend::Model::Object;
use InvDB::Backend::OpenSearch;
use Data::Dumper;

has 'pg';

# This method will run once at server start
sub startup ($self) {
	$self->plugin('Config', { file => 'backend.conf' });
	$self->secrets($self->config('secrets'));
	
	$self->helper(pg => sub { state $pg = Mojo::Pg->new(shift->config('pg')); });
	$self->helper(dbobject => sub { state $dbobject = InvDB::Backend::Model::Object->new(pg => shift->pg); });
	$self->helper(os => sub { state $os = InvDB::Backend::OpenSearch->new(shift->config('search')); });

	$self->os->index_create();

	# Router
	my $r = $self->routes;

	# Normal route to controller
	#
	my $v1=$r->under('/v1/');
	$v1->get("/object/:uuid")->to('v1#object_get');
	$v1->post("/object")->to('v1#object_post');
	$v1->post("/object/:uuid")->to('v1#object_post_uuid');
	$v1->get("/search/:q")->to('v1#search');
}

1;
