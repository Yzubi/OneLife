# script run on main server to shutdown all servers and update them
# to the latest binary server code.  Does NOT update game data for the servers.


# shut them all down




echo "" 
echo "Shutting down remote servers, setting server shutdownMode flags."
echo ""

# feed file through grep to add newlines at the end of each line
# otherwise, read skips the last line if it doesn't end with newline
while read user server port
do
  echo "  Shutting down $server"
  ssh -n $user@$server '~/checkout/OneLife/scripts/remoteServerShutdown.sh'
done <  <( grep "" ~/www/reflector/remoteServerList.ini )







echo "" 
echo "Re-compiling non-running local server code base as a sanity check"
echo ""

cd ~/checkout/minorGems
git pull

cd ~/checkout/OneLife/server
git pull

./configure 1
make





echo "" 
echo "Triggering remote server rebuilds."
echo ""


# contiue with remote server rebuilds
while read user server port
do
  echo "  Starting update on $server"
  ssh -n $user@$server '~/checkout/OneLife/scripts/remoteServerCodeUpdate.sh'
done <  <( grep "" ~/www/reflector/remoteServerList.ini )


echo "" 
echo "Done updating code on all servers."
echo ""
