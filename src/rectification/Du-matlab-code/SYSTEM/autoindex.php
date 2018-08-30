<HTML>
<HEAD>
<TITLE>Files Available</TITLE>
</HEAD>
<BODY>

<P>
<BR>

<A href=".."><img src="http://www.csse.uwa.edu.au/icons/back.gif" alt="Go back">Go up a level</a><BR>
<Font size="+2">
Files available:
</font>
<font face="courier">

<center>

<?php	
#############################################################################################################
###  This script with auto generate a file listing index in a directory
###  The directory must be readable by the webserver (ie, permission - 755, not 711)
###  Originally hacked together by Ryan - March 2005
#############################################################################################################

$icons_dir = "http://www.csse.uwa.edu.au/icons/";


$base = preg_split("/\//", $_SERVER["SCRIPT_FILENAME"]);	# The base directory
array_pop($base);
$base = implode("/", $base);		# This gives us the dir instead of the current file
$base = $base."/";

if ($handle = opendir($base))				# Open the directory for reading
{
  
  while (($filename = readdir($handle)) !== false)	# start reading and stop when get to EOF (returns false)
	{
	 						# Only list readable files and no hidden files
         if ((is_readable($base."/".$filename)) && (!preg_match("/^\./",$filename)))
		{
		 $fileArr[] = $filename;
		}
	}
  echo "</p>\n<p><br>\n";				# Print out a table
  echo "<TABLE width=80% border=0>\n";
  echo "<TR>";
  echo "\t<TD width=5%>&nbsp;\n";
  echo "\t<TD width=10%>filename\n";
  echo "\t<TD width=10% ><center>size (bytes)</center>\n";
  echo "\t<TD> &nbsp; &nbsp; &nbsp; &nbsp; date\n";
  natcasesort($fileArr);				# Sort filenames alphabetically
  foreach ($fileArr as $filen)		
     {  $size = filesize($filen);			# Some of the file stuff
	$date = getdate(filemtime($filen));
	$mday = $date['mday'];
	$month = $date['month'];
	$year = $date['year'];
	$weekday = $date['weekday'];
	$min = $date['minutes'];
	$hour = $date['hours'];
	
	echo "<TR>\n";
	echo "\t<TD><center>";					# This pregmatch stuff gives an icon
	if (preg_match("/\.(jpg)|(gif)|(bmp)|(tga)/i",$filen))
		{
		echo "<img src=\"$icons_dir/image2.gif\" alt=\"Image\">";
		}
	else if (preg_match("/\.(zip)|(gz)|(tar)/i",$filen))
                {
                echo "<img src=\"$icons_dir/compressed.gif\" alt=\"Image\">";
                }
	else if (preg_match("/\.(txt)|(doc)/i",$filen))
                {
                echo "<img src=\"$icons_dir/doc.gif\" alt=\"Image\">";
                }
	else if (preg_match("/\.(php)|(htm)/i",$filen))
                {
                echo "<img src=\"$icons_dir/generic.gif\" alt=\"Image\">";
                }
        else if (preg_match("/\.(exe)/i",$filen))
                {
                echo "<img src=\"$icons_dir/comp.gray.gif\" alt=\"Image\">";
                }
        else if (preg_match("/\.(au)|(wav)|(mp3)/i",$filen))
                {
                echo "<img src=\"$icons_dir/sound1.gif\" alt=\"Image\">";
                }
        else if (preg_match("/\.(avi)|(mov)|(mpeg)|(mp4)/i",$filen))
                {
                echo "<img src=\"$icons_dir/movie.gif\" alt=\"Image\">";
                }
	else
		{
                echo "<img src=\"$icons_dir/unknown.gif\" alt=\"Image\">";
                }
	echo "</center>\n";

	echo "\t<TD><font face=\"courier\" size=\"-1\"><a href=\"./{$filen}\">$filen</a></font>\n";	# Filename
	echo "\t<TD><P align=right>$size</P>\n";		# Size (bytes)
	echo "\t<TD><font face=\"courier\" size=\"-1\">&nbsp;";						# Date info
	printf ("%2d %s %d (%02d:%02d)</font>\n", $mday, $month, $year, $hour, $min);

	$bytes = $bytes + $size;				
	$count++;
     }
   echo "</TABLE>\n";
  closedir($handle);
}
else
{
	print "<BR>Unable to open $base<BR>\n";			# Can't read the directory (Check permissions)
}
?>


</center>

<P>
<HR align="center" width=66%>
<P>
<? echo "Total of $count files and $bytes bytes of data\n<BR>";
?>

</font>

</BODY>
</HTML>

