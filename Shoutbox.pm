package Shoutbox;

use common::sense;
use WWW::Mechanize; 
use WWW::Mechanize::DecodedContent; 
use JSON -support_by_pp;
use URI::Escape;
use Moose;

has 'login' => (is => 'rw', isa => 'Str');
has 'password' => (is => 'rw', isa => 'Str');
has 'msg' => (is => 'rw', isa => 'Str');
our $url = WWW::Mechanize->new();
our $token;
sub BUILD{
	my $self = shift;
	my $lgn = $self->login;
	my $pwd = $self->password;
	$url->get("http://www.forum-invaders.com.br/vb/login.php");
	$url->submit_form(
	fields => {
	vb_login_username => $lgn,
	vb_login_password => $pwd,
	});
}
sub check{
	my $cont = 1;
	my $p = &login_check;
	while ($p == 0){ 
		$p = &login_check;
		if (0){ Shoutbox->new();}
		$cont++;
		if ($cont == 3) {
			print "\t\tLogin Fail\n\nexit...\n";
			exit;
		}
	}
}
sub login_check{
	 
	my $content = $url->decoded_content;
	$content =~ /SECURITYTOKEN = "(.*)"/g;
	if ($1 eq "guest"){
		print "Login Error\n";
		return "0";
	}
	else {print "Login OK!\n";}
	$token = $1;
	return "1";
}
sub send_msg {
	check;
	my $self = shift;
	my $message = $self->msg;
	my $msg = uri_escape($message);
	$url->post("http://www.forum-invaders.com.br/vb/vbshout.php",{
	message => $msg, securitytoken => $token,
	do => "ajax", action => "save", instanceid => "2"});
}
sub get_msg{
	my $r = $url->get("http://www.forum-invaders.com.br/vb/vbshout.php?type=activeusers&do=ajax&action=fetch&instanceid=2");
	my $json = JSON->new->relaxed;
	my $s = $json->decode($r->decoded_content);
	my $ms = $s->{"shouts"}->{0}->{"message_raw"};
	my $user = $s->{"shouts"}->{0}->{"musername"};
	my $name;
	if ($user =~ />(.+)<\/span/gi) {$name = $1;}
	else {$name = $user}
	my $now = join(" => ", $name, $ms) . "\n";
	return $now;
	exit;
}
no Moose;
1;