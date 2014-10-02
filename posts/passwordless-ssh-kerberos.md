Title: Passwordless SSH with Kerberos
Date: 2014-11-02
Tags: linux

In research computing, passwordless SSH makes everything much more convenient,
especially when your data and computations are split across an array of cluster
resources.

For most clusters, this is [really easy](http://www.linuxproblem.org/art_9.html)
by exchanging public keys. For [Kerberos](http://en.wikipedia.org/wiki/Kerberos_(protocol)),
it's a little more complex. Here are the steps I used.

1. Follow your sysadmin's kerberos guide. At Stanford, I received a link to the
   [following set of instructions](http://sherlock.stanford.edu/mediawiki/index.php/SetupKerberos).
2. The problem, now, is that that `kinit` creates a kerberos ticket which only
   authorizes login for a fixed amount of time (e.g. 12 hours), and running
   `kinit` seems to require reentering your password.
3. But you can get a kerberos ticket using a "keytab" file, which is a hashed
   version of password that you can store locally. I ran the following, to
   create a new keytab file in`$HOME/.kerberos.keytab`.
   
        $ sudo apt-get install kstart   # (assuming you're using a debian-based distro)

        $ cd $HOME && ktutil 
        ktutil:  addent -password <MY_USERNAME@DOMAIN.EDU> -k 1 -e rc4-hmac
        usage: addent (-key | -password) -p principal -k kvno -e enctype
        <MY_PASSWORD>
        ktutil:  wkt .kerberos.keytab
        ktutil:  quit

4. Then I added the following line to my `.bashrc`. This gets a new kerberos
   ticket, using the keytab for authentication, every time I log in.

        /usr/bin/k5start -f $HOME/.kerberos.keytab
