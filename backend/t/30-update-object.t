use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Data::Dumper;
use FindBin qw($Bin);

my $t = Test::Mojo->new('InvDB::Backend');

$t->post_ok('/v1/object' => json => { type => "testobject", attributes => { foo => [ "bar" ] }})
	->status_is(200)
	->json_is("/attributes/foo/0" => "bar")
	->json_has("/uuid")
	->json_has("/version");

my $json=$t->tx->res->json;
my $uuid=$json->{uuid};
my $version=$json->{version};

# Check if stored object is reachable by API
$t->get_ok("/v1/object/$uuid")
	->status_is(200)
	->json_is("/attributes/foo/0" => "bar");

# Create new object and post it
$json->{attributes}{foo}=[ "baz" ];

# Check if version and content has changed
$t->post_ok("/v1/object/$uuid" => json => $json)
	->status_is(200)
	->json_is("/attributes/foo/0" => "baz")
	->json_has("/uuid")
	->json_is("/type" => "testobject")
	->json_has("/version")
	->json_unlike("/version" => qr/$version/);

# Check if another update with old version suceeds (it shouldnt)
$t->post_ok("/v1/object/$uuid" => json => $json)
	->status_is(400);

done_testing();
