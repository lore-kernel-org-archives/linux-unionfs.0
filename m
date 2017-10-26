From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 11/13] ovl: Introduce read/write barriers around metacopy
 flag update
Date: Thu, 26 Oct 2017 13:54:58 -0400
Message-ID: <20171026175458.GB6704@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
 <1508958575-14086-12-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxio4ZESiJ35dAimnFW_YcdEpmRCPqMPDB5i2AWvRg2WOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40889 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932309AbdJZRy7 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 13:54:59 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxio4ZESiJ35dAimnFW_YcdEpmRCPqMPDB5i2AWvRg2WOA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 26, 2017 at 09:34:15AM +0300, Amir Goldstein wrote:
> On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > If a file is copied up metadata only and later when same file is opened
> > for WRITE, then data copy up takes place. We copy up data, remove METACOPY
> > xattr and then set the UPPERDATA flag in ovl_entry->flags. While all
> > these operations happen with oi->lock held, read side of oi->flags is
> > lockless. That is another thread on another cpu can check if UPPERDATA
> > flag is set or not.
> >
> > So this gives us an ordering requirement w.r.t UPPERDATA flag. That is, if
> > another cpu sees UPPERDATA flag set, then it should be guaranteed that
> > effects of data copy up and remove xattr operations are also visible.
> >
> > For example.
> >
> >         CPU1                            CPU2
> > ovl_copy_up_flags()                     acquire(oi->lock)
> >  ovl_dentry_needs_data_copy_up()          ovl_copy_up_data()
> >    ovl_test_flag(OVL_UPPERDATA)           vfs_removexattr()
> >                                           ovl_set_flag(OVL_UPPERDATA)
> >                                         release(oi->lock)
> >
> > Say CPU2 is copying up data and in the end sets UPPERDATA flag. But if
> > CPU1 perceives the effects of setting UPPERDATA flag but not effects of
> > preceeding operations, that would be a problem.
> 
> Why would that be a problem?
> What can go wrong?

That's a good question. I really don't have a concrete example where I can
say this this can go wrong. Can you think of something.

> If you try to answer the question instead of referring to a vague "problem"
> you will see that only the ovl_d_real() code path can be a problem.

Right. And ovl_copy_up_flags() will be called from ovl_d_real().  Will
update it to show cover more of parent chain.

> and maybe
> (I did not check) ovl_getattr. Please change your example above to ovl_d_real()
> code path of CPU1

Will do.

I looked at ovl_getattr() and can't think why smp_rmb() is needed there.
We check UPPERDATA in the end if flag is not visible, then we do stat
on lower. Which should be fine as if other cpu is doing copy up, there
are no guarantees that ovl_getattr() will see updates.

And if UPPERDATA is set, then we don't do anything and simply return, so
that should not matter either. In d_real() we return upperdentry so we
need to make sure it is stable that's why smp_rmb(). In ovl_getattr()
we don't return upper dentry, so smp_rmb() is probably not required.

