From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 04/17] ovl: decode connected upper dir file handles
Date: Thu, 18 Jan 2018 12:28:05 +0200
Message-ID: <CAOQ4uxhShUXkNaN5Drxoet+bfHRzUiDPRPO5DAvdwq5L9-O+nA@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-5-git-send-email-amir73il@gmail.com> <CAJfpeguk+KVWkLr8ihGE0c8aDgaNHfnjf3DcuUQi1g5KZHObOw@mail.gmail.com>
 <CAOQ4uxijgqiAjKysA-HZFLa+b2nETMhq9aW8rjv=hwCq1B8tfw@mail.gmail.com>
 <CAJfpegvCVX-YEMRDfKTYM2Au=2bNT3RcX=uNyt9KO1EmBJOvuA@mail.gmail.com>
 <CAOQ4uxggufAEqD2WhReTax9eyEzJQdpdb7E=+zrgcYz1CQVY=Q@mail.gmail.com>
 <CAJfpeguYA710QzE2L8aALtPUS=6mW9OcRdCUbDjgpx_B3K59Bw@mail.gmail.com>
 <CAOQ4uxhoR-cs=c6BfLr57X8iw5h1CzUq1YTB3s5HbBYSUSgjag@mail.gmail.com>
 <CAJfpegsJURzWdC0a3AiEMv_BnCO1rdXqCr1-Y0HtrG3vKxJd5g@mail.gmail.com>
 <CAOQ4uxi3V=s5t32DbNSqYum7EXjJTSqjE3jrJKLV9a0R5m4-QQ@mail.gmail.com> <CAJfpegvkJa+JdTjV9urMG7JAw_Vi1fp6VP7FwKRic-iUqn9HzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegvkJa+JdTjV9urMG7JAw_Vi1fp6VP7FwKRic-iUqn9HzA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jan 18, 2018 at 11:12 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jan 18, 2018 at 9:47 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, Jan 18, 2018 at 10:22 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Wed, Jan 17, 2018 at 5:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> On Wed, Jan 17, 2018 at 5:42 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>>> On Wed, Jan 17, 2018 at 12:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>>> On Mon, Jan 15, 2018 at 4:56 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>>>>>
