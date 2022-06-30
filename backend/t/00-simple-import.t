

use strict;
use Test::More;
use FindBin qw($Bin);
use InvDB::TestHelper;

my $dumprestore="$Bin/../contrib/dumprestore";
my $simpleone="$Bin/00-simple-import.json";

my $idbt=new InvDB::TestHelper({ backenddir => "$Bin/../" });

$idbt->db_clean();
$idbt->db_schema_add("$Bin/../schema/idb.schema.psql");

my $cmd=sprintf("%s --restore --dbhost %s --dbname %s --dbuser %s --dbpass %s --file %s",
	$dumprestore,
	$ENV{POSTGRES_HOST},
	$ENV{POSTGRES_DB},
	$ENV{POSTGRES_USER},
	$ENV{POSTGRES_PASSWORD},
	$simpleone);

ok(system($cmd) == 0, "Restore $cmd succeeded");

ok($idbt->db_object_by_uuid_exists("b56582e8-a452-4e42-903b-9b5cc2a7267f"), "Object b56582e8-a452-4e42-903b-9b5cc2a7267f exists");
ok($idbt->db_link_by_uuid_exists("fb8001b5-4834-493f-9fe0-e5068c095b66"), "Link fb8001b5-4834-493f-9fe0-e5068c095b66 exists");

done_testing();
