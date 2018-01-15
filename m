From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 04/17] ovl: decode connected upper dir file handles
Date: Mon, 15 Jan 2018 15:56:06 +0100
Message-ID: <CAJfpegvCVX-YEMRDfKTYM2Au=2bNT3RcX=uNyt9KO1EmBJOvuA@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-5-git-send-email-amir73il@gmail.com> <CAJfpeguk+KVWkLr8ihGE0c8aDgaNHfnjf3DcuUQi1g5KZHObOw@mail.gmail.com>
 <CAOQ4uxijgqiAjKysA-HZFLa+b2nETMhq9aW8rjv=hwCq1B8tfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:45786 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933691AbeAOO4I (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 09:56:08 -0500
Received: by mail-qk0-f196.google.com with SMTP id z12so17031707qkf.12
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jan 2018 06:56:08 -0800 (PST)
In-Reply-To: <CAOQ4uxijgqiAjKysA-HZFLa+b2nETMhq9aW8rjv=hwCq1B8tfw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Jan 15, 2018 at 1:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Jan 15, 2018 at 1:33 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Jan 4, 2018 at 6:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> Until this change, we decoded upper file handles by instantiating an
>>> overlay dentry from the real upper dentry. This is sufficient to handle
>>> pure upper files, but insufficient to handle merge/impure dirs.
>>>
>>> To that end, if decoded real upper dir is connected and hashed, we
>>> lookup an overlay dentry with the same path as the real upper dir.
>>> If decoded real upper is non-dir, we instantiate a disconnected overlay
>>> dentry as before this change.
>>>
>>> Because ovl_fh_to_dentry() returns connected overlay dir dentries,
>>> exportfs never need to call get_parent() and get_name() to reconnect an
>>> upper overlay dir. Because connectable non-dir file handles are not
>>> supported, exportfs will not be able to use fh_to_parent() and get_name()
>>> methods to reconnect a disconnected non-dir to its parent. Therefore, the
>>> methods get_parent() and get_name() are implemented just to print out a
>>> sanity warning and the method fh_to_parent() is implemented to warn the
>>> user that using the 'subtree_check' exportfs option is not supported.
>>>
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
>>>  fs/overlayfs/export.c | 172 +++++++++++++++++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 171 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
>>> index 5c72784a0b4d..48ae02f3acb8 100644
>>> --- a/fs/overlayfs/export.c
>>> +++ b/fs/overlayfs/export.c
>>> @@ -130,6 +130,145 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
>>>         return dentry;
>>>  }
>>>
>>> +/*
>>> + * Lookup a child overlay dentry whose real dentry is @real.
>>> + * If @is_upper is true then we lookup a child overlay dentry with the same
>>> + * name as the real dentry. Otherwise, we need to consult index for lookup.
>>> + */
>>> +static struct dentry *ovl_lookup_real_one(struct dentry *parent,
>>> +                                         struct dentry *real, bool is_upper)
>>> +{
>>> +       struct dentry *this;
>>> +       struct qstr *name = &real->d_name;
>>> +       int err;
>>> +
>>> +       /* TODO: use index when looking up by lower real dentry */
>>> +       if (!is_upper)
>>> +               return ERR_PTR(-EACCES);
>>> +
>>> +       /* Lookup overlay dentry by real name */
>>> +       this = lookup_one_len_unlocked(name->name, parent, name->len);
>>> +       err = PTR_ERR(this);
>>> +       if (IS_ERR(this)) {
>>> +               goto fail;
>>> +       } else if (!this || !this->d_inode) {
>>> +               dput(this);
>>> +               err = -ENOENT;
>>> +               goto fail;
>>> +       } else if (ovl_dentry_upper(this) != real) {
>>> +               dput(this);
>>> +               err = -ESTALE;
>>> +               goto fail;
>>> +       }
>>> +
>>> +       return this;
>>> +
>>> +fail:
>>> +       pr_warn_ratelimited("overlayfs: failed to lookup one by real (%pd2, is_upper=%d, parent=%pd2, err=%i)\n",
>>> +                           real, is_upper, parent, err);
>>> +       return ERR_PTR(err);
>>> +}
>>> +
>>> +/*
>>> + * Lookup an overlay dentry whose real dentry is @real.
>>> + * If @is_upper is true then we lookup an overlay dentry with the same path
>>> + * as the real dentry. Otherwise, we need to consult index for lookup.
>>> + */
>>> +static struct dentry *ovl_lookup_real(struct super_block *sb,
>>> +                                     struct dentry *real, bool is_upper)
>>> +{
>>> +       struct dentry *connected;
>>> +       int err = 0;
>>> +
>>> +       /* TODO: use index when looking up by lower real dentry */
>>> +       if (!is_upper)
>>> +               return ERR_PTR(-EACCES);
>>> +
>>> +       connected = dget(sb->s_root);
>>> +       while (!err) {
>>> +               struct dentry *next, *this;
>>> +               struct dentry *parent = NULL;
>>> +               struct dentry *real_connected = ovl_dentry_upper(connected);
>>> +
>>> +               if (real_connected == real)
>>> +                       break;
>>> +
>>> +               next = dget(real);
>>> +               /* find the topmost dentry not yet connected */
>>> +               for (;;) {
>>> +                       parent = dget_parent(next);
>>> +
>>> +                       if (real_connected == parent)
>>> +                               break;
>>> +
>>> +                       /*
>>> +                        * If real file has been moved out of the layer root
>>> +                        * directory, we will eventully hit the real fs root.
>>> +                        */
>>> +                       if (parent == next) {
>>> +                               err = -EXDEV;
>>> +                               break;
>>> +                       }
>>
>> This seems to assume no cross directory renames of directories in the
>> ancestry of "real", but AFAICS nothing prevents that.
>
> Do you mean online modification of underlying fs? or rename in overlay?

Rename in overlay.

> For online modification fo underlying fs, I don't a reason to make it work.
> -ESTALE would be a perfectly valid result in that case.

Sure.

>>
>> Also why not use the inode cache to find already connected dirs?
>> Seems more efficient, than always going up to the root and going down
>> from there.
>
> See patch [14/17] ovl: lookup connected ancestor of dir in inode cache
> Sorry for ordering patches like this, it was more convenient to implement
> the cold cache algorithm and then add hot cache into the mix.

Okay.

>>
>> So, a working algorithm would be going up to the first connected
>> parent or root, lock parent, lookup name and restart.  Not guaranteed
>> to finish, since not protected against always racing with renames.
>> Can we take s_vfs_rename_sem on ovl to prevent that?
>>
>
> Sounds like a simple and good enough solution.
> Do we really need the locking of parent and restart connect if
> we take s_vfs_rename_sem around ovl_lookup_real()?

No, but s_vfs_rename_sem is a really heavyweight solution, we should
do better than that for decoding a file handle.

And we probably don't need anything else, since rename on ancestor
means renamed dir is connected, and hopefully not evicted from the
cache until we repeat the walk up.

So need to lock parent, lookup ovl dentry, verify we got the same
upper, if not retry icache lookup.

Not sure we need to worry about that "hopefully".  Hopefully not.

Thanks,
Miklos
