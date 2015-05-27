use base "x11test";
use testapi;

sub run() {
    my $self = shift;
    ensure_installed "yast2-snapper";
    x11_start_program("xdg-su -c xterm");
    if ($password) { type_password; send_key "ret", 1; }

    type_string "snapper create-config /tmp\n";

    type_string "yast2 snapper\n";
    assert_screen 'yast-modules_snapper-nosnapshots', 15;

    send_key "alt-c";
    assert_screen 'yast-modules_snapper-createsnapshotdialog', 15;
    wait_idle;

    type_string "awesomesnapshot";
    send_key "tab";
    send_key "tab";
    send_key "tab";
    type_string "something";
    send_key "alt-o";
    assert_screen 'yast-modules_snapper-snapshotlisted', 15;

    send_key "alt-l";
    type_string "exit\n";
}

1;
# vim: set sw=4 et:
