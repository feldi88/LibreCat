package Catmandu::Fix::add_citation;

use Catmandu::Sane;
use Clone qw(clone);
use LibreCat::App::Helper;
use LibreCat::Citation;
use Moo;

sub fix {
    my ($self, $data) = @_;

    unless (h->config->{citation}->{engine} eq 'none') {
        state $citation_engine = LibreCat::Citation->new(all => 1);

        my $d = clone $data;
        $data->{citation} = $citation_engine->create($d);
    }

    $data;
}

1;
