use strict;
use warnings;
use Tk;

my $filename = 'todo.txt';
my @todo_list;

load_tasks();

my $mw = MainWindow->new;
$mw->title("Simple To-Do List");

my $listbox = $mw->Listbox(
    -width => 50,
    -height => 15,
    -selectmode => 'single'
)->pack(-padx => 10, -pady => 5);

my $entry = $mw->Entry(
    -width => 50,
)->pack(-padx => 10, -pady => 5);

my $button_frame = $mw->Frame->pack;

$button_frame->Button(
    -text => "Add Task",
    -command => \&add_task,
)->pack(-side => 'left', -padx => 5);

$button_frame->Button(
    -text => "Remove Task",
    -command => \&remove_task,
)->pack(-side => 'left', -padx => 5);

$button_frame->Button(
    -text => "Exit",
    -command => sub { $mw->destroy },
)->pack(-side => 'left', -padx => 5);

refresh_list();

MainLoop;

sub load_tasks {
    if (-e $filename) {
        open(my $fh, '<', $filename) or die "Cannot open file: $!";
        @todo_list = <$fh>;
        close($fh);
        chomp @todo_list;
    }
}

sub save_tasks {
    open(my $fh, '>', $filename) or die "Cannot open file: $!";
    print $fh join("\n", @todo_list);
    close($fh);
}

sub add_task {
    my $task = $entry->get;
    if ($task) {
        push @todo_list, $task;
        $entry->delete(0, 'end');
        save_tasks();
        refresh_list();
    }
}

sub remove_task {
    my $selection = $listbox->curselection;
    if (@$selection) {
        splice(@todo_list, $selection->[0], 1);
        save_tasks();
        refresh_list();
    }
}

sub refresh_list {
    $listbox->delete(0, 'end');
    $listbox->insert('end', @todo_list);
}