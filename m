From: "J . Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 0/7] More NFS file handle unit tests
Date: Tue, 7 Nov 2017 14:54:51 -0500
Message-ID: <20171107195451.GC24262@fieldses.org>
References: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
 <1509711720.4744.9.camel@kernel.org>
 <1509837816.3820.4.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:48598 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751986AbdKGTyw (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 14:54:52 -0500
Content-Disposition: inline
In-Reply-To: <1509837816.3820.4.camel@kernel.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jeff Layton <jlayton@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Sat, Nov 04, 2017 at 07:23:36PM -0400, Jeff Layton wrote:
> On Fri, 2017-11-03 at 08:22 -0400, Jeff Layton wrote:
> > On Thu, 2017-11-02 at 12:15 +0200, Amir Goldstein wrote:
> > > Eryu,
> > > 
> > > This series enhances test coverage for generic NFS file handles
> > > encode/decode functionality and adds a new gereric/exportfs test.
> > > 
> > > Please note that the new test output includes the temporary test
> > > number 500, so don't forget to fix those when renaming the test.
> > > 
> > > The enhanced open_by_handle program is going to be used later on for
> > > overlayfs specific exportfs tests [1].
> > > 
> > > The open_by_handle program is limited to encoding "non-connectable"
> > > file handles (used by nfsd on 'no_subtree_check' exports), because there
> > > is no user available API (that I know of) to encode a "connecctable" file
> > > handle (used by nfsd on 'subtree_check' exports). I used a test patch
> > > "test connectable file handles", available on my tree [1] to tun the tests
> > > with "connectable" file handles.
> > > 
> > > I verified that the new test passes on xfs, ext4, ext2, btrfs, f2fs.
> > > However, the test fails on tmpfs due to:
> > > "open_by_handle() returned 116 incorrectly on an unlinked open file!"
> > > 
> > > This happens because tmpfs uses d_find_alias() to get a decoded dentry,
> > > but d_find_alias() skips unhashed (deleted with refcount) dentries.
> > > 
> > > I don't know if being able to decode a file handle of a deleted but open
> > > file is a requirement for nfsd or just a recommendation, but IMO it is a
> > > common case that is worth testing, even if tmpfs (or other file systems)
> > > choose not to fix this.
> > > 
> > > Bruce, Jeff,
> > > 
> > > What is your view on this issue?
> > > 
> > > 
> > 
> > It seems like something that should be a requirement.
> > 
> > A client could (for instance) send a READ for a filehandle with one of
> > the special anonymous stateids. If you can't decode the filehandle, you
> > really have no way to know what inode against which to issue the read.

Also even if you use a "real" stateid the current implementation will
error out if the filehandle lookup fails, and that might be complicated
to fix.

> That said...
> 
> If an open file is unlinked, and the server reboots you're more or less
> back in the same situation anyway. That's generally the reason for
> sillyrenaming in NFSv4.x instead of just removing the files outright.
> 
> The main takeaway is that with NFS in general, it's actually rather
> difficult to ensure that behavior across all server failure scenarios.
> It'd be nice if tmpfs did this like the others, but it's probably not
> fatal if it doesn't.

I guess.  The idea of failing on an unlinked inode still makes me
nervous, though.  It's supposed to be a look up by *inode*, not dentry.
NFSv4 client can hold files open after unlink, even if the possibility
of server reboots means applications don't get a real guarantee of that.
tmpfs exports aren't much use across server reboots anyway, though.

Some day we may fix the reboot problem--but possibly just by doing
something like sillyrename on the server side, so that wouldn't affect
this case much.

I think some users would likely notice if we broke the ability to look
up an unlinked file so I'd rather we kept that test in.

--b.
