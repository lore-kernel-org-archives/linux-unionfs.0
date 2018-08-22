From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: set I_CREATING on inode being created
Date: Wed, 22 Aug 2018 21:58:15 +0200
Message-ID: <CAJfpegsZUxZXQSHZoy0=9iqB6jRL0ZOtFGnSqT4FrzT8K2mcbQ@mail.gmail.com>
References: <20180822085522.GA14354@veci.piliscsaba.redhat.com> <CA+55aFzd53LwrBfvdtKx7e_bQPhzsKEvCME1rGbrrY4pG94d=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzd53LwrBfvdtKx7e_bQPhzsKEvCME1rGbrrY4pG94d=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Aug 22, 2018 at 4:53 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Aug 22, 2018 at 1:55 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> +       spin_lock(&inode->i_lock);
>> +       inode->i_state |= I_CREATING;
>> +       spin_unlock(&inode->i_lock);
>> +
>
> Why is that spinlock protection there?
>
> Isn't this a new inode that cannot possibly be reached any other way yet?

new_inode() puts it on sb->s_inodes list, so it *is* reachable.
Following operate on s_inodes:

- evict_inodes() called from generic_shutdown_super(): a) we shouldn't
get here while in creation, b) it's careful to not touch inodes with
non-zero refcount

- invalidate_inodes(), called from block devices, so it doesn't apply
to overlayfs, also it skips inodes with non-zero refcount

- iterate_bdevs(), operates on blockdev_superblock

- fsnotify_unmount_inodes() called from generic_shutdown_super(): we
shouldn't get here while in creation,

- add_dquot_ref(), remove_dquot_ref(): not quite sure what these do,
but quotas are not (yet) supported on overlayfs

So looks like we are safe without a spinlock.

And there's another, more fundamental reason: if anything starts
messing with i_state of an inode that is not yet even had its state
changed to I_NEW, then lots of filesystems are in trouble.

> NOTE! This is a question. Maybe there is something I missed, and there
> *are* other ways to reach that inode. But if that's true, isn't it
> already too late to set I_CREATING?

No, it's not too late, I_CREATING can be set anytime up to
inode_insert5(), which is the first one to actually look at that flag.

> So I'd like some clarification on this point before applying it. It's
> possible that the spinlock is required, I just want to understand why.

I added the spinlock, because it's cheap (new_inode() already pulls it
into L1 cache) and because it's much harder to prove that lockless one
is correct than just adding that locking.

Thanks,
Miklos
