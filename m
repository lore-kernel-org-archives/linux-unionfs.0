From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 7/9] ovl: Introduce read/write barriers around metacopy
 flag update
Date: Wed, 11 Oct 2017 16:27:13 -0400
Message-ID: <20171011202713.GF8086@redhat.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
 <1507649544-4539-8-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxisKjK+kH_kEMb7JPUHn+Gaoa7YNvQsS9W=REUPuywy+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752337AbdJKU1O (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2017 16:27:14 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxisKjK+kH_kEMb7JPUHn+Gaoa7YNvQsS9W=REUPuywy+A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>

On Tue, Oct 10, 2017 at 08:12:00PM +0300, Amir Goldstein wrote:
> On Tue, Oct 10, 2017 at 6:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > We can access and check metacopy flag outside ovl_inode->lock. IOW, say
> > a file was meta copied up in the past and it has metacopy flag set. Now
> > a data copy up operation in progress. Say another thread reads state of
> > this flag and if flag clearing is visible before file has been fully
> > copied up, that can cause problems.
> >
> >         CPU1                            CPU2
> > ovl_copy_up_flags()                     acquire(oi->lock)
> >  ovl_dentry_needs_data_copy_up()          ovl_copy_up_data_inode()
> >    ovl_test_metacopy_flag()                 ovl_copy_up_data()
> >                                             ovl_clear_metacopy_flag()
> >                                         release(oi->lock)
> >
> > Say CPU2 is copying up data and in the end clears metacopy flag. But if
> > CPU1 perceives clearing of metacopy before actual data copy up operation
> > being finished, that can become a problem. We want this clearing of flag
> > to be visible only if all previous write operations have finished.
> >
> > Hence this patch introduces smp_wmb() on metacopy flag set/clear operation
> > and smp_rmb() on metacopy flag test operation.
> >
> > May be some other lock or barrier is already covering it. But I am not sure
> > what that is and is it obvious enough that we will not break it in future.
> >
> > So hence trying to be safe here and introducing barriers explicitly for
> > metacopy bit.
> 
> Please revisit your changes after addressing my comment on patch 5.

Assume, we added smp_rmb() in ovl_upperdentry_dereference(), to make
sure by the time upperdentry is visible, OVL_METACOPY is visible too.

> IIUC the flow you describe above should be addressed by testing
> metacopy flag again under ovl inode lock.
> 
> The only subtle part imo is making metacopy flag visible
> Before making upper dentry visible.
> Clearing metacopy flag should not be a problem imo,
> As it comes after fsync, but didn't look closely.

Say a file has been metadata copied up only. So upper is visible and
OVL_METACOPY flag is set.

Now, what happens if two paths try to data copy up the file. Say first
path gets the oi->lock and starts doing data copy. Second path enters
ovl_copy_up_flags() and checks if data copy up is required or not. If
OVL_METACOPY is still set, then second process will block on oi->lock
and once first process exits will check OVL_METACOPY again under lock
and bail out. So that is not a problem.

What about the other case. That is OVL_METACOPY gets cleared before
data copy operation is complete. If I don't introduce smp_wmb()/smp_rmb()
around resetting of OVL_METACOPY, what will make sure that
ovl_copy_up_flags() will see OVL_METACOPY=0 only after data copy up is
complete. Of course we will not like to return to caller of
ovl_copy_up_flags() while data copy up is still going on on a different
cpu.

Adding a smp_rmb()/smp_wmb() pair around OVL_METACOPY should solve the
above and that's what this patch is about.

(I noticed that there is a bug in current patch. I should first LOAD
 OVL_METACOPY state, then do smp_rmb() and then return to caller with
 loaded state.).

Vivek


> 
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c   |  9 +++------
> >  fs/overlayfs/overlayfs.h |  3 +++
> >  fs/overlayfs/util.c      | 23 ++++++++++++++++++++++-
> >  3 files changed, 28 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 682852a78163..b10269b80803 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -465,8 +465,7 @@ static int ovl_copy_up_data_inode(struct ovl_copy_up_ctx *c)
> >         if (err)
> >                 return err;
> >
> > -       smp_wmb();
> > -       ovl_clear_flag(OVL_METACOPY, d_inode(c->dentry));
> > +       ovl_clear_metacopy_flag(d_inode(c->dentry));
> >         return err;
> >  }
> >
> > @@ -564,10 +563,8 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
> >                 goto out_cleanup;
> >
> >         ovl_inode_update(d_inode(c->dentry), newdentry);
> > -       if (c->metadata_only) {
> > -               smp_wmb();
> > -               ovl_set_flag(OVL_METACOPY, d_inode(c->dentry));
> > -       }
> > +       if (c->metadata_only)
> > +               ovl_set_metacopy_flag(d_inode(c->dentry));
> >  out:
> >         dput(temp);
> >         return err;
> > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> > index 773f5ad75729..df3f513de3cc 100644
> > --- a/fs/overlayfs/overlayfs.h
> > +++ b/fs/overlayfs/overlayfs.h
> > @@ -234,6 +234,9 @@ int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry);
> >  void ovl_set_flag(unsigned long flag, struct inode *inode);
> >  void ovl_clear_flag(unsigned long flag, struct inode *inode);
> >  bool ovl_test_flag(unsigned long flag, struct inode *inode);
> > +void ovl_set_metacopy_flag(struct inode *inode);
> > +void ovl_clear_metacopy_flag(struct inode *inode);
> > +bool ovl_test_metacopy_flag(struct inode *inode);
> >  bool ovl_inuse_trylock(struct dentry *dentry);
> >  void ovl_inuse_unlock(struct dentry *dentry);
> >  int ovl_nlink_start(struct dentry *dentry, bool *locked);
> > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> > index 91c542d1a39d..000f78b92a72 100644
> > --- a/fs/overlayfs/util.c
> > +++ b/fs/overlayfs/util.c
> > @@ -227,6 +227,27 @@ void ovl_dentry_set_upper_alias(struct dentry *dentry)
> >         oe->has_upper = true;
> >  }
> >
> > +bool ovl_test_metacopy_flag(struct inode *inode)
> > +{
> > +       /* Pairs with smp_wmb() in ovl_set_metacopy_flag() */
> > +       smp_rmb();
> > +       return ovl_test_flag(OVL_METACOPY, inode);
> > +}
> > +
> > +void ovl_set_metacopy_flag(struct inode *inode)
> > +{
> > +       /* Pairs with smp_rmb() in ovl_test_metacopy_flag() */
> > +       smp_wmb();
> > +       ovl_set_flag(OVL_METACOPY, inode);
> > +}
> > +
> > +void ovl_clear_metacopy_flag(struct inode *inode)
> > +{
> > +       /* Pairs with smp_rmb() in ovl_test_metacopy_flag() */
> > +       smp_wmb();
> > +       ovl_clear_flag(OVL_METACOPY, inode);
> > +}
> > +
> >  bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
> >         if (!S_ISREG(d_inode(dentry)->i_mode))
> >                 return false;
> > @@ -237,7 +258,7 @@ bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
> >         if (!(OPEN_FMODE(flags) & FMODE_WRITE))
> >                 return false;
> >
> > -       if (!ovl_test_flag(OVL_METACOPY, d_inode(dentry)))
> > +       if (!ovl_test_metacopy_flag(d_inode(dentry)))
> >                 return false;
> >
> >         return true;
> > --
> > 2.13.5
> >
