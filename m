From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs: allowing for changes to lowerdir
Date: Thu, 9 Mar 2017 14:12:03 +0100
Message-ID: <CAJfpegs6trH1cJ7AB=898+KAEuTi0ry29rocxMovEMwHcGkrmQ@mail.gmail.com>
References: <CA+ZH+jFBAaRi6VPmf3PBdDZQQMOaT6WUByATqaw1QL5M9+-dxg@mail.gmail.com>
 <CAOQ4uxiBmFdcueorKV7zwPLCDq4DE+H8x=8H1f7+3v3zysW9qA@mail.gmail.com>
 <CAJfpegtLZXJLqaOmiFJLrG-P0cMRAAdNLu4rdRJVr5axRPHMWg@mail.gmail.com> <CAOQ4uxgBzyEU5iqX5kYKYUZqS09UiETN4Syxh_-rocAKQwNvOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f177.google.com ([74.125.82.177]:33863 "EHLO
        mail-ot0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754779AbdCINMF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Mar 2017 08:12:05 -0500
Received: by mail-ot0-f177.google.com with SMTP id o24so55622137otb.1
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Mar 2017 05:12:04 -0800 (PST)
In-Reply-To: <CAOQ4uxgBzyEU5iqX5kYKYUZqS09UiETN4Syxh_-rocAKQwNvOQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josh England <jjengla@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Mar 9, 2017 at 12:22 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Mar 9, 2017 at 12:37 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Tue, Feb 14, 2017 at 3:01 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Mon, Feb 13, 2017 at 11:41 PM, Josh England <jjengla@gmail.com> wrote:
>>>> So here's the use case:  lowerdir is an NFS mounted root filesystem
>>>> (shared by a bunch of nodes).  upperdir is a tmpfs RAM disk to allow
>>>> for writes to happen.  This works great with the caveat being I cannot
>>>> make 'live' changes to the root filesystem, which poses the problem.
>>>> Any access to a changed file causes a 'Stale file handle' error.
>>>>
>>>> With some experimenting, I've discovered that remounting the overlay
>>>> filesystem (mount -o remount / /)  registers any changes that have
>>>> been made to the lower NFS filesystem.  In addition, dumping cache
>>>> (via /proc/sys/vm/drop_caches) also makes the stale file handle errors
>>>> go away and reads pass through to the lower dir and correctly show
>>>> changes.
>>>>
>>>> I'd like to make this use case feasible by allowing changes to the NFS
>>>> lowerdir to work more or less transparently.  It seems like if the
>>>> overlay did not do any caching at all, all reads would fall through to
>>>> either the upperdir ram disk or the NFS lower, which is precisely what
>>>> I want.
>>>>
>>>> So, let me pose this somewhat naive question:  Would it be possible to
>>>> simply disable any cacheing performed by the overlay to force all
>>>> reads to go to either the tmpfs upper or the (VFS-cached) NFS lower?
>>>> Would this be enough to accomplish my goal of being able to change the
>>>> lowerdir of an active overlayfs?
>>>>
>>>
>>> There is no need to disable caching. There is already a mechanism
>>> in place in VFS to revalidate inode cache entries.
>>> NFS implements d_revalidate() and overlayfs implements d_revalidate()
>>> by calling into the lower fs d_revalidate().
>>>
>>> However overlayfs intentionally errors when lower entry has been modified.
>>> (see: 7c03b5d ovl: allow distributed fs as lower layer)
>>>
>>> You can try this (untested) patch to revert this behavior, just to see if it
>>> works for your use case, but it won't change this fact
>>> from Documentation/filesystems/overlayfs.txt:
>>> " Changes to the underlying filesystems while part of a mounted overlay
>>> filesystem are not allowed.  If the underlying filesystem is changed,
>>> the behavior of the overlay is undefined, though it will not result in
>>> a crash or deadlock."
>>
>> Best way to keep things simple is to only add functionality when
>> someone actually needs it (and can test it).  This has been the design
>> policy in overlayfs and it worked wonderfully.
>>
>> So we could probably fix the undefined behavior in the above case to
>> some extent.
>>
>>>
>>> Specifically, renaming directories and files in lower that were already
>>> copied up is going to have a weird outcome.
>>>
>>> Also, the situation with changing files in lower remote fs could be worse
>>> than changing files on lower local fs, simply because right now, this
>>> use case is not tested (i.e. it results in ESTALE).
>>>
>>> I believe that fixing this use case, if at all possible, would require quite
>>> a bit of work, a lot of documentation (about expected behavior) and
>>> even more testing.
>>
>> Well, your patch seems to be safe:  if remote fs says something
>> changed, throw away node and subtree on the overlay level.
>>
>> We could introduce the same thing for local fs.  Just need to verify
>> in .d_revalidate() that underlying dentry's parent and name matches
>> overlay dentry's parent and name.  It's an overhead, and makes no
>> sense in the case when we know the lower layers won't change, so it
>> may be best to keep this check optional.
>>
>> Note, that overlay would still return ESTALE if the change on the
>> lower layer happens on a dentry already looked up (e.g. cwd, open
>> file, race of lookup with rename on underlying layer).  Same as NFS.
>>
>
> Naturally.
>
> Could you explain what was the reason for special casing (ret == 0)
> in ovl_dentry_revalidate()?

I think my reasoning was: if lower dentry is invalid, it means lower
was changed; this is against the rules (as per documentation) so
return error.

Thanks,
Miklos
