package InvDB::Backend::OpenSearch;
	use strict;
	use Mojo::Base -base, -signatures;
	use Data::Dumper;
	use Search::Elasticsearch;

	has 'elastic';

	sub new($class, $args) {
		my $e=Search::Elasticsearch->new(
			nodes => $args->{nodes}
		);

		my $self={
			e => $e,
			index => $args->{index}
		};

		bless $self, $class;
		return $self;
	}

	sub search($self, $term) {

		my $results=$self->{e}->search(
			index => $self->{index},
			body => {
				query => {
					match => { q => $term }
				}
			}
		);

		# FIXME - Need to replace objects with objects from database
		
		return $results;
	}

	sub put($self, $uuid, $object) {
		$self->{e}->index(
			index => $self->{index},
			type => $object->{type},
			id => $uuid,
			body => $object
		);
	}

	sub index_create($self) {
		if (not $self->{e}->indices->exists(index => $self->{index})) {
			$self->{e}->indices->create(index => $self->{index});
		}
	}
1;