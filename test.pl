# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

use Test;
BEGIN { plan tests => 17 };
use Compress::LeadingBlankSpaces;
ok(1); # module is available ok.

# 2:
my $dirty = "           header test\n";
my $clean = "header test\n";
my $compress_obj = Compress::LeadingBlankSpaces->new();
ok($compress_obj); # new() works 

# 3:
my $status = $compress_obj->format_status();
# printf ("status = %s\n",$status);
ok ($status eq -1); # initial status is set properly

# 4:
my $temp = $compress_obj->squeeze_string($dirty);
ok ($temp eq $clean); # squeeze_string() works when (status == -1)

# 5:
my $tag_pre = '<PRE something>'."\n";
$temp = $compress_obj->squeeze_string($tag_pre);
$status = $compress_obj->format_status();
# printf ("status = %s\n",$status);
ok ($status >= 0); # status is changed properly
$temp = $compress_obj->squeeze_string($dirty);
# printf ("'%s'",$temp);
ok ($temp eq $dirty); # squeeze_string() works when (status != -1)
my $tag_pre_end = '</PRE>'."\n";
$temp = $compress_obj->squeeze_string($tag_pre_end);
$status = $compress_obj->format_status();
# printf ("status = %s\n",$status);
ok ($status < 0); # status is changed properly

# 8: It was a bug -- the capitalization was broken... 04/17/2004 fixed
$tag_pre = '<pre the following>'."\n";
$temp = $compress_obj->squeeze_string($tag_pre);
$status = $compress_obj->format_status();
# printf ("status = %s\n",$status);
ok ($status >= 0); # status is changed properly
$temp = $compress_obj->squeeze_string($dirty);
# printf ("'%s'",$temp);
ok ($temp eq $dirty); # squeeze_string() works when (status != -1)
$tag_pre_end = '</pre>'."\n";
$temp = $compress_obj->squeeze_string($tag_pre_end);
$status = $compress_obj->format_status();
# printf ("status = %s\n",$status);
ok ($status < 0); # status is changed properly

# 11:
$tag_pre = '<TEXTAREA something>'."\n";
$temp = $compress_obj->squeeze_string($tag_pre);
$status = $compress_obj->format_status();
# printf ("status = %s\n",$status);
ok ($status >= 0); # status is changed properly
$temp = $compress_obj->squeeze_string($dirty);
# printf ("'%s'",$temp);
ok ($temp eq $dirty); # squeeze_string() works when (status != -1)
$tag_pre_end = '</TEXTAREA>'."\n";
$temp = $compress_obj->squeeze_string($tag_pre_end);
$status = $compress_obj->format_status();
# printf ("status = %s\n",$status);
ok ($status < 0); # status is changed properly

# 14:
$tag_pre = '<textarea the following>'."\n";
$temp = $compress_obj->squeeze_string($tag_pre);
$status = $compress_obj->format_status();
# printf ("status = %s\n",$status);
ok ($status >= 0); # status is changed properly
$temp = $compress_obj->squeeze_string($dirty);
# printf ("'%s'",$temp);
ok ($temp eq $dirty); # squeeze_string() works when (status != -1)
$tag_pre_end = '</textarea>'."\n";
$temp = $compress_obj->squeeze_string($tag_pre_end);
$status = $compress_obj->format_status();
# printf ("status = %s\n",$status);
ok ($status < 0); # status is changed properly

# 17:
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

