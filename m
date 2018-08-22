MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhPbS5v5m3XAZ2MTbYcAmjBALXDoyhNf0wVW-SjA4Hjbg@mail.gmail.com>
References: <CAOQ4uxhPbS5v5m3XAZ2MTbYcAmjBALXDoyhNf0wVW-SjA4Hjbg@mail.gmail.com>
Date: Wed, 22 Aug 2018 10:41:21 +0200
Message-ID: <CAJfpegtx_-KhS8NK4OadSDbfU_05KyCHd9g8OVVYufWX-ThkRw@mail.gmail.com>
Subject: Re: ovl: set I_CREATING on inode being created
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Aug 17, 2018 at 1:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> I have 2 questions/comments w.r.t. commit 9475938ce8cf
> ("ovl: set I_CREATING on inode being created") in overlayfs-next.
>
> 1. insert_inode_locked4() sets I_CREATING not inside
> spinlock and your patch sets it inside spinlock.
> technically, I guess the spinlock taken inside inode_insert5()
> to set I_NEW and insert to hash probably provides the needed
> barriers.

I was thinking along the same lines.  However, the spinlock is already
in L1 cache (due to new_inode_pseudo() pulling it in) and is obviously
uncontended, so it's basically free (at least compared to the actual
creation of a new object, which follows).

The lock here is for documentation purposes.   Using the common
pattern also makes possible future changes to i_state rules simpler.

> Do you think we should choose one of the practices
> and stick with it??

The only lockless modification of i_state is insert_inode_locked4(),
AFAICS.  I think it should either be converted to being locked or a
comment added explaining why that is not done.

> 2. I find it nicer if ovl_new_inode() would return an I_CREATING
> inode, to conform with the users of inode_insert_locked4() (e.g.
> btrfs_new_inode()) this will conform with the pattern:
> inode = XXXfs_new_inode(...);
> d_instantiate_new(dentry, inode);
> The call site d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
> could either use a variant of ovl_new_inode() or we could
> let ovl_inode_init() clear I_CREATING.

Normal filesystems already know the hash key when allocating the
in-core inode.  That's not the case for overlay, that's why we need
the unusual sequence of calls.  Basically before the inode is inserted
it just doesn't matter when I_CREATING is set, we could just as well
set it right before calling inode_insert5().

Thanks,
Miklos
