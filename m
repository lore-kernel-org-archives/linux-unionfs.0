From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 04/17] ovl: decode connected upper dir file handles
Date: Wed, 17 Jan 2018 23:36:36 +0200
Message-ID: <CAOQ4uxh+1_EFPLP8k2_-OhAPX74a9s3y9-kFNU56Z_EU1m7Adw@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-5-git-send-email-amir73il@gmail.com> <CAJfpeguk+KVWkLr8ihGE0c8aDgaNHfnjf3DcuUQi1g5KZHObOw@mail.gmail.com>
 <CAOQ4uxijgqiAjKysA-HZFLa+b2nETMhq9aW8rjv=hwCq1B8tfw@mail.gmail.com>
 <CAJfpegvCVX-YEMRDfKTYM2Au=2bNT3RcX=uNyt9KO1EmBJOvuA@mail.gmail.com>
 <CAOQ4uxggufAEqD2WhReTax9eyEzJQdpdb7E=+zrgcYz1CQVY=Q@mail.gmail.com>
 <CAJfpeguYA710QzE2L8aALtPUS=6mW9OcRdCUbDjgpx_B3K59Bw@mail.gmail.com> <CAOQ4uxhoR-cs=c6BfLr57X8iw5h1CzUq1YTB3s5HbBYSUSgjag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:36428 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752778AbeAQVgh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 17 Jan 2018 16:36:37 -0500
In-Reply-To: <CAOQ4uxhoR-cs=c6BfLr57X8iw5h1CzUq1YTB3s5HbBYSUSgjag@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Jan 17, 2018 at 6:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
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

[...]

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
>

[...]

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
>

OK. I finished reworking the series with these changes on top
of V3 of indexing patches and pushed the work so far to:
https://github.com/amir73il/linux/commits/ovl-nfs-export-wip

There is a new patch at the top:
ovl: retry connect of non-upper dirs on parent rename
that implements the dir cache version compare
it does not use the seqlock.

The modified patch 4/17 mostly affect patches 12/17 and 14/17,
so you may want to continue review on the modified version.

This WIP is tested with xfstests including a test with readonly
no upperdir overlay.

As far as I remember, the only thing remaining to address from V2
review comments so far, that is NOT in the WIP branch is to relax
the cases of copy up on encode.
As for the lookup in icache by fh, I prefer to defer to later time.

Let me know if I forgot anything or if you find anything else that
needs to be addressed.

Thanks,
Amir.
