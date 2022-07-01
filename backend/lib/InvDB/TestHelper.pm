package InvDB::TestHelper;
	use strict;
	use File::Slurp qw/read_file write_file/;
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
		my $dbhost=$ENV{POSTGRES_HOST};

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

	sub db_dump {
		my ($self) = @_;

		system(sprintf("pg_dump --host postgres --dbname %s --username %s",
					$ENV{POSTGRES_DB}, $ENV{POSTGRES_USER}));
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
			from	public.objects
			where	uuid = ?
			",
			"uuid", undef, $uuid) || die $DBI::errstr;

		return $rows->{$uuid};
	}

	sub db_link_by_uuid_exists {
		my ($self, $linkuuid) = @_;

		my $result=$self->db_link_by_uuid($linkuuid);

		return defined($result);
	}

	sub db_link_by_uuid {
		my ($self, $uuid) = @_;

		my $rows=$self->{dbh}->selectall_hashref("
			select	*
			from	public.links
			where	uuid = ?
			",
			"uuid", undef, $uuid) || die $DBI::errstr;

		return $rows->{$uuid};
	}

	sub backend_conf_write {
		my ($self, $file) = @_;

		write_file($file, 
			sprintf("{ pg => 'postgresql://%s:%s\@%s/%s', secrets => 'secret' }",
				 $ENV{POSTGRES_USER}, $ENV{POSTGRES_PASSWORD},
				 $ENV{POSTGRES_HOST}, $ENV{POSTGRES_DB}));
	}


1;