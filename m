From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 08/20] ovl: lookup index entry for non-dir
Date: Thu, 8 Jun 2017 17:48:13 +0300
Message-ID: <CAOQ4uxieGBvCFFsSaL0X776PBnNqt=uOHO8E5cbTWUrAeRJwzg@mail.gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
 <1496821884-5178-9-git-send-email-amir73il@gmail.com> <CAJfpegsDv__Er79=m824pioYXnVeFP3ZCnDEvz0Ync5KnUSpwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34882 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751473AbdFHOsO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Jun 2017 10:48:14 -0400
In-Reply-To: <CAJfpegsDv__Er79=m824pioYXnVeFP3ZCnDEvz0Ync5KnUSpwQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Jun 8, 2017 at 3:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Jun 7, 2017 at 9:51 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> When inodes index feature is enabled, lookup in indexdir for the index
>> entry of lower real inode or copy up origin inode. The index entry name
>> is the hex representation of the lower inode file handle.
>>
>> If the index dentry in negative, then either no lower aliases have been
>> copied up yet, or aliases have been copied up in older kernels and are
>> not indexed.
>>
>> If the index dentry for a copy up origin inode is positive, but points
>> to an inode different than the upper inode, then either the upper inode
>> has been copied up and not indexed or it was indexed, but since then
>> index dir was cleared. Either way, that index cannot be used to indentify
>> the overlay inode.
>>
>> If a negative index dentry is found or a positive dentry that matches the
>> upper inode, store it in the overlay dentry to be used later. A non-upper
>> overlay dentry may still have a positive index from copy up of another
>> lower hardlink. This situation can be tested with the path type macros
>> OVL_TYPE_INDEX(type) && !OVL_TYPE_UPPER(type).
>>
>> This is going to be used to prevent breaking hardlinks on copy up.
>
> Why is a negative index (or any index, for that matter) stored in the
> overlay dentry?

One of the reasons it is stored in the overlay dentry is to be able to
test OVL_TYPE_INDEX() on the dentry, for example, in:
"ovl: adjust overlay inode nlink for indexed inodes".

OVL_TYPE_INDEX() is only interested in positive index, so it may seem
like a better idea to save memory and store the index dentry on lookup
only if it is positive, but then OVL_TYPE_INDEX() will be wrong for lower
aliases that became lower indexed aliases due to another alias copy up.
This is important for reasons that are mentioned below.

There may be an opportunity for a massive optimization though.
For all practical purpose, ovl_type_indexed_lower() should always be
false for lower with nlink == 1, so there is no reason so store the negative
index dentry in that case.

> This seems a big waste, since the index dentry will
> be allocated for all lower files, yet never used unless copied up.
>
> Index is used:
>
>   - at lookup need to find any copied up alias
>   - at copyup need to set up new index

So it has several more subtle uses:
- When whiteout a lower aliases, we need to count down nlink to
  know when we can unlink the an orphan index (TODO)
- Same when renaming over a lower indexed alias
- The lower hardlinks copy up on read [1] is another big user

>
> In both cases we can just do a fresh lookup in the index dir with
> locks held (which is a good idea anyway).
>
> Something related: should upperdentry of aliases be hardlinked to the
> index on lookup and copy-up?  Or should the "hardlink-up" be deferred
> until rename?  I think updating as soon as possible is the simpler of
> the two.
>

Agree that updating "as soon as possible" is simpler.
I went even further with "as soon as possible" with lower hardlinks copy
up on read [1]. There is a subtle inconsistency between ovl_inode_real()
and ovl_{dentry,path}_real() of those lower indexed aliases that is hard
to deal with if we are not hardlinking up on the first access.

But there is another reason we cannot defer indexing until rename -
We need to be able to decode a non-dir file handle if its parent was
renamed, so the index has to be there even if the the upper file itself
was not renamed.

I guess that means we will also need to index directories on copy up.
Too bad. I though it was enough to index directories on rename.

Amir.

[1] https://github.com/amir73il/linux/commits/ovl-hardlinks-rocopyup
