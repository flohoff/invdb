use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use FindBin qw($Bin);

use InvDB::TestHelper;
my $idbt=new InvDB::TestHelper();

my $t = Test::Mojo->new('InvDB::Backend');

$t->post_ok('/v1/object' => json => { type => "bar", attributes => { foo => [ "bar" ] }})
	->status_is(200)
	->json_is("/attributes/foo/0" => "bar")
	->json_has("/uuid")
	->json_has("/version");

# Must fail - New object are not allowed to contain a uuid or version
$t->post_ok('/v1/object' => json => { version => "1", type => "bar", attributes => { } })
	->status_is(400);
$t->post_ok('/v1/object' => json => { uuid => "1", type => "bar", attributes => { } })
	->status_is(400);

# Must have some content e.g. attributes
$t->post_ok('/v1/object' => json => { type => "bar" })
	->status_is(400);

# Must have a type
$t->post_ok('/v1/object' => json => { attributes => {} })
	->status_is(400);

done_testing();
