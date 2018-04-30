Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180430140243.GB7960@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-10-vgoyal@redhat.com>
 <CAOQ4uxg5xDZJVuys69QtGBRGcs3=zfkJQoZgTZRp+cG+GGVzEQ@mail.gmail.com> <20180430140243.GB7960@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 30 Apr 2018 21:08:01 +0300
Message-ID: <CAOQ4uximhvDrOn6s-5X-BeGvfG0RtTBU-WA6fEjfyYEkn4jvNw@mail.gmail.com>
Subject: Re: [PATCH v14 09/31] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Apr 30, 2018 at 5:02 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, Apr 28, 2018 at 01:14:24AM -0700, Amir Goldstein wrote:
>> On Thu, Apr 26, 2018 at 12:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > This patch modifies ovl_lookup() and friends to lookup metacopy dentries.
>> > It also allows for presence of metacopy dentries in lower layer.
>> >
>> > During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
>> > set OVL_UPPERDATA bit in flags.
>> >
>> > We don't support metacopy feature with nfs_export. So in nfs_export code,
>> > we set OVL_UPPERDATA flag set unconditionally if upper inode exists.
>> >
>> > Do not follow metacopy origin if we find a metacopy only inode and metacopy
>> > feature is not enabled for that mount. Like redirect, this can have security
>> > implications where an attacker could hand craft upper and try to gain
>> > access to file on lower which it should not have to begin with.
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>>
>> Except for one comment below...
>>
>> > ---
>> >  fs/overlayfs/export.c    |   3 ++
>> >  fs/overlayfs/inode.c     |  11 ++++-
>> >  fs/overlayfs/namei.c     | 102 ++++++++++++++++++++++++++++++++++++++++-------
>> >  fs/overlayfs/overlayfs.h |   1 +
>> >  fs/overlayfs/util.c      |  22 ++++++++++
>> >  5 files changed, 124 insertions(+), 15 deletions(-)
>> >
>> > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
>> > index 5b7fee1a81ec..e1f6546b6c84 100644
>> > --- a/fs/overlayfs/export.c
>> > +++ b/fs/overlayfs/export.c
>> > @@ -311,6 +311,9 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
>> >                 return ERR_CAST(inode);
>> >         }
>> >
>> > +       if (upper)
>> > +               ovl_set_flag(OVL_UPPERDATA, inode);
>> > +
>> >         dentry = d_find_any_alias(inode);
>> >         if (!dentry) {
>> >                 dentry = d_alloc_anon(inode->i_sb);
>> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>> > index 59b1c84076ec..40509b7a50d2 100644
>> > --- a/fs/overlayfs/inode.c
>> > +++ b/fs/overlayfs/inode.c
>> > @@ -776,7 +776,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>> >         struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
>> >         bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
>> >         int fsid = bylower ? lowerpath->layer->fsid : 0;
>> > -       bool is_dir;
>> > +       bool is_dir, metacopy = false;
>> >         unsigned long ino = 0;
>> >         int err = -ENOMEM;
>> >
>> > @@ -836,6 +836,15 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>> >         if (index)
>> >                 ovl_set_flag(OVL_INDEX, inode);
>> >
>> > +       if (upperdentry) {
>> > +               err = ovl_check_metacopy_xattr(upperdentry);
>> > +               if (err < 0)
>> > +                       goto out_err;
>> > +               metacopy = err;
>> > +               if (!metacopy)
>> > +                       ovl_set_flag(OVL_UPPERDATA, inode);
>> > +       }
>> > +
>>
>> There is no reason to ovl_check_metacopy_xattr again here, right?
>
> I think we need to check metacopy here otherwise it becomes racy. For
> example, what if there is a hard link (say, l1 and l2) with metacopy xattr.
> ovl_lookup(l1) will think metacopy is on while another thread on another
> cpu might have trigged copy up, remove metacopy xattr. And it is possible
> that inode got flushed out of cache. So by the time ovl_lookup(l1), calls
> iget5_locked(), it will get a new inode and it will initialize inode
> with wrong information.
>
> I had done similar thing for REDIRECT, but once we removed logic to
> remove REDIRECT on copy up, I felt I did not have to check redirect
> again here.
>
> In general, I feel that once we have the inode lock, we should check
> metacopy and redirect both and then initialize inode. And not rely
> on information which was checked outside the lock and might have
> been stale by now.
>

Hmmm... so as you once already said, we have a race with INDEX as well.
In general, I feel it would be better to do a minimal sanity check inside
inode lock for INDEX and METACOPY (maybe REDIRECT) and make
sure they are consistent with the info in ovl_inode_info.
If they are not, return -ESTALE and that may result in re-calling
lookup.

Maybe Miklos has a better idea?

Thanks,
Amir.
