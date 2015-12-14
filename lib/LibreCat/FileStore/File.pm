package LibreCat::FileStore::File;

use Moo::Role;

with 'Catmandu::Logger';

has key           => (is => 'ro' , required => 1);
has content_type  => (is => 'ro');
has size          => (is => 'ro');
has md5           => (is => 'ro');
has created       => (is => 'ro');
has modified      => (is => 'ro');

1;

__END__