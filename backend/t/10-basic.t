use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use FindBin qw($Bin);

use InvDB::TestHelper;
my $idbt=new InvDB::TestHelper();
$idbt->backend_conf_write("$Bin/../backend.conf");

my $t = Test::Mojo->new('InvDB::Backend');
$t->get_ok('/v1/object/b56582e8-a452-4e42-903b-9b5cc2a7267f')->status_is(200)->content_like(qr/eth0/i);

done_testing();
