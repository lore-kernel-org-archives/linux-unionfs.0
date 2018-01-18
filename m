From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 04/17] ovl: decode connected upper dir file handles
Date: Thu, 18 Jan 2018 09:22:46 +0100
Message-ID: <CAJfpegsJURzWdC0a3AiEMv_BnCO1rdXqCr1-Y0HtrG3vKxJd5g@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-5-git-send-email-amir73il@gmail.com> <CAJfpeguk+KVWkLr8ihGE0c8aDgaNHfnjf3DcuUQi1g5KZHObOw@mail.gmail.com>
 <CAOQ4uxijgqiAjKysA-HZFLa+b2nETMhq9aW8rjv=hwCq1B8tfw@mail.gmail.com>
 <CAJfpegvCVX-YEMRDfKTYM2Au=2bNT3RcX=uNyt9KO1EmBJOvuA@mail.gmail.com>
 <CAOQ4uxggufAEqD2WhReTax9eyEzJQdpdb7E=+zrgcYz1CQVY=Q@mail.gmail.com>
 <CAJfpeguYA710QzE2L8aALtPUS=6mW9OcRdCUbDjgpx_B3K59Bw@mail.gmail.com> <CAOQ4uxhoR-cs=c6BfLr57X8iw5h1CzUq1YTB3s5HbBYSUSgjag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:42059 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752306AbeARIWs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jan 2018 03:22:48 -0500
Received: by mail-qt0-f182.google.com with SMTP id c2so28243612qtn.9
        for <linux-unionfs@vger.kernel.org>; Thu, 18 Jan 2018 00:22:48 -0800 (PST)
