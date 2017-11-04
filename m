From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH 0/7] More NFS file handle unit tests
Date: Sat, 04 Nov 2017 19:23:36 -0400
Message-ID: <1509837816.3820.4.camel@kernel.org>
References: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
         <1509711720.4744.9.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751477AbdKDXXj (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 4 Nov 2017 19:23:39 -0400
In-Reply-To: <1509711720.4744.9.camel@kernel.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Eryu Guan <eguan@redhat.com>
Cc: "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Fri, 2017-11-03 at 08:22 -0400, Jeff Layton wrote:
> On Thu, 2017-11-02 at 12:15 +0200, Amir Goldstein wrote:
> > Eryu,
> > 
> > This series enhances test coverage for generic NFS file handles
> > encode/decode functionality and adds a new gereric/exportfs test.
> > 
> > Please note that the new test output includes the temporary test
> > number 500, so don't forget to fix those when renaming the test.
> > 
> > The enhanced open_by_handle program is going to be used later on for
> > overlayfs specific exportfs tests [1].
> > 
> > The open_by_handle program is limited to encoding "non-connectable"
> > file handles (used by nfsd on 'no_subtree_check' exports), because there
> > is no user available API (that I know of) to encode a "connecctable" file
> > handle (used by nfsd on 'subtree_check' exports). I used a test patch
> > "test connectable file handles", available on my tree [1] to tun the tests
> > with "connectable" file handles.
> > 
> > I verified that the new test passes on xfs, ext4, ext2, btrfs, f2fs.
> > However, the test fails on tmpfs due to:
> > "open_by_handle() returned 116 incorrectly on an unlinked open file!"
> > 
> > This happens because tmpfs uses d_find_alias() to get a decoded dentry,
> > but d_find_alias() skips unhashed (deleted with refcount) dentries.
> > 
> > I don't know if being able to decode a file handle of a deleted but open
> > file is a requirement for nfsd or just a recommendation, but IMO it is a
> > common case that is worth testing, even if tmpfs (or other file systems)
> > choose not to fix this.
> > 
> > Bruce, Jeff,
> > 
> > What is your view on this issue?
> > 
> > 
> 
> It seems like something that should be a requirement.
> 
> A client could (for instance) send a READ for a filehandle with one of
> the special anonymous stateids. If you can't decode the filehandle, you
> really have no way to know what inode against which to issue the read.

That said...

If an open file is unlinked, and the server reboots you're more or less
back in the same situation anyway. That's generally the reason for
sillyrenaming in NFSv4.x instead of just removing the files outright.

The main takeaway is that with NFS in general, it's actually rather
difficult to ensure that behavior across all server failure scenarios.
It'd be nice if tmpfs did this like the others, but it's probably not
fatal if it doesn't.

-- 
Jeff Layton <jlayton@kernel.org>
