MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgcve4JJw+qjj55du4tOyXQQhWj8_ACwPGU74=w_-gcDg@mail.gmail.com>
References: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
	<1526632177-28832-10-git-send-email-amir73il@gmail.com>
	<CAJfpeguQDmWMMURur_Ds6NhQOQZZQAOiCdkgt0nFN2J_A5wB5Q@mail.gmail.com>
	<CAOQ4uxgcve4JJw+qjj55du4tOyXQQhWj8_ACwPGU74=w_-gcDg@mail.gmail.com>
Date: Fri, 18 May 2018 16:24:36 +0200
Message-ID: <CAJfpegsokXd9UR21dm3eZCq4AZVAG1O7S8sfvyd2y7msDqOg+Q@mail.gmail.com>
Subject: Re: [PATCH v4 9/9] ovl: use iget5_prealloc() to hash a newly created inode
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 18, 2018 at 4:08 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, May 18, 2018 at 1:14 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Fri, May 18, 2018 at 10:29 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> Currently, there is a small window where ovl_obtain_alias() can
>>> race with ovl_instantiate() and create two different overlay inodes
>>> with the same underlying real non-dir non-hardlink inode.
>>>
>>> The race requires an adversary to guess the file handle of the
>>> yet to be created upper inode and decode the guessed file handle
>>> after ovl_creat_real(), but before ovl_instantiate().
>>> This race does not affect overlay directory inodes, because those
>>> are decoded via ovl_lookup_real() and not with ovl_obtain_alias().
>>>
>>> This patch fixes the race, by using iget5_prealloc() to add a newly
>>> created inode to cache.
>>>
>>> If the newly created inode apears to already exist in cache (hashed
>>> by the same real upper inode), we instantiate the dentry with the old
>>> inode and drop the new inode, instead of silently not hashing the new
>>> inode.
>>>
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
>>>  fs/overlayfs/dir.c       | 81 +++++++++++++++++++++++++++++++++++-------------
>>>  fs/overlayfs/inode.c     | 12 +++++--
>>>  fs/overlayfs/overlayfs.h |  1 +
>>>  3 files changed, 70 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>>> index 6f7400be3fc8..833528d3e351 100644
>>> --- a/fs/overlayfs/dir.c
>>> +++ b/fs/overlayfs/dir.c
>>> @@ -217,24 +217,57 @@ static int ovl_set_opaque(struct dentry *dentry, struct dentry *upperdentry)
>>>         return ovl_set_opaque_xerr(dentry, upperdentry, -EIO);
>>>  }
>>>
>>> -/* Common operations required to be done after creation of file on upper */
>>> -static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
>>> -                           struct dentry *newdentry, bool hardlink)
>>> +/*
>>> + * Common operations required to be done after creation of file on upper.
>>> + * If @hardlink is false, then @inode is a pre-allocated inode, not yet on
>>> + * overlay's inode_sb_list.  If @newdentry is instantiated with @inode it
>>> + * takes a reference on @inode.
>>> + */
>>> +static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
>>> +                          struct dentry *newdentry, bool hardlink)
>>>  {
>>> +       struct ovl_inode_params oip = {
>>> +               .upperdentry = newdentry,
>>> +               .newinode = inode,
>>> +       };
>>> +
>>>         ovl_dir_modified(dentry->d_parent, false);
>>> -       ovl_copyattr(d_inode(newdentry), inode);
>>>         ovl_dentry_set_upper_alias(dentry);
>>>         if (!hardlink) {
>>> -               ovl_inode_update(inode, newdentry);
>>> +               /*
>>> +                * ovl_obtain_alias() can be called after ovl_create_real()
>>> +                * and before we get here, so we may get an inode from cache
>>> +                * with the same real upperdentry that is not the inode we
>>> +                * pre-allocated.  In this case we will use the cached inode
>>> +                * to instantiate the new dentry.
>>> +                *
>>> +                * XXX: if we ever use ovl_obtain_alias() to decode directory
>>> +                * file handles, need to use ovl_get_inode_locked() and
>>> +                * d_instantiate_new() here to prevent from creating two
>>> +                * hashed directory inode aliases.
>>> +                */
>>> +               inode = ovl_get_inode(dentry->d_sb, &oip);
>>> +               if (IS_ERR(inode))
>>> +                       return PTR_ERR(inode);
>>>         } else {
>>>                 WARN_ON(ovl_inode_real(inode) != d_inode(newdentry));
>>>                 dput(newdentry);
>>>                 inc_nlink(inode);
>>>         }
>>> +
>>> +       ihold(inode);
>>
>> I don't get it.   We can get rid of this ihold...
>>
>>
>>>         d_instantiate(dentry, inode);
>>> +       if (inode != oip.newinode) {
>>> +               pr_warn_ratelimited("overlayfs: newly created inode found in cache (%pd2)\n",
>>> +                                   dentry);
>>> +               iput(inode);
>>
>> ... and this iput ...
>>
>>> +       }
>>> +
>>>         /* Force lookup of new upper hardlink to find its lower */
>>>         if (hardlink)
>>>                 d_drop(dentry);
>>> +
>>> +       return 0;
>>>  }
>>>
>>>  static bool ovl_type_merge(struct dentry *dentry)
>>> @@ -273,11 +306,17 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
>>>                 ovl_set_opaque(dentry, newdentry);
>>>         }
>>>
>>> -       ovl_instantiate(dentry, inode, newdentry, !!attr->hardlink);
>>> -       err = 0;
>>> +       err = ovl_instantiate(dentry, inode, newdentry, !!attr->hardlink);
>>> +       if (err)
>>> +               goto out_cleanup;
>>>  out_unlock:
>>>         inode_unlock(udir);
>>>         return err;
>>> +
>>> +out_cleanup:
>>> +       ovl_cleanup(udir, newdentry);
>>> +       dput(newdentry);
>>> +       goto out_unlock;
>>>  }
>>>
>>>  static struct dentry *ovl_clear_empty(struct dentry *dentry,
>>> @@ -462,10 +501,9 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
>>>                 if (err)
>>>                         goto out_cleanup;
>>>         }
>>> -       ovl_instantiate(dentry, inode, newdentry, hardlink);
>>> -       newdentry = NULL;
>>> -out_dput2:
>>> -       dput(newdentry);
>>> +       err = ovl_instantiate(dentry, inode, newdentry, hardlink);
>>> +       if (err)
>>> +               goto out_cleanup;
>>>  out_dput:
>>>         dput(upper);
>>>  out_unlock:
>>> @@ -479,7 +517,8 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
>>>
>>>  out_cleanup:
>>>         ovl_cleanup(wdir, newdentry);
>>> -       goto out_dput2;
>>> +       dput(newdentry);
>>> +       goto out_dput;
>>>  }
>>>
>>>  static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
>>> @@ -547,8 +586,9 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
>>>         if (err)
>>>                 goto out;
>>>
>>> +       /* Preallocate inode to be used by ovl_get_inode() */
>>>         err = -ENOMEM;
>>> -       inode = ovl_new_inode(dentry->d_sb, mode, rdev);
>>> +       inode = alloc_inode(dentry->d_sb);
>>>         if (!inode)
>>>                 goto out_drop_write;
>>>
>>> @@ -556,9 +596,12 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
>>>         attr.mode = inode->i_mode;
>>>
>>>         err = ovl_create_or_link(dentry, inode, &attr, false);
>>> -       if (err)
>>> -               iput(inode);
>>>
>>> +       /* Did we ended up using the preallocated inode? */
>>> +       if (inode == d_inode(dentry))
>>> +               iput(inode);
>>
>> ... and this iput ...
>>
>
> -       if (err)
> -               iput(inode);
> +       /* Did we end up using the preallocated inode? */
> +       if (err || inode != d_inode(dentry))
> +               destroy_inode(inode);

Minor nit: we don't even need the "err ||" since in the error case
d_inode(dentry) will be NULL.   I'll fix that up.

Thanks,
Miklos
