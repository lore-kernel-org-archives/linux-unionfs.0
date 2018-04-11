Return-Path: <vgoyal@redhat.com>
Date: Wed, 11 Apr 2018 09:31:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v13 20/28] ovl: Do not set dentry type ORIGIN for broken
 hardlinks
Message-ID: <20180411133107.GA4568@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
 <20180329193854.13814-21-vgoyal@redhat.com>
 <CAOQ4uxiJpXWXjWMWPa9DGzP06etO7-Y82MKdgroiD08Fhx9H6A@mail.gmail.com>
 <20180410140057.GA2776@redhat.com>
 <CAOQ4uxht5LMRpgTDg5AXyTOU4APnQavU-Q2WYpJOnBJNRi3Q4g@mail.gmail.com>
 <20180410205139.GA8490@redhat.com>
 <CAOQ4uxip6BJ5ZmXY8b_1gsnXp8fujHGvnK7kjYQ6e24SzovB9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxip6BJ5ZmXY8b_1gsnXp8fujHGvnK7kjYQ6e24SzovB9A@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 11, 2018 at 11:58:54AM +0300, Amir Goldstein wrote:
> On Tue, Apr 10, 2018 at 11:51 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Tue, Apr 10, 2018 at 10:20:43PM +0300, Amir Goldstein wrote:
> >> On Tue, Apr 10, 2018 at 5:00 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Fri, Mar 30, 2018 at 12:54:14PM +0300, Amir Goldstein wrote:
> >> >> On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> >> > If a dentry has copy up origin, we set flag OVL_PATH_ORIGIN. So far
> >> >> > this decision was easy that we had to check only for oe->numlower
> >> >> > and if it is non-zero, we knew there is copy up origin. (For non-dir
> >> >> > we installed origin dentry in lowerstack[0]).
> >> >> >
> >> >> > But we don't create ORGIN xattr for broken hardlinks (index=off). And
> >> >> > with metacopy feature it is possible that we will still install
> >> >> > lowerstack[0]. But that's lower data dentry of metacopy upper of broken
> >> >> > hardlink and not ORIGIN XATTR is not set.
> >> >> >
> >> >> > So two differentiate between two cases, do not set OVL_PATH_ORIGIN if
> >> >> > we have a broken hardlink.
> >> >> >
> >> >> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> >> >> > ---
> >> >> >  fs/overlayfs/util.c | 9 ++++++++-
> >> >> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >> >> >
> >> >> > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> >> >> > index 29f7336ade88..961d65bd25c9 100644
> >> >> > --- a/fs/overlayfs/util.c
> >> >> > +++ b/fs/overlayfs/util.c
> >> >> > @@ -117,7 +117,14 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
> >> >> >                  * Non-dir dentry can hold lower dentry of its copy up origin.
> >> >>
> >> >> This comment needs updating with metacopy.
> >> >>
> >> >> >                  */
> >> >> >                 if (oe->numlower) {
> >> >> > -                       type |= __OVL_PATH_ORIGIN;
> >> >> > +                       /*
> >> >> > +                        * ORIGIN is created for everyting except broken
> >> >> > +                        * hardlinks
> >> >> > +                        */
> >> >> > +                       if (!(d_inode(dentry)->i_nlink > 1 &&
> >> >> > +                           !ovl_test_flag(OVL_INDEX, d_inode(dentry))))
> >> >> > +                               type |= __OVL_PATH_ORIGIN;
> >> >> > +
> >> >>
> >> >> I don't like relying on overlay nlink. it is not reliable.
> >> >> And I think you missed the directory case.
> >> >
> >> > Directory should be fine because for directories ->i_nlink == 1 and this
> >> > condition will become true.
> >> >
> >> >> The information you need was available during lookup
> >> >> and we did not keep it (was lower verified by origin fh).
> >> >> Most likely what we need to do it store OVL_ORIGIN inode flag
> >> >> during lookup and then use ovl_test_flag(OVL_ORIGIN)
> >> >> in place of OVL_TYPE_ORIGIN(type).
> >> >>
> >> >> If I am not mistaken, you could set flag OVL_ORIGIN in
> >> >> ovl_get_inode() IFF (upperdentry && bylower), but to be honest
> >> >> the rules became so complicated that I can't say for sure.
> >> >> At least I concentrated all the rules in one helper ovl_hash_bylower(),
> >> >> so I hope that helps.
> >> >
> >> > Ok, I can put another ovl-inode flag say OVL_ORIGIN. But that also means
> >> > that I need to set the flag during copy up. And that means it brings
> >> > back ordering requirements for lockless access. For example, in
> >> > ovl_getattr(), if we replace OVL_TYPE_ORIGIN() with ovl_test_flag(ORIGIN),
> >> > without explicit barriers, what's the guarantee a user will see OVL_ORIGIN
> >> > flag yet. In fact it can happen that user might see upperdentry but not
> >> > OVL_ORIGIN.
> >>
> >> OK, so instead set OVL_BYLOWER in ovl_get_inode() IFF (bylower).
> >> that property doesn't change on copy up.
> >> and set __OVL_PATH_ORIGIN in ovl_path_type() if upper AND numlower
> >> AND OVL_BYLOWER.
> >
> > Ok, so at the time of lookup, we know if hardlink will be broken or
> > not and that property does not change over copy up. So yes that should
> > solve the issue.
> >
> > Having said that, OVL_BYLOWER is very broad in my opinion. Setting
> > OVL_ORIGIN in inode appeals more to me. This means this inode either
> > has copy up origin or will have copy up origin when copy up
> > happens.
> >
> > What do you think?
> 
> I think its better to choose a good flag name than to add complexity.
> How about OVL_CONST_INO?

OVL_CONST_INO sounds better in terms of naming. So it will translate
to ORIGIN.

OVL_ORIGIN = (upperdentry && OVL_CONST_INO)

> 
> >
> > I have another proposal. All these problems seem to stem from the
> > fact that copy up changes some of the fields in ovl_inode and we
> > don't have any strict ordering for the updates.
> >
> > I am wondering can we replace data dependency barrier
> > (smp_read_barrier_depends) with a full smp_read() and use that
> > for ovl_dentry_upper(). And do all the flag updates before
> > ovl_inode_update(). This should make sure that if caller sees
> > upperdentry, then not only upper dentry is table, at the same
> > time any updates to OVL_INDEX, OVL_ORIGIN and any other flags
> > have been done.
> >
> > So in copy up path, we will first update OVL_INDEX, OVL_ORIGIN etc
> > and then call ovl_inode_update(). And on read side fetch upperdentry
> > first and put smp_rmb() after that. And if upperdentry is visible,
> > that means INDEX and ORIGIN update must be visible as well.
> >
> > Copy up side
> > -----------
> >         store OVL_INDEX
> >         store OVL_ORIGIN
> >         store any other relevant flag
> >         smp_wmb()
> >         store ovl_inode->__upperdentry
> >
> > Read side (ovl_getxattr and other users)
> > -----------------------------------------
> >         load ovl_inode->__upperdentry
> >         smp_rmb()
> >         load OVL_INDEX
> >         load OVL_ORIGIN
> >
> > Now if ovl_inode->__upperdentry is set, that means not only upper dentry
> > is stable, it should also mean that ovl_inode->flags are stable too.
> >
> > If this theory of barrier operations is correct, I feel this is a better
> > solution. It is easy to understand at the same time it allows for
> > easy code extension in future.
> >
> > Right now, these lockless assumptions are so difficult to understand
> > and so error prone, that all the new users will invariably end up
> > introducing races.
> >
> 
> I see the value in your proposal, but:
> 1. I do not know how to measure the performance impact of this change.
> 2. patch 20/28 introduces another smp_wmb() in ovl_copy_up_locked()
> and it is not conditional to metacopy being enabled. Is that right?
> Can your proposal make that any better?

I am thinking that for now I will leave it as it is because OVL_CONST_INO
probably will solve the immediate issue. I will probably take up this
proposal in a separate patch series once we are done merging a basic
metacopy patch series.

Thanks
Vivek

> 
> >>
> >> >
> >> > In fact I see OVL_INDEX being used in ovl_getattr(). If a parallel copy
> >> > up took place it is possible that ovl_getattr() saw upperdentry but not
> >> > the OVL_INDEX. And then nlink count will be off. IOW, what barrier/lock
> >> > guarantees that this does not happen.
> >> >
> >>
> >> Yes. and that is not the only problem I see with ovl_getattr().
> >>
> >> stat->dev could be set to ovl_get_pseudo_dev(dentry), even
> >> if stat->ino is not set to lowerstat.ino; that is not good.
> >>
> >> If I am not mistaken, all the special conditions in ovl_getattr()
> >> to use lower st_ino are already encoded in ovl_hash_bylower(),
> >> so you may completely remove those extra tests if
> >> OVL_TYPE_ORIGIN(type) already checks the OVL_BYLOWER
> >> flag.
> >>
> >> It may be hard to see my claim above is true, because, for
> >> example, sb->s_export_op in ovl_hash_bylower() is equivalent
> >> to ovl_verify_lower(dentry->d_sb) in ovl_getattr().
> >>
> >> Please double check my claims, and if you agree, you can submit a
> >> patch that Fixes: ("a0c5ad307ac0 ovl: relax same fs constraint for
> >> constant st_ino"), which already does the right thing for metacopy.
> >
> > I will need to spend some time to better understand it. I feel that
> > changing barrier semantics around __upperdentry, will solve this
> > issue with existing code as well.
> >
> 
> Its a simple bug not related to barriers semantics.
> I will post a fix patch.
> 
> Thanks,
> Amir.
