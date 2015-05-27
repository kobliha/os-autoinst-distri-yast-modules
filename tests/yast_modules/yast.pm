use base "x11test";
use testapi;

# Just an example. Nothing useful
sub run() {
    my $self = shift;

    x11_start_program("xdg-su -c '/sbin/yast2'");
    if ($password) { type_password; send_key "ret", 1; }
    wait_idle();
    save_screenshot();
    send_key "alt-f4";
}

1;
# vim: set sw=4 et:
