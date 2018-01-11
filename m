From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3] ovl: Improving syncfs efficiency
Date: Thu, 11 Jan 2018 11:07:42 +0100
Message-ID: <20180111100742.exdlnmnrpejeqbds@quack2.suse.cz>
References: <1515635335-8848-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxhM0Cp3eBU2OfsDY9x1vMnBjMLw9qV-eK1g+yDi2erwiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34311 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932394AbeAKKHp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 Jan 2018 05:07:45 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhM0Cp3eBU2OfsDY9x1vMnBjMLw9qV-eK1g+yDi2erwiw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chengguang Xu <cgxu519@icloud.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Jan Kara <jack@suse.cz>

On Thu 11-01-18 05:30:33, Amir Goldstein wrote:
> [CC: Jan Kara]
> 
> On Thu, Jan 11, 2018 at 3:48 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
> > Currently syncfs(2) call on overlayfs just simply call sync_filesystem()
> > on upper_sb to synchronize whole dirty inodes in upper filesystem
> > regardless of the overlay ownership of the inode. It has obvious
> > shortcomings as below.
> >
> > (1) Performance
> > Synchronization is probably heavy in most cases, especially when upper
> > filesystem is not dedicated to target overlayfs.
> >
> > (2) Interference
> > Unplanned synchronization will probably impact IO performance of the
> > processes which use other overlayfs on same upper filesystem or directly
> > use upper filesystem.
> >
> > This patch iterates overlay inodes to only sync target dirty inodes in
> > upper filesystem. By doing this, It is able to reduce cost of synchronization
> > and will not seriously impact IO performance of irrelative processes.
> >
> > Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> 
> Looks good.
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> Jan,
> 
> Would you mind taking a quick look at this?
> 
> Overlayfs inodes have no dirty mapping, only the underlying upper inodes
> do, so sync_inodes_sb() is not enough for overlay syncfs().
> 
> This code creates the list of upper inodes to sync, syncs them and then
> calls the underlying upper fs sync_fs().
> 
> Does this look reasonable?

If I understand the original changelog, this is a performance motivated
change. As such it should have a some measurements accompanied with it to
justify the change. I.e., how much does this help? What is the exact setup
where this matters? Do users really care?

More technical comments inline.

> > @@ -80,6 +83,8 @@ struct ovl_inode {
> >
> >         /* synchronize copy up and more */
> >         struct mutex lock;
> > +       /* ovl inode sync list */
> > +       struct list_head sync_list;
> >  };

Additional overhead of 16-bytes per inode - not a huge deal since this is
overlay specific but it's something to keep in mind. Could not we reuse
i_io_list of the overlay inode instead?

> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 76440fe..947bb83 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
...
> > +static void ovl_sync_inodes(struct super_block *sb)
> > +{
> > +       struct ovl_fs *ofs = sb->s_fs_info;
> > +       struct inode *inode, *i_next;
> > +       struct inode *upper_inode;
> > +       struct blk_plug plug;
> > +
> > +       struct writeback_control wbc = {
> > +               .sync_mode              = WB_SYNC_ALL,
> > +               .for_sync               = 1,
> > +               .range_start            = 0,
> > +               .range_end              = LLONG_MAX,
> > +               .nr_to_write            = LONG_MAX,
> > +       };
> > +
> > +       blk_start_plug(&plug);
> > +       spin_lock(&sb->s_inode_list_lock);
> > +       list_for_each_entry_safe(inode, i_next, &sb->s_inodes, i_sb_list) {

Why a _safe iteration variant here? If you hope it allows you to safely
resume iteration after dropping sb->s_inode_list_lock, you are wrong
because i_next inode can be removed from the list once you drop that lock
as well.  You need to be more careful when iterating inodes. See how e.g.
fs/notify/fsnotify.c:fsnotify_unmount_inodes() plays tricks with always
keeping one inode reference to be able to resume iteration of the inode
list.

Another issue is that this will iterate all inodes on the overlayfs list.
Both clean and dirty ones (well, those where underlying upper inode is
dirty). When there are only a few underlying dirty inodes, this may be
considerably slower than the original behavior. So this needs an
explanation in the changelog why the use case you care about is more
important than the use case this regresses. You might think that this will
only add an iteration of an in memory list, but on large machines, this
list may have millions of entries so it's iteration is not exactly fast.

> > +               upper_inode = ovl_inode_upper(inode);
> > +               if (!upper_inode)
> > +                       continue;
> > +
> > +               spin_lock(&upper_inode->i_lock);
> > +               if (upper_inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE) ||
> > +                       list_empty(&upper_inode->i_io_list)) {
> > +                       spin_unlock(&upper_inode->i_lock);
> > +                       continue;
> > +               }
> > +               spin_unlock(&upper_inode->i_lock);
> > +
> > +               if (!igrab(inode))
> > +                       continue;
> > +
> > +               if (!igrab(upper_inode)) {
> > +                       iput(inode);

iput() under a spinlock? Not good, that always needs a very good
explanation why this cannot be the last reference to drop. Preferably avoid
this altogether.

> > +                       continue;
> > +               }
> > +               spin_unlock(&sb->s_inode_list_lock);
> > +
> > +               sync_inode(upper_inode, &wbc);
> > +               spin_lock(&ofs->ovl_sync_list_lock);
> > +               if (list_empty(&OVL_I(inode)->sync_list))
> > +                       list_add(&OVL_I(inode)->sync_list, &ofs->ovl_sync_list);
> > +               else {
> > +                       iput(upper_inode);
> > +                       iput(inode);

Again iput() under spinlock...

> > +               }
> > +               spin_unlock(&ofs->ovl_sync_list_lock);
> > +
> > +               if (need_resched()) {
> > +                       blk_finish_plug(&plug);
> > +                       cond_resched();
> > +                       blk_start_plug(&plug);
> > +               }
> > +               spin_lock(&sb->s_inode_list_lock);
> > +       }
> > +       spin_unlock(&sb->s_inode_list_lock);
> > +       blk_finish_plug(&plug);
> > +}

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
