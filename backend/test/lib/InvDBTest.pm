
package InvDBTest;
	use strict;
	use File::Slurp qw/read_file/;
	use DBI;

	sub new {
		my ($class, $args) = @_;
		my $self={
			args => $args
		};
		bless $self, $class;

		$self->{dbh}=$self->db_open();

		return $self;
	}

	sub db_open {
		my ($self) = @_;

		my $dbname=$ENV{POSTGRES_DB};
		my $dbuser=$ENV{POSTGRES_USER};
		my $dbpass=$ENV{POSTGRES_PASSWORD};
		my $dbhost='postgres';

		# "dbi:Pg:dbname=addresses;host=m2.zz.de;port=5433
		my $dbcontact=sprintf("dbi:Pg:dbname=%s", $dbname);
		if (defined($dbhost)) {
			$dbcontact.=sprintf(";host=%s", $dbhost);
		}

		my $dbh=DBI->connect_cached($dbcontact,
			$dbuser,
			$dbpass) || die $DBI::errstr;

		return $dbh;
	}

	sub db_clean {
		my ($self) = @_;

		$self->{dbh}->do("drop schema public cascade") || die $DBI::errstr;
		$self->{dbh}->do("create schema public") || die $DBI::errstr;
	}

	sub db_schema_add {
		my ($self, $schemafile) = @_;

		my $sql=read_file($schemafile);
		$self->{dbh}->do("$sql") || die $DBI::errstr;
	}

	sub db_object_by_uuid_exists {
		my ($self, $objectuuid) = @_;

		my $result=$self->db_object_by_uuid($objectuuid);

		return defined($result);
	}

	sub db_object_by_uuid {
		my ($self, $uuid) = @_;

		my $rows=$self->{dbh}->selectall_hashref("
			select	*
			from	object
			where	uuid = ?
			",
			"uuid", $uuid) || die $DBI::errstr;

		return $rows->{uuid};
	}
1;
