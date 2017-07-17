From: Eryu Guan <eguan@redhat.com>
Subject: Re: [4.13-rc1 regression] copyup crashes kernel when initializing
 selinux
Date: Mon, 17 Jul 2017 20:12:01 +0800
Message-ID: <20170717121201.GR2478@eguan.usersys.redhat.com>
References: <20170717093741.GP2478@eguan.usersys.redhat.com>
 <20170717112503.GB5256@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751289AbdGQMME (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 17 Jul 2017 08:12:04 -0400
Content-Disposition: inline
In-Reply-To: <20170717112503.GB5256@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>

On Mon, Jul 17, 2017 at 01:25:03PM +0200, Miklos Szeredi wrote:
> On Mon, Jul 17, 2017 at 05:37:41PM +0800, Eryu Guan wrote:
> > Hi all,
> > 
> > I hit a kernel crash with 4.13-rc1 kernel when running fstests
> > overlay/005. And git bisect pointed first bad to this commit
> > 
> > commit 09d8b586731bf589655c2ac971532c14cf272b63
> > Author: Miklos Szeredi <mszeredi@redhat.com>
> > Date:   Tue Jul 4 22:03:16 2017 +0200
> > 
> >     ovl: move __upperdentry to ovl_inode
> > 
> >     Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > 
> > inode_doinit_with_dentry wants to read the upper inode's xattr to get
> > selinux information, and ovl_xattr_get() calls ovl_dentry_real(), which
> > depends on dentry->d_inode, but d_inode is null and not initialized yet
> > at this moment.
> > 
> > Mount overlay without selinux context mount option and trigger copyup
> > could reproduce the crash reliably. (The crash log I appended is from a
> > bisect run, so the kernel version is not exact 4.13-rc1.)
> 
> Could you please test following patch?

This patch works for me, but I just ran overlay/005, didn't run other
tests.

Thanks,
Eryu
