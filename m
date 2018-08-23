Return-Path: <david@fromorbit.com>
Date: Thu, 23 Aug 2018 10:27:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ovl: set I_CREATING on inode being created
Message-ID: <20180823002756.GR31495@dastard>
References: <CAOQ4uxhPbS5v5m3XAZ2MTbYcAmjBALXDoyhNf0wVW-SjA4Hjbg@mail.gmail.com>
 <CAJfpegtx_-KhS8NK4OadSDbfU_05KyCHd9g8OVVYufWX-ThkRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtx_-KhS8NK4OadSDbfU_05KyCHd9g8OVVYufWX-ThkRw@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Aug 22, 2018 at 10:41:21AM +0200, Miklos Szeredi wrote:
> On Fri, Aug 17, 2018 at 1:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > Miklos,
> >
> > I have 2 questions/comments w.r.t. commit 9475938ce8cf
> > ("ovl: set I_CREATING on inode being created") in overlayfs-next.
> >
> > 1. insert_inode_locked4() sets I_CREATING not inside
> > spinlock and your patch sets it inside spinlock.
> > technically, I guess the spinlock taken inside inode_insert5()
> > to set I_NEW and insert to hash probably provides the needed
> > barriers.
> 
> I was thinking along the same lines.  However, the spinlock is already
> in L1 cache (due to new_inode_pseudo() pulling it in) and is obviously
> uncontended, so it's basically free (at least compared to the actual
> creation of a new object, which follows).
> 
> The lock here is for documentation purposes.   Using the common
> pattern also makes possible future changes to i_state rules simpler.

IIRC from scalability stuff I did years ago, the reason the I_NEW
flag is set under the i_lock is to make the addition of the flag
atomic w.r.t. the inode hash insertion. This guarantees that by the
time anyone finds this inode in the inode hash and take the i_lock
to check i_state, they will see the I_NEW flag.

All the other initialisations that are done under the spinlock are
in places where we need to ensure that memory barriers are placed
(unlock to lock is required for a memory barrier) before 3rd parties
might have access to the inode (e.g. through new_inode()).


> > Do you think we should choose one of the practices
> > and stick with it??
> 
> The only lockless modification of i_state is insert_inode_locked4(),
> AFAICS.  I think it should either be converted to being locked or a
> comment added explaining why that is not done.

insert_inode_locked4() setting I_CREATING without locks on a newly
allocated inode that isn't in the inode hash looks to be safe - if
it gets inserted into the hash, then the i_lock is taken first, the
I_NEW flag is OR'd in and then it's inserted into the hash. Hence it
provides the same 3rd party visibility guarantees to I_CREATING as
it provides I_NEW.

> > 2. I find it nicer if ovl_new_inode() would return an I_CREATING
> > inode, to conform with the users of inode_insert_locked4() (e.g.
> > btrfs_new_inode()) this will conform with the pattern:
> > inode = XXXfs_new_inode(...);
> > d_instantiate_new(dentry, inode);
> > The call site d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
> > could either use a variant of ovl_new_inode() or we could
> > let ovl_inode_init() clear I_CREATING.
> 
> Normal filesystems already know the hash key when allocating the
> in-core inode.  That's not the case for overlay, that's why we need
> the unusual sequence of calls.  Basically before the inode is inserted
> it just doesn't matter when I_CREATING is set, we could just as well
> set it right before calling inode_insert5().

Yes, that's my understanding of how it's supposed to work, too.
I_CREATING just needs to be set on the inode before it is inserted
into the hash under the i_lock.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
