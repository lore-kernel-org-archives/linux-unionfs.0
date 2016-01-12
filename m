From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] overlay: test copy up files from lower dir
Date: Tue, 12 Jan 2016 15:06:27 +1100
Message-ID: <20160112040626.GF6033@dastard>
References: <1452512301-22145-1-git-send-email-eguan@redhat.com>
 <1452512301-22145-2-git-send-email-eguan@redhat.com>
 <20160111203135.GA6033@dastard>
 <20160112034633.GO21019@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:13743 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758151AbcALEG3 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 11 Jan 2016 23:06:29 -0500
Content-Disposition: inline
In-Reply-To: <20160112034633.GO21019@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

On Tue, Jan 12, 2016 at 11:46:33AM +0800, Eryu Guan wrote:
> On Tue, Jan 12, 2016 at 07:31:35AM +1100, Dave Chinner wrote:
> > On Mon, Jan 11, 2016 at 07:38:21PM +0800, Eryu Guan wrote:
> > > Test copy up files from lower dir that are <, =, > 4G in size.
> > > 
> > > Kernel commit 0480334fa604 ("ovl: use O_LARGEFILE in ovl_copy_up()")
> > > fixed bug when copying up large file(>4G) from lower dir.
> > > 
> > > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > > ---
> > >  tests/overlay/001      | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/overlay/001.out  |  2 ++
> > >  tests/overlay/Makefile | 20 +++++++++++++
> > >  tests/overlay/group    |  6 ++++
> > >  4 files changed, 104 insertions(+)
> > >  create mode 100755 tests/overlay/001
> > >  create mode 100644 tests/overlay/001.out
> > >  create mode 100644 tests/overlay/Makefile
> > >  create mode 100644 tests/overlay/group
> > > 
> > > diff --git a/tests/overlay/001 b/tests/overlay/001
> > > new file mode 100755
> > > index 0000000..5025a69
> > > --- /dev/null
> > > +++ b/tests/overlay/001
> > > @@ -0,0 +1,76 @@
> > > +#! /bin/bash
> > > +# FS QA Test 002
> > 
> > 002 != 001 ;)
> 
> Ah, I missed that after "mv 002 001"..

"tools/mvtest overlay/002 overlay/001" will do all that stuff for
you now. When I get an updated sort script from Darrick, it will
even update the group files correctly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
