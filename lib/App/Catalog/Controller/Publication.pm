package App::Catalog::Controller::Publication;

use Catmandu::Sane;
use Catmandu;
use App::Catalog::Helper;
use Catmandu::Validator::PUB;
use Hash::Merge qw/merge/;
use Carp;
use Exporter qw/import/;
our @EXPORT
    = qw/new_publication save_publication update_publication edit_publication/;

# Catmandu->load;
# Catmandu->config;

sub _create_id {
    my $bag = h->bag->get('1');
    my $id  = $bag->{"latest"};
    $id++;
    $bag = h->bag->add( { _id => "1", latest => $id } );
    return $id;
}

sub new_publication {
    return _create_id;
}

sub save_publication {
    my $pub      = shift;
    my $validator = Catmandu::Validator::PUB->new();

    if ( $validator->is_valid($data) ) {
        h->publications->add($data);
        h->publications->commit
    }
    else {
        croak join(@{$validator->last_errors}, ' | ');
    }

}

sub update_publication {
    my $data = shift;
    croak "Error: No _id specified" unless $data->{_id};

    my $old = h->publications->get( $data->{_id} );
    my $merger = Hash::Merge->new(); 
    #left precedence by default!
    my $new = $merger->merge( $data, $old );

    save_publication($new);
}

sub edit_publication {
    my $id = shift;

    return "Error" unless $id;
    # some pre-processing needed?
<<<<<<< HEAD
    # if not, then this sub is overkill
    h->publication->get($id);
=======
    # if not, then this method sub is overkill
    h->publications->get($id);
>>>>>>> 06458af5fa7f67228dd91f8f65bb63082e25d91c
}

sub delete_publication {
	my $id = shift;
    return "Error" unless $id;

    my $now = "";
    my $del = {
        _id => $id,
        date_deleted => $now,
    };

    # this will do a hard override of
    # the existing publication
	h->publications->add($del);
	h->publications->commit;

    # delete attached files
    my $dir = h->conf->{upload_dir} ."/$id";
    my $status = rmdir $dir if -e $dir || 0;
    croak "Errror: could not delete files" if $status;
}

1;
