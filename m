From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs: regression bug from 4bacc9c9 (Make f_path always
 point to the overlay and f_inode to the underlay)
Date: Mon, 12 Oct 2015 15:50:05 +0200
Message-ID: <20151012135005.GA10697@tucsk>
References: <CAMXgnP7G-6bOu==DC_q2iQkfQ5p3YjSM8j1t=d-RbHBh-V9rOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMXgnP7G-6bOu==DC_q2iQkfQ5p3YjSM8j1t=d-RbHBh-V9rOA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alban Crequy <alban.crequy@gmail.com>
Cc: David Howells <dhowells@redhat.com>, sds@tycho.nsa.gov, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, LSM <linux-security-module@vger.kernel.org>, linux-unionfs@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Iago =?utf-8?B?TMOzcGV6?= Galeiras <iaguis@gmail.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Oct 07, 2015 at 02:23:23PM +0200, Alban Crequy wrote:
> Hi,
> 
> I'm reporting an issue in overlay fs that was introduced in v4.2 (it
> worked on v4.1): when overlay fs is mounted inside a overlay fs, I get
> a "no such device or address" error (ENXIO) during open(). After
> adding some debug printks, I found that the ENXIO comes from
> fs/inode.c:no_open().
> 
> The bug was initially reported on:
> https://github.com/coreos/rkt/issues/1537
> 
> The following commands can reproduce the issue:

Thanks for the excellent report.

See below for a fix.  Please let me know if you see any issues.

Thanks,
Miklos
---

Subject: ovl: fix open in stacked overlay
From: Miklos Szeredi <mszeredi@suse.cz>

If two overlayfs filesystems are stacked on top of each other, then we need
recursion in ovl_d_select_inode().

I guess d_backing_inode() is supposed to do that.  But currently it doesn't
and that functionality is open coded in vfs_open().  This is now copied
into ovl_d_select_inode() to fix this regression.

Reported-by: Alban Crequy <alban.crequy@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Fixes: 4bacc9c9234c ("overlayfs: Make f_path always point to the overlay...")
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org> # v4.2+
---
 fs/overlayfs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -363,6 +363,9 @@ struct inode *ovl_d_select_inode(struct
 		ovl_path_upper(dentry, &realpath);
 	}
 
+	if (realpath.dentry->d_flags & DCACHE_OP_SELECT_INODE)
+		return realpath.dentry->d_op->d_select_inode(realpath.dentry, file_flags);
+
 	return d_backing_inode(realpath.dentry);
 }
 
