From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: tentative fix for broken vfs_open() on stacked
 overlayfs.
Date: Mon, 28 Nov 2016 10:45:18 +0100
Message-ID: <20161128094518.GC2622@veci.piliscsaba.szeredi.hu>
References: <20161125145604.GG6842@chrystal.oracle.com>
 <20161125170923.21674-1-quentin.casasnovas@oracle.com>
 <20161125192847.GH6842@chrystal.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:34939 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754268AbcK1JpX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 28 Nov 2016 04:45:23 -0500
Received: by mail-wj0-f195.google.com with SMTP id o2so9425862wje.2
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Nov 2016 01:45:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161125192847.GH6842@chrystal.oracle.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Fri, Nov 25, 2016 at 08:28:47PM +0100, Quentin Casasnovas wrote:
> On Fri, Nov 25, 2016 at 06:09:23PM +0100, Quentin Casasnovas wrote:
> > If two overlayfs filesystems are stacked on top of each other, then we need
> > to recurse when opening a file.  This used to work and was first broken by:
> > 
> >   4bacc9c9234c ("overlayfs: Make f_path always point to the overlay...")
> > 
> > and fixed by:
> > 
> >   1c8a47df36d7 ("ovl: fix open in stacked overlay")
> > 
> > But it looks like it was re-introduced in:
> > 
> >   2d902671ce1c ("vfs: merge .d_select_inode() into .d_real()")

Thanks for the report.

Following patch should fix it (it's there in your patch, so you weren't too far
off).  It needs more testing and review, but I think it fixes the basic problem.

Thanks,
Miklos


diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index edd46a0e951d..f4d2f63fa53a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -328,7 +328,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	if (!real)
 		goto bug;
 
-	if (!inode || inode == d_inode(real))
+	if (inode && inode == d_inode(real))
 		return real;
 
 	/* Handle recursion */