>>>>>> [...]
>>>>>>> >>
>>>>>>> >> So, a working algorithm would be going up to the first connected
>>>>>>> >> parent or root, lock parent, lookup name and restart.  Not guaranteed
>>>>>>> >> to finish, since not protected against always racing with renames.
>>>>>>> >> Can we take s_vfs_rename_sem on ovl to prevent that?
>>>>>>> >>
>>>>>>> >
>>>>>>> > Sounds like a simple and good enough solution.
>>>>>>> > Do we really need the locking of parent and restart connect if
>>>>>>> > we take s_vfs_rename_sem around ovl_lookup_real()?
>>>>>>>
>>>>>>> No, but s_vfs_rename_sem is a really heavyweight solution, we should
>>>>>>> do better than that for decoding a file handle.
>>>>>>>
>>>>>>> And we probably don't need anything else, since rename on ancestor
>>>>>>> means renamed dir is connected, and hopefully not evicted from the
>>>>>>> cache until we repeat the walk up.
>>>>>>>
>>>>>>> So need to lock parent, lookup ovl dentry, verify we got the same
>>>>>>> upper, if not retry icache lookup.
>>>>>>>
>>>>>>> Not sure we need to worry about that "hopefully".  Hopefully not.
>>>>>>>
>>>>>>
>>>>>> Something like this??
>>>>>>
>>>>>> This is just the raw fix to patch 4/17 without the icache lookup
>>>>>> that is added by later patches.
>>>>>>
>>>>>> I added rename_lock seqlock around backwalk to connected ancestor
>>>>>> and take_dentry_name_snapshot() for the stability of real name
>>>>>> during overlay lookup.
>>>>>>
>>>>>> I considered also storing OVL_I(d_inode(connected))->version
>>>>>> inside seqlock and comparing it to version in case lookup of child
>>>>>> failed. This could help us distinguish between overlay rename and
>>>>>> underlying rename (overlay dir version did not change) and return
>>>>>> ESTALE instead of restarting lookup in the latter case.
>>>>>> Wasn't sure if that was a good idea and what we loose if we leave it out.
>>>>>>
>>>>>> I tested this code, but only with upper file handles of course
>>>>>> (xfstest generic/467).
>>>>>>
>>>>>> Please let me know what you think.
>>>>>>
>>>>>> Thanks,
>>>>>> Amir.
>>>>>>
>>>>>> ================================================================
>>>>>>
>>>>>> From 337543c3fcdf9323d3720d17ab6fc13e287bbec1 Mon Sep 17 00:00:00 2001
>>>>>> From: Amir Goldstein <amir73il@gmail.com>
>>>>>> Date: Thu, 28 Dec 2017 18:36:16 +0200
>>>>>> Subject: [PATCH v3 4/17] ovl: decode connected upper dir file handles
>>>>>>
>>>>>> Until this change, we decoded upper file handles by instantiating an
>>>>>> overlay dentry from the real upper dentry. This is sufficient to handle
>>>>>> pure upper files, but insufficient to handle merge/impure dirs.
>>>>>>
>>>>>> To that end, if decoded real upper dir is connected and hashed, we
>>>>>> lookup an overlay dentry with the same path as the real upper dir.
>>>>>> If decoded real upper is non-dir, we instantiate a disconnected overlay
>>>>>> dentry as before this change.
>>>>>>
>>>>>> Because ovl_fh_to_dentry() returns a connected overlay dir dentry,
>>>>>> exportfs never needs to call get_parent() and get_name() to reconnect an
>>>>>> upper overlay dir. Because connectable non-dir file handles are not
>>>>>> supported, exportfs will not be able to use fh_to_parent() and get_name()
>>>>>> methods to reconnect a disconnected non-dir to its parent. Therefore, the
>>>>>> methods get_parent() and get_name() are implemented just to print out a
>>>>>> sanity warning and the method fh_to_parent() is implemented to warn the
>>>>>> user that using the 'subtree_check' exportfs option is not supported.
>>>>>>
>>>>>> An alternative approach could have been to implement instantiating of
>>>>>> an overlay directory inode from origin/index and implement get_parent()
>>>>>> and get_name() by calling into underlying fs operations and them
>>>>>> instantiating the overlay parent dir.
>>>>>>
>>>>>> The reasons for not choosing the get_parent() approach were:
>>>>>> - Obtaining a disconnected overlay dir dentry would requires a
>>>>>>   delicate re-factoring of ovl_lookup() to get a dentry with overlay
>>>>>>   parent info. It was preferred to avoid doing that re-factoring unless
>>>>>>   it was proven worthy.
>>>>>> - Going down the path of disconnected dir would mean that the (non
>>>>>>   trivial) code path of d_splice_alias() could be traveled and that
>>>>>>   meant writing more tests and introduces race cases that are very hard
>>>>>>   to hit on purpose. Taking the path of connecting overlay dentry by
>>>>>>   forward lookup is therefore the safe and boring way to avoid surprises.
>>>>>>
>>>>>> The culprit of the chosen "connected overlay dentry" approach:
>>>>>> - We need to take special care to rename of ancestors while connecting
>>>>>>   the overlay dentry by real dentry path. These subtleties are usually
>>>>>>   handled by generic exportfs and VFS code.
>>>>>>
>>>>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>>>>> ---
>> [...]
>>>>>> +/*
>>>>>> + * Lookup an overlay dentry whose real dentry is @real.
>>>>>> + * If @real is on upper layer, we lookup a child overlay dentry with the same
>>>>>> + * path the real dentry. Otherwise, we need to consult index for lookup.
>>>>>> + */
>>>>>> +static struct dentry *ovl_lookup_real(struct super_block *sb,
>>>>>> +                                     struct dentry *real,
>>>>>> +                                     struct ovl_layer *layer)
>>>>>> +{
>>>>>> +       struct dentry *connected;
>>>>>> +       unsigned int seq;
>>>>>> +       int err = 0;
>>>>>> +
>>>>>> +       /* TODO: use index when looking up by lower real dentry */
>>>>>> +       if (layer->idx)
>>>>>> +               return ERR_PTR(-EACCES);
>>>>>> +
>>>>>> +       connected = dget(sb->s_root);
>>>>>> +       while (!err) {
>>>>>> +               struct dentry *next, *this;
>>>>>> +               struct dentry *parent = NULL;
>>>>>> +               struct dentry *real_connected = layer->mnt->mnt_root;
>>>>>> +
>>>>>> +               if (real_connected == real)
>>>>>> +                       break;
>>>>>
>>>>> This loop will never finish, since real_connected is mnt_root now.
>>>>> Would be nice if there was a guaranteed way to finish this without
>>>>> icache lookup, but I don't see how.
>>>>>
>>>>
>>>> That's a bug.
>>>> The correct code is:
>>>>
>>>> struct dentry *real_connected = ovl_dentry_upper(connected);
>>>
>>> No, that's still broken, because if something gets renamed below
>>> "connected", we'll fall off root.  So need to stop at real_connected
>>> AND at root of overlay.
>>>
>>
>> Right. Will fix that.

Fix pushed to ovl-nfs-export-wip branch.

>>
>>>>
>>>>
>>>>>> +
>>>>>> +               /*
>>>>>> +                * Find the topmost dentry not yet connected. Taking rename_lock
>>>>>> +                * so at least we don't race with rename when walking back to
>>>>>> +                * 'real_connected'.
>>>>>> +                */
>>>>>> +               seq = read_seqbegin(&rename_lock);
>>>>>
>>>>> I don't see what we gain with this.
>>>>>
>>>>
>>>> I can't say that I do see it, but perhaps there is something yet
>>>> to be gained by adding this later for lower layers lookup.
>>>> Perhaps when looking on lower real layer, we can store the
>>>> overlay dir cache version of 'connected' (connected in this case
>>>> may be an indexed merge dir).
>>>> After we take 'connected' dir mutex, we cannot check that
>>>> real parent hasn't changes as an indication to no overlay rename
>>>> because overlay rename happens on upper, but we can compare
>>>> the dir cache version of 'connected' dir to the version we stored
>>>> under rename_lock.
>>>> Then we can tell if lower lookup has failed because of some
>>>> permanent error (e.g. middle layer redirect) or because of an
>>>> indexed rename, so we need to restart.
>>>> Maybe that gains us something?
>>>
>>> Sorry, couldn't follow that.
>>>
>>> I don't see need for additional locking apart from the one in
>>> ovl_lookup_by_real_one().  Because the only race remaining is eviction
>>> of overlay inode(s) from the icache, and no locking is going to
>>> prevent that.
>>>
>>
>> Right. No need for the rename seqlock.
>> The reason we need the cache version check for connecting by
>> lower real is to end the retry loop in case there is a permanent
>> decode error due to middle layer redirects and we did not mitigate
>> it with copy up on encode.
>
> Please try to explain, because I don't get what's the issue is here.
>

That's probably because there is no issue.
Please disregard.
I removed this patch from ovl-nfs-export-wip.

>>
>> BTW, with read-only lower-only overlay mount we cannot mitigate
>> middle layer redirect with copy up, so we need to either fail encode
>> or fail decode. Failing decode is better, because it still allows nfsd
>> to work when dentry remains in cache.
>
> OTOH, getting an error reliably can be better than getting an them
> intermittently, because testing will reveal the first case better.
> So I'd suggest we error out on mount if no upper and redirects
> enabled.

That sounds much easier.
But no need to error out, just need to fallback to nfs_export=off
and print a warning like we do with no xattr/fh support.
I will do that.

Thanks,
Amir.
