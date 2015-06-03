use base "x11test";
use testapi;
# Wrap the commands for downloading extra data used in this test.
# Does not care for getting a shell - just types the commands to a shell that
# you have to provide before calling this.
sub downlad_testdata() {
    my $self = shift;
    type_string "pushd ~\n";
    script_run("curl -L -v " . autoinst_url . "/data > test.data; echo \"curl-\$?\" > /dev/$serialdev");
    wait_serial("curl-0", 10) || die 'curl failed';
    script_run " cpio -id < test.data; echo \"cpio-\$?\"> /dev/$serialdev";
    wait_serial("cpio-0", 10) || die 'cpio failed';
    script_run "ls -al data";
    type_string "popd\n";
    save_screenshot;
}
# Helper for letting y2-snapper to create a snapper snapshot
sub y2snapper_create_snapshot() {
    my $self = shift;
    my $name = shift || "Awesome Snapshot";
   # Open the 'C'reate dialog and wait until it is there
    send_key "alt-c";
    assert_screen 'yast-modules_snapper-createsnapshotdialog', 15;
    # Fill the form and finish by pressing the 'O'k-button
    type_string $name;
    send_key "tab";
    send_key "tab";
    send_key "tab";
    type_string "a=1,b=2";
    send_key "alt-o";
}
sub run() {
    my $self = shift;
    # Make sure yast2-snapper is installed (if not: install it)
    ensure_installed "yast2-snapper";
    # Start an xterm as root
    x11_start_program("xdg-su -c xterm");
    if ($password) { type_password; send_key "ret", 1; }
    assert_screen 'yast-modules_snapper-xterm_is_there', 15;
    # Create a snapper config
    type_string "mkdir /tmp/snapper\n";
    type_string "btrfs subvolume create /tmp/testdata\n";
    type_string "snapper create-config /tmp/testdata\n";
    # Start the yast2 snapper module and wait until it is started
    type_string "yast2 snapper\n";
    assert_screen 'yast-modules_snapper-nosnapshots', 15;
    # Create a new snapshot
    $self->y2snapper_create_snapshot();
    # Make sure the snapshot is listed in the main window
    assert_screen 'yast-modules_snapper-snapshotlisted', 15;
    # C'l'ose  the snapper module
    send_key "alt-l";
    # Download & untar test files
    assert_screen 'yast-modules_snapper-xterm_is_there', 15;
    $self->downlad_testdata();
    type_string "cd /tmp\n";
    type_string "tar -xzf ~/data/testdata.tgz\n";
    wait_idle;
    # Start the yast2 snapper module and wait until it is started
    type_string "yast2 snapper\n";
    # Make sure the snapper module is started
    assert_screen 'yast-modules_snapper-snapshotlisted', 15;
    # Press 'S'how changes button and select both directories that have been
    # extracted from the tarball
    send_key "alt-s";
    send_key "tab";
    send_key "spc";
    send_key "down";
    send_key "spc";
    # Make sure it shows the new files from the unpacked tarball
    assert_screen 'yast-modules_snapper-show_testdata', 15;
    # Close the dialog and make sure it is closed
    send_key "alt-c";
    assert_screen 'yast-modules_snapper-snapshotlisted', 15;
    # C'l'ose  the snapper module
    send_key "alt-l";
    # Check if xterm is focussed and close it
    assert_screen 'yast-modules_snapper-xterm_is_there', 15;
    type_string "exit\n";
}
1;
# vim: set sw=4 et:
