use Catmandu::Sane;
use Catmandu;
use Path::Tiny;
use LibreCat load => (layer_paths => [qw(t/layer)]);
use Catmandu;
use LibreCat::CLI;
use Test::More;
use Test::Exception;
use App::Cmd::Tester;

# empty db
for my $bag (qw(publication department project research_group user)) {
    note("deleting backup $bag");
    {
        my $store = Catmandu->store('backup')->bag($bag);
        $store->delete_all;
        $store->commit;
    }

    note("deleting version $bag");
    {
        my $store = Catmandu->store('backup')->bag("$bag\_version");
        $store->delete_all;
        $store->commit;
    }

    note("deleting search $bag");
    {
        my $store = Catmandu->store('search')->bag($bag);
        $store->drop;
        $store->commit;
    }
}

note("cleaning forms");
{
    my $result = test_app(qq|LibreCat::CLI| =>
        ['generate', 'cleanup']);

    print $result->stdout;

    ok !$result->error, 'add threw no exception';
}

note("generate forms");
{
    my $result = test_app(qq|LibreCat::CLI| =>
        ['generate', 'forms']);

    print $result->stdout;

    ok !$result->error, 'add threw no exception';
}

note("loading test publications");
{
    my $result = test_app(qq|LibreCat::CLI| =>
        ['publication', 'add', 'devel/publications.yml']);

    ok !$result->error, 'add threw no exception';
}

note("loading test project");
{
    my $result = test_app(qq|LibreCat::CLI| =>
        ['project', 'add', 'devel/project.yml']);

    ok !$result->error, 'add threw no exception';
}

note("loading test researcher");
{
    my $result = test_app(qq|LibreCat::CLI| =>
        ['user', 'add', 'devel/researcher.yml']);

    ok !$result->error, 'add threw no exception';
}

note("loading test department");
{
    my $result = test_app(qq|LibreCat::CLI| =>
        ['department', 'add', 'devel/department.yml']);

    ok !$result->error, 'add threw no exception';
}

done_testing;
