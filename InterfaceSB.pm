package InterfaceSB;
 
use Tk;  
use Tk::Label;
use Tk::DummyEncode;
use common::sense;
use Shoutbox;

my $p = Shoutbox->new();

my $mw = new MainWindow(-background => 'blue');   
$mw->geometry("600x400");  
$mw->minsize(qw(400 650));  
$mw->maxsize(qw(800 750));   
$mw->title("Invaders External ShoutBox");  
  
my $read_locate = $mw -> Frame(-background => 'red', -relief=>'raised',  
  -borderwidth=>1,  
  ) ->place(-x =>70, -y =>25);  
my $read = $read_locate->Scrolled ('Text',   
			-width=> 60, -height => 20, -background => 'black', -foreground => 'green')->pack;  
$read->insert('end',"Start External ShoutBox...\nInVaDeRs\n"); 
 
  
my $write_locate = $mw -> Frame(-background => 'red', -relief=>'raised',  
  -borderwidth=>1,  
  ) ->place(-x => 70, -y => 450);  
my $write = $write_locate->Entry (-width=> 70, -background => 'black', -foreground => 'green')->pack;  
 
my $button_locate1 = $mw -> Frame(-background => 'red', -relief=>'raised',  
  -borderwidth=>1,) ->place(-x => 280, -y => 350); 
my $button = $button_locate1->Button( -text => 'Update',
            -command => \&read_msg)->pack();

my $button_locate2 = $mw -> Frame(-background => 'red', -relief=>'raised',  
  -borderwidth=>1,) ->place(-x => 280, -y => 550);	
my $button2 = $button_locate2->Button( -text => 'send',
            -command => sub{write_msg($write)})->pack();
		
MainLoop;
			
sub read_msg{
	my $work = 1;
	my @old;
	my $num = 0;
	while ($work == 1){
		my $msg = $p->get_msg;
		if ($num == 0){
			$read->insert('end', $msg);
			$mw->update();
			push (@old, $msg);
			$num++;
		}
		elsif($old[$num - 1] ne $msg){
			$read->insert('end', $msg);
			$mw->update();
			push (@old, $msg);
			$num++;
		}
	}
}

sub write_msg{
	my ($entry) = @_;
	my $text = $entry->get();
	$p->msg($text);
	$p->send_msg;
}
 
1;