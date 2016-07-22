From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Stable inode numbers
Date: Fri, 22 Jul 2016 14:15:03 +0200
Message-ID: <20160722121503.GC20504@veci.piliscsaba.szeredi.hu>
References: <CAKp8XJ41QeG03E_AW4cxsuyp4-uxrPWAkhKc60OMp3vK2YAADA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34630 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbcGVMPN (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 22 Jul 2016 08:15:13 -0400
Received: by mail-wm0-f65.google.com with SMTP id q128so5961186wma.1
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Jul 2016 05:15:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAKp8XJ41QeG03E_AW4cxsuyp4-uxrPWAkhKc60OMp3vK2YAADA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vito Caputo <vito.caputo@coreos.com>
Cc: linux-unionfs@vger.kernel.org

On Thu, Jul 21, 2016 at 04:33:38PM -0700, Vito Caputo wrote:
> Hello list,
> 
> We're receiving bug reports from users simply untarring archives onto overlayfs
> mounts (docker + overlayfs) where tar fails with "Directory renamed before its
> status could be extracted" errors.
> 
> This is triggered in GNU tar when the inode number of an ancestor directory
> changes unexpectedly in the deferred application of ancestral metadata.
> 
> It's not consistently reproducible, but in a slightly memory-constrained vm it
> is very easy to reproduce.
> 
> What appears to be happening is the tar extraction activity is churning through
> the kernel's cache so a subsequent lookup of the directory in question returns
> a new inode number.  One can easily simulate this using `stat` and `echo 2 >
> /proc/sys/vm/drop_caches` to observe the overlayfs inode number change across
> the cache drop.
> 
> The seemingly erratic nature of this failure is particularly frustrating for
> users, as it gives the impression things _should_ work and just randomly aren't
> due to a bug.  Scrutiny of the overlayfs implementation reveals that unstable
> inode numbers is intentional, and spurious failures of applications which
> notice intersecting relevant cache evictions should be expected.
> 
> Are there any plans or strategies for changing this situation in overlayfs?
> 
> I can think of a few potential solutions, but they all tend to revolve around
> persistently allocating inode numbers on first lookup, which of course requires
> both space and time overlayfs currently elides.

Hmm, I haven't thought about this problem yet.

Maybe we are better off returning the underlying dev/ino in stat (which is
persistent long term, but not persistent during copy-up).  This would be
cheating a bit, since stat would then return the same numbers for the overlay
directory and the underlying directory, which can be different (unlike
non-directories, which overlayfs returns verbatim).

Can you please try the following patch.  It passes unionmount-testsuite with the
layering check disabled.

Thanks,
Miklos
---

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index ddda948109d3..f913b7b73e9d 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -147,9 +147,6 @@ static int ovl_dir_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	if (err)
 		return err;
 
-	stat->dev = dentry->d_sb->s_dev;
-	stat->ino = dentry->d_inode->i_ino;
-
 	/*
 	 * It's probably not worth it to count subdirs to get the
 	 * correct link count.  nlink=1 seems to pacify 'find' and
