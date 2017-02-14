From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 9/9] overlay: mount/unmount base fs before/after
 running tests
Date: Tue, 14 Feb 2017 12:07:57 -0500
Message-ID: <20170214170757.nuhxnvhtctreelxt@thunk.org>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <1486932224-17075-10-git-send-email-amir73il@gmail.com>
 <20170214002356.dxrmf5jzwr6sivlu@thunk.org>
 <CAOQ4uxj131n=dadiuCzJZWTTC0Jkw=Bdpp1QpX=keBOOySYySg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39630 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755002AbdBNRIQ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Feb 2017 12:08:16 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj131n=dadiuCzJZWTTC0Jkw=Bdpp1QpX=keBOOySYySg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Tue, Feb 14, 2017 at 08:43:36AM +0200, Amir Goldstein wrote:
> 
> Correct. The only thing that overlay does not do is format the base fs,
> as the README says:
>         - for overlay tests: ./check -overlay [test(s)]
>           The TEST and SCRATCH partitions should be pre-formatted
>           with another base fs, where the overlay dirs will be created
> 

So this means that if I only want to do the equivalent of:

   gce-xfstests -c overlay generic/013

as part of a bisection search, it's impossible to do this via the
config file and "./check -s ext4-overlay generic/013" alone.  Someone
who wants to do this will have to use their own wrapper script to
format the base file system with the proper file system.

Correct?

Which is fine, I have my own wrapper script system.  :-)

      	       	      	     	     	    - Ted
