package Shoutbox;

use common::sense;
use WWW::Mechanize; 
use WWW::Mechanize::DecodedContent; 
use JSON -support_by_pp;
use URI::Escape;
use Moose;


our $url = WWW::Mechanize->new();
$url->get("http://www.forum-invaders.com.br/vb/login.php");
$url->submit_form(
	fields => { 
		vb_login_username => 'login',
		vb_login_password => 'password',
	});
	
has 'msg' => (is => 'rw', isa => 'Str');

sub send_msg {
	my $self = shift;
	my $message = $self->msg;
	my $content = $url->decoded_content;
	$content =~ /SECURITYTOKEN = "(.*?)"/g ;
	my $token = $1;
	if($content =~ /Bem-vindo/gi) {
		my $msg = uri_escape($message);
		$url->post("http://www.forum-invaders.com.br/vb/vbshout.php",{
			message => $msg, securitytoken => $token,
			do => "ajax", action => "save", instanceid => "2"});
	} 
}

sub get_msg{
	my $r = $url->get("http://www.forum-invaders.com.br/vb/vbshout.php?type=activeusers&do=ajax&action=fetch&instanceid=2");
	my $json = JSON->new->relaxed;
	my $s = $json->decode($r->decoded_content);
	my $msg = $s->{"shouts"}->{0}->{"message_raw"};
	my $user = $s->{"shouts"}->{0}->{"musername"};
	my $name;
	if ($user =~ />(.+)<\/span/gi) {$name = $1;}
	else {$name = $user}
	my $now = join(" => ", $name, $msg) . "\n";
	return $now;
}
no Moose;
1;