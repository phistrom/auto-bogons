# Automatically add BOGONs to your firewall's address lists.
# Only works with 6.43 and up.
#
# Please do not fetch more often than the listed update interval, for the 
# lists that are updated only as IANA allocations change, please do not fetch 
# more than once per day.
#
# by Phillip Stromberg
# 2018-11-07
# uses team-cymru.org BOGON lists

{
    :global content;
	:local url;
	:local addressListName;
	
	:set addressListName "AUTOBOGON"
	
	####################### UNCOMMENT THE URL YOU NEED: #######################
	
	### This is the list of bit notation bogons, aggregated, in text format.
	### Updated as IANA allocations and special prefix reservations are made.
	
	# :set url "https://www.team-cymru.org/Services/Bogons/bogon-bn-agg.txt"
	
	### The traditional bogon prefixes, plus prefixes that have been allocated to RIRs 
	### but not yet assigned by those RIRs to ISPs, end-users, etc.
	### Updated every four hours.
	
	# :set url "https://www.team-cymru.org/Services/Bogons/fullbogons-ipv4.txt"
	
	###########################################################################
	
    :local result [/tool fetch url=$url as-value output=user];
	
    :if ($result->"status" = "finished") do={
        :set content ($result->"data");
    }

    :global contentLen [ :len $content ];
    :global lineEnd 0;
    :global line "";
    :global lastEnd -1;
	
	/ip firewall address-list remove [find list=$addressListName];
	
    :do {
		:set lineEnd [:find $content "\n" $lastEnd ];
		:set line [:pick $content $lastEnd $lineEnd];
		:set lastEnd ( $lineEnd + 1 );
		:if ( [:pick $line 0] = "#" ) do={
		} else={
			# :put $line;
			/ip firewall address-list add address=$line list=$addressListName;
		}
		
    } while ($lineEnd < $contentLen - 2)
}