> 
> >
> > Hence this patch introduces smp_wmb() on setting UPPERDATA flag operation
> > and smp_rmb() on UPPERDATA flag test operation.
> >
> > May be some other lock or barrier is already covering it. But I am not sure
> > what that is and is it obvious enough that we will not break it in future.
> >
> > So hence trying to be safe here and introducing barriers explicitly for
> > UPPERDATA flag/bit.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c |  7 ++++++-
> >  fs/overlayfs/super.c   | 13 ++++++++++---
> >  fs/overlayfs/util.c    | 11 ++++++++++-
> >  3 files changed, 26 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index a6cda02..4876ae4 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -466,7 +466,12 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
> >         err= vfs_removexattr(upperpath.dentry, OVL_XATTR_METACOPY);
> >         if (err)
> >                 return err;
> > -
> > +       /*
> > +        * Pairs with smp_rmb() in ovl_dentry_needs_data_copy_up(). Make sure
> 
> Nope. only pairs with smp_rmpb() in ovl_d_real() (or in a new helper
> you need to create)

Please see further down about my argument that why we should retain 
smp_rmb() in ovl_dentry_needs_data_copy_up().

> 
> 
> > +        * if OVL_UPPERDATA flag is visible, then all the write operations
> > +        * before it are visible as well.
> > +        */
> > +       smp_wmb();
> >         ovl_set_flag(OVL_UPPERDATA, d_inode(c->dentry));
> >         return err;
> >  }
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 4cf1f98..e97dccb 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -102,9 +102,16 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
> >                         if (err)
> >                                 return ERR_PTR(err);
> >
> > -                       if (ovl_dentry_check_upperdata(dentry) &&
> > -                           !ovl_test_flag(OVL_UPPERDATA, d_inode(dentry)))
> > -                               goto lower;
> > +                       if (ovl_dentry_check_upperdata(dentry)) {
> > +                               if (!ovl_test_flag(OVL_UPPERDATA,
> > +                                   d_inode(dentry)))
> > +                                       goto lower;
> > +                               /*
> > +                                * Pairs with smp_wmb in
> > +                                * ovl_copy_up_meta_inode_data()
> > +                                */
> > +                               smp_rmb();
> > +                       }
> >                 }
> >                 return real;
> >         }
> > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> > index ef720a9..d0f3bf7 100644
> > --- a/fs/overlayfs/util.c
> > +++ b/fs/overlayfs/util.c
> > @@ -238,6 +238,8 @@ bool ovl_dentry_check_upperdata(struct dentry *dentry) {
> >  }
> >
> >  bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
> > +       bool upperdata;
> > +
> >         if (!ovl_dentry_check_upperdata(dentry))
> >                 return false;
> >
> > @@ -250,7 +252,14 @@ bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
> >         if (!(OPEN_FMODE(flags) & FMODE_WRITE))
> >                 return false;
> >
> > -       if (likely(ovl_test_flag(OVL_UPPERDATA, d_inode(dentry))))
> > +       upperdata = ovl_test_flag(OVL_UPPERDATA, d_inode(dentry));
> > +       /*
> > +        * Pairs with smp_wmb() in ovl_copy_up_meta_inode_data(). Make sure
> > +        * if setting of OVL_UPPERDATA is visible, then effects of writes
> > +        * before that are visible too.
> > +        */
> > +       smp_rmb();
> > +       if (upperdata)
> 
> Nope. smp_rmb() is not needed here, because most of the places that
> use this helper
> will take a lock and call it again under lock.

When you say "lock" you are referring to oi->lock, right?

If yes, I see 3 callsites of ovl_dentry_needs_data_copy_up() right now and
two of them are lockless(). Calls from ovl_d_real() and ovl_copy_up_flags()
are lockless while call from ovl_copy_up_one() is locked.

ovl_d_real() is one example of lockless access. There are others. Anybody
whole call ovl_copy_up() will call this lockless. That's a different
thing that ovl_copy_up() right now does not specify WRITE flag so data
copy up will not take place. But that's an internal detail of meaning of
the bit at this point of time. 

I would rather place barrier right next to bit/flag which is being
protectd, instead of putting it somewhere far up in the call chain. That
makes understanding code hard at the same time possibility of of error
increases.

IOW, this is no different from ovl_dentry_upper() where data dependency
barrier is placed right next to pointer which is being protected. And
now ovl_dentry_upper() is called both from lockless and locked code.

> You may need an explicit smp_rmb() also in getattr() though, so you
> can create a new
> helper that does exactly what the hunk in ovl_d_real does and reuse
> the helper in ovl_getattr
> 

Right. getattr() seems to be racy right now. getattr() should either
return number of blocks from lower (if metacopy only) or from upper
(after data copy has stablized). But not anything in between.

And right now, I think multiple races are possible.

		CPU1			CPU2
	ovl_getattr()
	vfs_getattr(upper)
					data_copy_up_finished;
					smp_wmb()
					OVL_UPPERDATA=1
	test OVL_UPPERDATA=1
	smp_rmb()
	return

So when we did vfs_getattr() on upper first time, it could be any number
of blocks (either 0 or intermediate state). In that case should always
return blocks from lower (I think).

So that probably means that OVL_UPPERDATA should be checked early,
possibly with smp_rmb() and then decision should be made in advance
whether to query lower or not.

I will fix it. Thanks for bringing it up.

Vivek
