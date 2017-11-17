From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v7 09/14] ovl: A new xattr OVL_XATTR_METACOPY for file on
 upper
Date: Fri, 17 Nov 2017 15:34:43 -0500
Message-ID: <20171117203443.GE15566@redhat.com>
References: <20171116220335.13448-1-vgoyal@redhat.com>
 <20171116220335.13448-10-vgoyal@redhat.com>
 <CAOQ4uxgb0mC2qEAL0AbC7qY-Hv+PcoHMXhfadqojhA=iPHuh1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935917AbdKQUeo (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2017 15:34:44 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgb0mC2qEAL0AbC7qY-Hv+PcoHMXhfadqojhA=iPHuh1Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 17, 2017 at 06:07:24PM +0200, Amir Goldstein wrote:
> On Fri, Nov 17, 2017 at 12:03 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Now we will have the capability to have upper inodes which might be only
> > metadata copy up and data is still on lower inode. So add a new xattr
> > OVL_XATTR_METACOPY to distinguish between two cases.
> >
> > Presence of OVL_XATTR_METACOPY reflects that file has been copied up metadata
> > only and and data will be copied up later from lower origin.
> > So this xattr is set when a metadata copy takes place and cleared when
> > data copy takes place.
> >
> > We also use a bit in ovl_inode->flags to cache OVL_UPPERDATA which reflects
> > whether ovl inode has data or not (as opposed to metadata only copy up).
> >
> > If a file is copied up metadata only and later when same file is opened
> > for WRITE, then data copy up takes place. We copy up data, remove METACOPY
> > xattr and then set the UPPERDATA flag in ovl_entry->flags. While all
> > these operations happen with oi->lock held, read side of oi->flags can be
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
> > ovl_d_real()                            acquire(oi->lock)
> >  ovl_open_maybe_copy_up()                ovl_copy_up_data()
> >   open_open_need_copy_up()               vfs_removexattr()
> >    ovl_already_copied_up()
> >     ovl_dentry_needs_data_copy_up()      ovl_set_flag(OVL_UPPERDATA)
> >      ovl_test_flag(OVL_UPPERDATA)       release(oi->lock)
> >
> > Say CPU2 is copying up data and in the end sets UPPERDATA flag. But if
> > CPU1 perceives the effects of setting UPPERDATA flag but not the effects
> > of preceeding operations (ex. upper that is not fully copied up), it will be
> > a problem.
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
> 
> Vivek,
> 

[..]
> I like this version a lot more, but IMO it could still be even simpler.
> 
> > Note, we now set OVL_UPPERDATA on all kind of dentires and check
> > OVL_UPPERDATA only where it makes sense. If a file is created on upper,
> > we set OVL_UPPERDATA. This can be accessed lockless in ovl_d_real()
> > path again. This time ordering dependency is w.r.t oe->__upperdata. We
> > need to make surr OVL_UPPERDATA is visible before oe->__upperdata is
> > visible. Otherwise following code path might try to copy up an upper
> > only file.
> 
> Why all this explanations?
> Just use ovl_set_upperdata() when creating upper and be done with it.

Just using ovl_set_upperdata() will not do away with ordering dependency
right? I mean, setting OVL_UPPERDATA in file creation path has different
ordering requirement (same is the case of >has_upper). And I wanted to
highlight that ordering requirement in changelogs.

I can get rid of it. But this seems such a subtle requirement, I think
its a good idea to talk about it explicitly.

> Creating new upper is expensive anyway, so I don't think we should
> care about an unneeded smp_wmb() and probably Miklos will know to
> tell why it is not needed anyway.

Ok, I can call ovl_set_upperdata() in creation path and not worry about
extra unneeded smp_wmb().

> 
> It is very easy to make sure that the  OVL_UPPERDATA is always set
> for the pure upper and non regular file cases and then we have no need
> for ovl_should_check_upperdata().
> Simple is better.

It avoids lots of smp_rmb() calls on files which should not have
OVL_UPPERDATA. Now I don't know what is more expensive. smp_rmb() or
calling ovl_should_check_upperdata().

Also, it calls ovl_dentry_lower() and that covers the possible race
with setting of OVL_UPPERDATA on file creation and setting of
oi->__upperdentry.

So if I remove this check, in-theory we open that race.

> 
> There is just one more thing you need to do before killing
> ovl_should_check_upperdata() - set the OVL_UPPERDATA on the root
> inode in ovl_fill_super().

That's a good point. Will do.

[..]
> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > index e13921824c70..fb3cd73c3693 100644
> > --- a/fs/overlayfs/dir.c
> > +++ b/fs/overlayfs/dir.c
> > @@ -158,6 +158,7 @@ static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
> >         ovl_dentry_version_inc(dentry->d_parent, false);
> >         ovl_dentry_set_upper_alias(dentry);
> >         if (!hardlink) {
> > +               ovl_set_flag(OVL_UPPERDATA, inode);
> 
> Call ovl_set_upperdata() instead?


Will do.

[..]
> > +bool ovl_has_upperdata(struct dentry *dentry) {
> > +       if (!ovl_should_check_upperdata(dentry))
> > +               return true;
> > +
> 
> 
> IMO we don't need this check, but you may leave it as
> if (WARN_ON(!ovl_should_check_upperdata(dentry)
> after ovl_test_flag() to be on the safe side.

I primarily kept it as it avoided smp_rmb() for directories and
non-regular files.

Also not sure how can I use it as WARN_ON(). Now OVL_UPPERDATA is set
on all files/dir. So we will hit WARN_ON() all the time?

> 
> 
> > +       if (!ovl_test_flag(OVL_UPPERDATA, d_inode(dentry)))
> > +               return false;
> > +       /*
> > +        * Pairs with smp_wmb() in ovl_copy_up_meta_inode_data(). Make sure
> 
> To be consistent, you should update the comment to say pairs with... in
> ovl_set_upperdata(), although it may be useful to leave the information that
> the main user of ovl_set_upperdata() is ovl_copy_up_meta_inode_data().
> 

Ok.

> > +        * if setting of OVL_UPPERDATA is visible, then effects of writes
> > +        * before that are visible too.
> > +        */
> > +       smp_rmb();
> > +       return true;
> > +}
> > +
> > +void ovl_set_upperdata(struct dentry *dentry) {
> > +       /*
> > +        * Pairs with smp_rmb() in ovl_has_upperdata(). Make sure
> > +        * if OVL_UPPERDATA flag is visible, then effects of write operations
> > +        * before it are visible as well.
> > +        */
> > +       smp_wmb();
> > +       ovl_set_flag(OVL_UPPERDATA, d_inode(dentry));
> > +}
> > +
> > +static inline bool open_for_write(int flags)
> 
> Need ovl_ namespace prefix
> and the name sounds like an action (i.e. a request to open for write)

ovl_opened_for_write_or_trunc()?

> 
> > +{
> > +       if (flags && (OPEN_FMODE(flags) & FMODE_WRITE))
> 
> What I meant in previous review is that you make a static inline helper
> in overlayfs.h to be used by this and ovl_open_need_copy_up().
> Your helper is missing the O_TRUNC test, i.e.
> 
> return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));
> 
> It may sound like we don't *need* to copy up data on O_TRUNC,
> but in fact, if we don't call copy up functions, we won't be cleaning the
> metacopy xattr/flag on truncate.
> 
> The thing is that the result of O_TRUNC|O_RDONLY is not even well
> defined by man page ("... Otherwise, the effect of O_TRUNC is unspecified"),
> but we shouldn't change the way overlayfs treats this strange combination.

Hmm.., I had not thought about O_TRUNC|O_RDONLY for a metacopy only file.
Will check for  it as well.

Vivek
