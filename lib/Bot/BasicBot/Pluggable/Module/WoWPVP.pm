package Bot::BasicBot::Pluggable::Module::WoWPVP;

use warnings;
use strict;

use Bot::BasicBot::Pluggable::Module;
use base qw(Bot::BasicBot::Pluggable::Module);
use Games::WoW::PVP;

=head1 NAME

Bot::BasicBot::Pluggable::Module::WoWPVP - The great new Bot::BasicBot::Pluggable::Module::WoWPVP!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Bot::BasicBot::Pluggable::Module::WoWPVP;

    my $foo = Bot::BasicBot::Pluggable::Module::WoWPVP->new();
    ...

=cut

=head1 FUNCTIONS

=head2 init

=cut

sub init {
    my ($self) = @_;
}

sub help {
    my ($self) = @_;
    my $mess;
    $mess = "pouet pouet";
    return $mess;
}

sub said {
    my ( $self, $mess, $pri ) = @_;

    return unless $pri == 2;
    return unless $mess->{body} =~ /^!pvp/;

    my $body    = $mess->{body};
    my $who     = $mess->{who};
    my $channel = $mess->{channel};

    $body =~ /^!pvp (\w+)/;
    my $character = $1;
    
    my ($realm) = $body =~ /-r (\w.+) (-\w|$)/ ;
    my ($country) = $body =~ /-c (EU|US)/;
    my ($faction) = $body =~ /-f (h|a)/i;
     
    $realm ||= 'conseil des ombres';
    $country ||= 'EU';
    $faction ||= 'h';
    
    $character = ucfirst $character;
    $realm =~ s/\s/+/g;
    
    my $WoW  = Games::WoW::PVP->new();
    
    my %hash = $WoW->search_player(
        {   country   => $country,
            realm     => $realm,
            faction   => $faction,
            character => $character,
        }
    );

    if ( !defined $hash{characterName} ) {
        $self->tell(
            $channel, $who . ": no informations for $character"
        );
        return;
    }
    
    my $text = $hash{characterName};
    $text .= " <" . $hash{guildName} . ">" if defined $hash{guildName};
    $text .= " # "
        . $hash{raceLabel} . " "
        . $hash{classLabel}
        . " level "
        . $hash{level};
    $text .= " # Position "
        . $hash{position}
        . " (Grade "
        . $hash{rank} . " "
        . $hash{rankLabel} . " )";
    $text .= " # HK/DK " . $hash{lhk} . "/" . $hash{ldk};
    $text .= " rating "
        . $hash{rating}
        . " (Progression "
        . $hash{percent} . "%) ";

    $self->tell(
        $channel, $who . ": " . $text
    );

}

=head1 AUTHOR

Franck CUNY, C<< <franck at breizhdev.net> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-bot-basicbot-pluggable-module-wowpvp at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Bot-BasicBot-Pluggable-Module-WoWPVP>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Bot::BasicBot::Pluggable::Module::WoWPVP

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Bot-BasicBot-Pluggable-Module-WoWPVP>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Bot-BasicBot-Pluggable-Module-WoWPVP>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Bot-BasicBot-Pluggable-Module-WoWPVP>

=item * Search CPAN

L<http://search.cpan.org/dist/Bot-BasicBot-Pluggable-Module-WoWPVP>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2006 Franck CUNY, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;    # End of Bot::BasicBot::Pluggable::Module::WoWPVP
