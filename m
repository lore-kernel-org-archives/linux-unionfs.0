From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 04/17] ovl: decode connected upper dir file handles
Date: Wed, 17 Jan 2018 15:29:52 +0200
Message-ID: <CAOQ4uxiEO-0445o2UY_bcP9F0yZ5aZVbzcwaryGbB2gArtF8Zg@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-5-git-send-email-amir73il@gmail.com> <CAJfpeguk+KVWkLr8ihGE0c8aDgaNHfnjf3DcuUQi1g5KZHObOw@mail.gmail.com>
 <CAOQ4uxijgqiAjKysA-HZFLa+b2nETMhq9aW8rjv=hwCq1B8tfw@mail.gmail.com>
 <CAJfpegvCVX-YEMRDfKTYM2Au=2bNT3RcX=uNyt9KO1EmBJOvuA@mail.gmail.com>
 <CAOQ4uxggufAEqD2WhReTax9eyEzJQdpdb7E=+zrgcYz1CQVY=Q@mail.gmail.com> <CAOQ4uxjyWUxo0EZw4jKD6JYMjm8ftZe29QHniS4rtS4uauni1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33531 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752920AbeAQN3y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 17 Jan 2018 08:29:54 -0500
In-Reply-To: <CAOQ4uxjyWUxo0EZw4jKD6JYMjm8ftZe29QHniS4rtS4uauni1Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Jan 17, 2018 at 2:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jan 17, 2018 at 1:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Mon, Jan 15, 2018 at 4:56 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>
>> [...]
>>> >>
>>> >> So, a working algorithm would be going up to the first connected
>>> >> parent or root, lock parent, lookup name and restart.  Not guaranteed
>>> >> to finish, since not protected against always racing with renames.
>>> >> Can we take s_vfs_rename_sem on ovl to prevent that?
>>> >>
>>> >
>>> > Sounds like a simple and good enough solution.
>>> > Do we really need the locking of parent and restart connect if
>>> > we take s_vfs_rename_sem around ovl_lookup_real()?
>>>
>>> No, but s_vfs_rename_sem is a really heavyweight solution, we should
>>> do better than that for decoding a file handle.
>>>
>>> And we probably don't need anything else, since rename on ancestor
>>> means renamed dir is connected, and hopefully not evicted from the
>>> cache until we repeat the walk up.
>>>
>>> So need to lock parent, lookup ovl dentry, verify we got the same
>>> upper, if not retry icache lookup.
>>>
>>> Not sure we need to worry about that "hopefully".  Hopefully not.
>>>
>>
>> Something like this??
>>
>> This is just the raw fix to patch 4/17 without the icache lookup
>> that is added by later patches.
>>
>> I added rename_lock seqlock around backwalk to connected ancestor
>> and take_dentry_name_snapshot() for the stability of real name
>> during overlay lookup.
>>
>> I considered also storing OVL_I(d_inode(connected))->version
>> inside seqlock and comparing it to version in case lookup of child
>> failed. This could help us distinguish between overlay rename and
>> underlying rename (overlay dir version did not change) and return
>> ESTALE instead of restarting lookup in the latter case.
>> Wasn't sure if that was a good idea and what we loose if we leave it out.
>
> Well, if nothing else, it's a good idea for preventing endless loop
> due to bugs...
> adding some snippets below.
>
>>
>> I tested this code, but only with upper file handles of course
>> (xfstest generic/467).
>>
>> Please let me know what you think.
>>
>> Thanks,
>> Amir.
>>
>> ================================================================
>>
>> From 337543c3fcdf9323d3720d17ab6fc13e287bbec1 Mon Sep 17 00:00:00 2001
>> From: Amir Goldstein <amir73il@gmail.com>
>> Date: Thu, 28 Dec 2017 18:36:16 +0200
>> Subject: [PATCH v3 4/17] ovl: decode connected upper dir file handles
>>
>> Until this change, we decoded upper file handles by instantiating an
>> overlay dentry from the real upper dentry. This is sufficient to handle
>> pure upper files, but insufficient to handle merge/impure dirs.
>>
>> To that end, if decoded real upper dir is connected and hashed, we
>> lookup an overlay dentry with the same path as the real upper dir.
>> If decoded real upper is non-dir, we instantiate a disconnected overlay
>> dentry as before this change.
>>
>> Because ovl_fh_to_dentry() returns a connected overlay dir dentry,
>> exportfs never needs to call get_parent() and get_name() to reconnect an
>> upper overlay dir. Because connectable non-dir file handles are not
>> supported, exportfs will not be able to use fh_to_parent() and get_name()
>> methods to reconnect a disconnected non-dir to its parent. Therefore, the
>> methods get_parent() and get_name() are implemented just to print out a
>> sanity warning and the method fh_to_parent() is implemented to warn the
>> user that using the 'subtree_check' exportfs option is not supported.
>>
>> An alternative approach could have been to implement instantiating of
>> an overlay directory inode from origin/index and implement get_parent()
>> and get_name() by calling into underlying fs operations and them
>> instantiating the overlay parent dir.
>>
>> The reasons for not choosing the get_parent() approach were:
>> - Obtaining a disconnected overlay dir dentry would requires a
>>   delicate re-factoring of ovl_lookup() to get a dentry with overlay
>>   parent info. It was preferred to avoid doing that re-factoring unless
>>   it was proven worthy.
>> - Going down the path of disconnected dir would mean that the (non
>>   trivial) code path of d_splice_alias() could be traveled and that
>>   meant writing more tests and introduces race cases that are very hard
>>   to hit on purpose. Taking the path of connecting overlay dentry by
>>   forward lookup is therefore the safe and boring way to avoid surprises.
>>
>> The culprit of the chosen "connected overlay dentry" approach:
>> - We need to take special care to rename of ancestors while connecting
>>   the overlay dentry by real dentry path. These subtleties are usually
>>   handled by generic exportfs and VFS code.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/export.c | 215 +++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 214 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
>> index 557c29928e98..35f37a72d55e 100644
>> --- a/fs/overlayfs/export.c
>> +++ b/fs/overlayfs/export.c
>> @@ -130,6 +130,188 @@ static struct dentry *ovl_obtain_alias(struct
>> super_block *sb,
>>         return dentry;
>>  }
>>
>> +/*
>> + * Lookup a child overlay dentry whose real dentry is @real.
>> + * If @real is on upper layer, we lookup a child overlay dentry with the same
>> + * name as the real dentry. Otherwise, we need to consult index for lookup.
>> + */
>> +static struct dentry *ovl_lookup_real_one(struct dentry *parent, u64 ver,
>> +                                         struct dentry *real,
>> +                                         struct ovl_layer *layer)
>> +{
>> +       struct dentry *this;
>> +       struct name_snapshot name;
>> +       int err;
>> +
>> +       /* TODO: use index when looking up by lower real dentry */
>> +       if (layer->idx)
>> +               return ERR_PTR(-EACCES);
>> +
>> +       /*
>> +        * Lookup overlay dentry by real name. The parent mutex protects us
>> +        * from racing with overlay rename. If the overlay dentry that is
>> +        * above real has already been moved to a different parent, then this
>> +        * lookup will fail to find a child dentry whose real dentry is @real
>> +        * and we will have to restart the lookup of real path from the top.
>> +        *
>> +        * We also need to take a snapshot of real dentry name to protect us
>> +        * from racing with underlying layer rename. In this case, we don't
>> +        * care about returning ESTALE, only from referencing a free name
>> +        * pointer.
>> +        *
>> +        * TODO: try to lookup the renamed overlay dentry in inode cache by
>> +        *       real inode.
>> +        */
>> +       inode_lock_nested(d_inode(parent), I_MUTEX_PARENT);
>
> +       err = -ECHILD;
> +       if (ovl_dentry_version_get(parent) != ver)
> +               goto fail;
> +
>

Actually, the version check seem correct for connecting up lower real dir,
which is the case where I hit the endless loop (under redirected middle layers),
but it does not belong in this patch, because pure upper dirs don't have their
overlay version incremented and because for upper layer lookup
ENOENT and ESTALE *should* restart lookup from the top.
However, for lower layer lookup they shouldn't (only ECHILD above should
trigger restart from the top).

I'll sort this thing up and push a branch for test/review.

Thanks,
Amir.
