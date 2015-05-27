use base "opensusebasetest";
use testapi;

sub run() {
    my $self = shift;

    wait_idle;
    # log into text console
    send_key "ctrl-alt-f4";
    # we need to wait more than five seconds here to pass the idle timeout in
    # case the system is still booting (https://bugzilla.novell.com/show_bug.cgi?id=895602)
    assert_screen "tty4-selected", 10;
    
    assert_screen "text-login", 10;
    type_string "$username\n";
    assert_screen "password-prompt", 10;
    type_password;
    type_string "\n";

    become_root;

    script_run "systemctl mask packagekit.service";
    script_run "systemctl stop packagekit.service";
    save_screenshot;
}

1;
