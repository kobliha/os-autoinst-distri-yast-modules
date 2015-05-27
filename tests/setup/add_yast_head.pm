use base "opensusebasetest";
use testapi;

sub run() {
    my $self = shift;

    my $repo_url = get_var("VERSION");
    $repo_url = "13.2_Update" if ($repo_url eq "13.2");
    $repo_url = "http://download.opensuse.org/repositories/YaST:/Head/openSUSE_$repo_url/";
    script_run "zypper ar $repo_url YaST:Head | tee /dev/$serialdev";
    $self->result('fail') unless wait_serial("successfully added", 20);
    save_screenshot;
}

sub test_flags() {
    return { 'important' => 1, 'fatal' => 1 };
}

1;
# vim: set sw=4 et:
