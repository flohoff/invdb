use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use FindBin qw($Bin);

use InvDB::TestHelper;
my $idbt=new InvDB::TestHelper();

my $t = Test::Mojo->new('InvDB::Backend');

$t->get_ok('/v1/object/b56582e8-a452-4e42-903b-9b5cc2a7267f')
	->status_is(200)
	->json_is("/type" => "interface")
	->json_is("/version" => "20b124d6-f61c-4856-b2fe-7c0264c58860")
	->json_is("/attributes/name/0" => 'eth0')
	->json_is("/links/from/0/link/type" => 'is-in')
	->json_is("/links/from/0/link/uuid" => 'fb8001b5-4834-493f-9fe0-e5068c095b66')
	->json_is("/links/from/0/object/uuid" => '4e665e17-b40a-4c73-b879-31aa9bc7aab1');

done_testing();
