From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 09/11] vfs: factor out inode_insert5()
Date: Mon, 11 Jun 2018 13:32:30 +0200
Message-ID: <20180611113230.GI23785@veci.piliscsaba.redhat.com>
References: <20180529144143.16378-1-mszeredi@redhat.com>
 <20180529144143.16378-10-mszeredi@redhat.com>
 <20180610054902.GQ30522@ZenIV.linux.org.uk>
 <20180610060159.GS30522@ZenIV.linux.org.uk>
 <CAJfpegt5guR3zJeATw4-N41Ad2n9pcB5mQoLmSLOfocnEoodVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegt5guR3zJeATw4-N41Ad2n9pcB5mQoLmSLOfocnEoodVg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jun 11, 2018 at 11:15:55AM +0200, Miklos Szeredi wrote:
> On Sun, Jun 10, 2018 at 8:02 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Sun, Jun 10, 2018 at 06:49:10AM +0100, Al Viro wrote:
> >> On Tue, May 29, 2018 at 04:41:41PM +0200, Miklos Szeredi wrote:
> >> > From: Miklos Szeredi <miklos@szeredi.hu>
> >> >
> >> > Split out common helper for race free insertion of an already allocated
> >> > inode into the cache.  Use this from iget5_locked() and
> >> > insert_inode_locked4().  Make iget5_locked() use new_inode()/iput() instead
> >> > of alloc_inode()/destroy_inode() directly.
> >>
> >> ... thus hitting the sucker with ->evict_inode(), in condition that is quite
> >> likely to be unfit to be seen by that.
> >>
> >> NAK.
> >
> > To clarify: objection here is against the switch to new_inode/iput.  The rest is
> > sane.  What makes new_inode() better here, anyway?
> 
> Umm, got to look into this.  The patch has already been pulled by
> Linus, but I hope it's salvageable.

Incremental follows.  I think it's cleaner to initialize i_state and i_sb_list
up front (hence the use of new_inode()), but could just as well add to sb list
afterwards.

---
diff --git a/fs/inode.c b/fs/inode.c
index 0df41bb77e0f..03c0d7c1296f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1098,8 +1098,10 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
 
 		if (new) {
 			inode = inode_insert5(new, hashval, test, set, data);
-			if (unlikely(inode != new))
-				iput(new);
+			if (unlikely(inode != new)) {
+				inode_sb_list_del(inode);
+				destroy_inode(new);
+			}
 		}
 	}
 	return inode;