In-Reply-To: <CAOQ4uxhoR-cs=c6BfLr57X8iw5h1CzUq1YTB3s5HbBYSUSgjag@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Jan 17, 2018 at 5:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jan 17, 2018 at 5:42 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Jan 17, 2018 at 12:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Mon, Jan 15, 2018 at 4:56 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>>
>>> [...]
>>>> >>
>>>> >> So, a working algorithm would be going up to the first connected
>>>> >> parent or root, lock parent, lookup name and restart.  Not guaranteed
>>>> >> to finish, since not protected against always racing with renames.
>>>> >> Can we take s_vfs_rename_sem on ovl to prevent that?
>>>> >>
>>>> >
>>>> > Sounds like a simple and good enough solution.
>>>> > Do we really need the locking of parent and restart connect if
>>>> > we take s_vfs_rename_sem around ovl_lookup_real()?
>>>>
>>>> No, but s_vfs_rename_sem is a really heavyweight solution, we should
>>>> do better than that for decoding a file handle.
>>>>
>>>> And we probably don't need anything else, since rename on ancestor
>>>> means renamed dir is connected, and hopefully not evicted from the
>>>> cache until we repeat the walk up.
>>>>
>>>> So need to lock parent, lookup ovl dentry, verify we got the same
>>>> upper, if not retry icache lookup.
>>>>
>>>> Not sure we need to worry about that "hopefully".  Hopefully not.
>>>>
>>>
>>> Something like this??
>>>
>>> This is just the raw fix to patch 4/17 without the icache lookup
>>> that is added by later patches.
>>>
>>> I added rename_lock seqlock around backwalk to connected ancestor
>>> and take_dentry_name_snapshot() for the stability of real name
>>> during overlay lookup.
>>>
>>> I considered also storing OVL_I(d_inode(connected))->version
>>> inside seqlock and comparing it to version in case lookup of child
>>> failed. This could help us distinguish between overlay rename and
>>> underlying rename (overlay dir version did not change) and return
>>> ESTALE instead of restarting lookup in the latter case.
>>> Wasn't sure if that was a good idea and what we loose if we leave it out.
>>>
>>> I tested this code, but only with upper file handles of course
>>> (xfstest generic/467).
>>>
>>> Please let me know what you think.
>>>
>>> Thanks,
>>> Amir.
>>>
>>> ================================================================
>>>
>>> From 337543c3fcdf9323d3720d17ab6fc13e287bbec1 Mon Sep 17 00:00:00 2001
>>> From: Amir Goldstein <amir73il@gmail.com>
>>> Date: Thu, 28 Dec 2017 18:36:16 +0200
>>> Subject: [PATCH v3 4/17] ovl: decode connected upper dir file handles
>>>
>>> Until this change, we decoded upper file handles by instantiating an
>>> overlay dentry from the real upper dentry. This is sufficient to handle
>>> pure upper files, but insufficient to handle merge/impure dirs.
>>>
>>> To that end, if decoded real upper dir is connected and hashed, we
>>> lookup an overlay dentry with the same path as the real upper dir.
>>> If decoded real upper is non-dir, we instantiate a disconnected overlay
>>> dentry as before this change.
>>>
>>> Because ovl_fh_to_dentry() returns a connected overlay dir dentry,
>>> exportfs never needs to call get_parent() and get_name() to reconnect an
>>> upper overlay dir. Because connectable non-dir file handles are not
>>> supported, exportfs will not be able to use fh_to_parent() and get_name()
>>> methods to reconnect a disconnected non-dir to its parent. Therefore, the
>>> methods get_parent() and get_name() are implemented just to print out a
>>> sanity warning and the method fh_to_parent() is implemented to warn the
>>> user that using the 'subtree_check' exportfs option is not supported.
>>>
>>> An alternative approach could have been to implement instantiating of
>>> an overlay directory inode from origin/index and implement get_parent()
>>> and get_name() by calling into underlying fs operations and them
>>> instantiating the overlay parent dir.
>>>
>>> The reasons for not choosing the get_parent() approach were:
>>> - Obtaining a disconnected overlay dir dentry would requires a
>>>   delicate re-factoring of ovl_lookup() to get a dentry with overlay
>>>   parent info. It was preferred to avoid doing that re-factoring unless
>>>   it was proven worthy.
>>> - Going down the path of disconnected dir would mean that the (non
>>>   trivial) code path of d_splice_alias() could be traveled and that
>>>   meant writing more tests and introduces race cases that are very hard
>>>   to hit on purpose. Taking the path of connecting overlay dentry by
>>>   forward lookup is therefore the safe and boring way to avoid surprises.
>>>
>>> The culprit of the chosen "connected overlay dentry" approach:
>>> - We need to take special care to rename of ancestors while connecting
>>>   the overlay dentry by real dentry path. These subtleties are usually
>>>   handled by generic exportfs and VFS code.
>>>
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
>>>  fs/overlayfs/export.c | 215 +++++++++++++++++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 214 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
>>> index 557c29928e98..35f37a72d55e 100644
>>> --- a/fs/overlayfs/export.c
>>> +++ b/fs/overlayfs/export.c
>>> @@ -130,6 +130,188 @@ static struct dentry *ovl_obtain_alias(struct
>>> super_block *sb,
>>>         return dentry;
>>>  }
>>>
>>> +/*
>>> + * Lookup a child overlay dentry whose real dentry is @real.
>>> + * If @real is on upper layer, we lookup a child overlay dentry with the same
>>> + * name as the real dentry. Otherwise, we need to consult index for lookup.
>>> + */
>>> +static struct dentry *ovl_lookup_real_one(struct dentry *parent,
>>> +                                         struct dentry *real,
>>> +                                         struct ovl_layer *layer)
>>> +{
>>> +       struct dentry *this;
>>> +       struct name_snapshot name;
>>> +       int err;
>>> +
>>> +       /* TODO: use index when looking up by lower real dentry */
>>> +       if (layer->idx)
>>> +               return ERR_PTR(-EACCES);
>>> +
>>> +       /*
>>> +        * Lookup overlay dentry by real name. The parent mutex protects us
>>> +        * from racing with overlay rename. If the overlay dentry that is
>>> +        * above real has already been moved to a different parent, then this
>>> +        * lookup will fail to find a child dentry whose real dentry is @real
>>> +        * and we will have to restart the lookup of real path from the top.
>>> +        *
>>> +        * We also need to take a snapshot of real dentry name to protect us
>>> +        * from racing with underlying layer rename. In this case, we don't
>>> +        * care about returning ESTALE, only from referencing a free name
>>> +        * pointer.
>>> +        *
>>> +        * TODO: try to lookup the renamed overlay dentry in inode cache by
>>> +        *       real inode.
>>> +        */
>>> +       inode_lock_nested(d_inode(parent), I_MUTEX_PARENT);
>>> +       take_dentry_name_snapshot(&name, real);
>>
>> No need to snapshot, just check if parent hasn't changed after
>> locking.  If parent is same, then name is guaranteed to be stable.
>>
>
> I don't understand.
> We are not holding a lock on real parent, only on overlay parent.
> What makes the real name stable?
> The snapshot is not to protect from racing with overlay rename.
> The snapshot is for protecting from race with real rename, just to
> make sure we don't dereference a stale name pointer.

Ah,okay.

>
>> This also means, that only ESTALE is possible after this.   And ESTALE
>> is fatal, no need to retry after that.
>
> OK. I will return ECHILD for parent that has changed
> and will restart only on ECHILD.
>
>>
>>> +       this = lookup_one_len(name.name, parent, strlen(name.name));
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
>>> +out:
>>> +       release_dentry_name_snapshot(&name);
>>> +       inode_unlock(d_inode(parent));
>>> +       return this;
>>> +
>>> +fail:
>>> +       pr_warn_ratelimited("overlayfs: failed to lookup one by real
>>> (%pd2, layer=%d, parent=%pd2, err=%i)\n",
>>> +                           real, layer->idx, parent, err);
>>> +       this = ERR_PTR(err);
>>> +       goto out;
>>> +}
>>> +
>>> +/*
>>> + * Lookup an overlay dentry whose real dentry is @real.
>>> + * If @real is on upper layer, we lookup a child overlay dentry with the same
>>> + * path the real dentry. Otherwise, we need to consult index for lookup.
>>> + */
>>> +static struct dentry *ovl_lookup_real(struct super_block *sb,
>>> +                                     struct dentry *real,
>>> +                                     struct ovl_layer *layer)
>>> +{
>>> +       struct dentry *connected;
>>> +       unsigned int seq;
>>> +       int err = 0;
>>> +
>>> +       /* TODO: use index when looking up by lower real dentry */
>>> +       if (layer->idx)
>>> +               return ERR_PTR(-EACCES);
>>> +
>>> +       connected = dget(sb->s_root);
>>> +       while (!err) {
>>> +               struct dentry *next, *this;
>>> +               struct dentry *parent = NULL;
>>> +               struct dentry *real_connected = layer->mnt->mnt_root;
>>> +
>>> +               if (real_connected == real)
>>> +                       break;
>>
>> This loop will never finish, since real_connected is mnt_root now.
>> Would be nice if there was a guaranteed way to finish this without
>> icache lookup, but I don't see how.
>>
>
> That's a bug.
> The correct code is:
>
> struct dentry *real_connected = ovl_dentry_upper(connected);

No, that's still broken, because if something gets renamed below
"connected", we'll fall off root.  So need to stop at real_connected
AND at root of overlay.

>
>
>>> +
>>> +               /*
>>> +                * Find the topmost dentry not yet connected. Taking rename_lock
>>> +                * so at least we don't race with rename when walking back to
>>> +                * 'real_connected'.
>>> +                */
>>> +               seq = read_seqbegin(&rename_lock);
>>
>> I don't see what we gain with this.
>>
>
> I can't say that I do see it, but perhaps there is something yet
> to be gained by adding this later for lower layers lookup.
> Perhaps when looking on lower real layer, we can store the
> overlay dir cache version of 'connected' (connected in this case
> may be an indexed merge dir).
> After we take 'connected' dir mutex, we cannot check that
> real parent hasn't changes as an indication to no overlay rename
> because overlay rename happens on upper, but we can compare
> the dir cache version of 'connected' dir to the version we stored
> under rename_lock.
> Then we can tell if lower lookup has failed because of some
> permanent error (e.g. middle layer redirect) or because of an
> indexed rename, so we need to restart.
> Maybe that gains us something?

Sorry, couldn't follow that.

I don't see need for additional locking apart from the one in
ovl_lookup_by_real_one().  Because the only race remaining is eviction
of overlay inode(s) from the icache, and no locking is going to
prevent that.

To get a fully race-free version, we'd need to abandon returning a
connected dir from decode_fh().

Thanks,
Miklos
