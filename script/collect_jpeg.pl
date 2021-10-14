#!/usr/bin/perl
use POSIX;
# use strict;
# use warnings;
use Time::Local;
use Net::Ping;

my $p = Net::Ping->new("icmp");

my $link_check = "spe-sde.dro.xxx.net";


my $USERNAME=`whoami`;
chomp $USERNAME;
my $month =`date '+\%b'`;
chomp $month;
my $file_yah = $ARGV[0];
chomp $file_yah;
# print $file_yah;
# exit;
my $ref_file = "/mnt/c/Users/ehmurai/Documents/sde_image_downloader/${file_yah}";
my $OUTPUT = "/mnt/c/Users/ehmurai/Documents/sde_image_downloader/OUTPUT";
my $SCRIPT = "/mnt/c/Users/ehmurai/Documents/sde_image_downloader/script";

my @d=localtime time()-(900*(0));
$LASTDATE = sprintf "%4d%02d%02d", $d[5]+1900,$d[4]+1,$d[3],$d[2],$d[1],$d[0];



open my $handle, '<', $ref_file or die "Cannot run Python script: $!";
chomp(my @line = <$handle>);
close $handle;


for my $i (0..$#line){

    chomp $line[$i];
    # print $line[$i];
    # exit;
    my @data=split(",",$line[$i]);
    my @header_file=split(",",$line[0]);
    next if $line[$i] =~ m/Site Id,Site Name/;
    next if $line[$i] eq "";

    # print $line[$i]."\n";
    # exit;

   my $index = 0;
    for $z (0..$#data) {
        
        chomp $data[$z];
        next if $data[$z] !~ m/^https:\/\/spe-sde\.dro\.xxx\.net\/rest\/templateinstances\//;
        next if $data[$z] eq "";

        $siteid = $data[0];
		$siteid=~s/\'//g;
		$siteid=~s/\.//g;
		$siteid=~s/\s//g;
        $towerid = $data[1];
		$towerid=~s/\'//g;
		$towerid=~s/\.//g;
		$towerid=~s/\s//g;
        trim($header_file[$z]);
        trim($data[$z]);
        $header_file[$z]=~s/\s/_/g;
        $header_file[$z]=~s/\./_/g;
        $header_file[$z]=~s/\//-/g;
        $header_file[$z]=~s/\(/-/g;
        $header_file[$z]=~s/\)/-/g;
        $header_file[$z]=~s/\&/-/g;
        $header_name = $header_file[$z];
        $filename = "${towerid}_${siteid}_${header_name}";
        
        system("mkdir -p ${OUTPUT}/${siteid}_${towerid}/");
		
		print "Check Internet: ";
		
		while(1){
			
			if ($p->ping($link_check)){
				printf "OK\n";
				my $response = "/usr/bin/python3.8 ${SCRIPT}/download.py $data[$z] $filename  ${OUTPUT}/${siteid}_${towerid}/";

				my $response_url = `$response`;
		
				if ($response_url=~ m/\[2\d{0,2}\]/) {
					print "$filename  -----  $response_url  -----  $data[$z]\n";
				} else {
					print "$filename -----  $response_url -----  $data[$z]\n";
				}
				# exit;
				$index++;

				last; #break out of while loop if connection found
			}
			else{
				printf "No Internet $filename ---- $data[$z] ---- $link_check \n";
				sleep(10);
			}
		
		}
        
        


    }
    print "$line[$i] total index === $index\n";
# exit;
}
















sub trim {
        $_[0] =~ s/^\s+|\s+$//g;

        return $_[0];
}

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}