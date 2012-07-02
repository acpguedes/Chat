#!/usr/bin/env perl

use InterfaceSB;

my $if = InterfaceSB;

__END__
my $work = 1;
my @old;
my $num = 0;
while ($work == 1){
	my $msg = $p->get_msg;
	if ($num == 0){
		$if->update_me($msg);
		push (@old, $msg);
		$num++;
	}
	elsif($old[$num - 1] ne $msg){
		$if->update_me($msg);
		push (@old, $msg);
		$num++;
	}
}