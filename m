From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 08/20] ovl: lookup index entry for non-dir
Date: Thu, 8 Jun 2017 17:17:45 +0200
Message-ID: <CAJfpegvbExTESQQTF0rkV7oTX2R-HxGuk=EJ6i3qLMYr56Kd4A@mail.gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
 <1496821884-5178-9-git-send-email-amir73il@gmail.com> <CAJfpegsDv__Er79=m824pioYXnVeFP3ZCnDEvz0Ync5KnUSpwQ@mail.gmail.com>
 <CAOQ4uxieGBvCFFsSaL0X776PBnNqt=uOHO8E5cbTWUrAeRJwzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:32805 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751509AbdFHPRr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Jun 2017 11:17:47 -0400
Received: by mail-ot0-f196.google.com with SMTP id k4so3770808otd.0
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Jun 2017 08:17:47 -0700 (PDT)
In-Reply-To: <CAOQ4uxieGBvCFFsSaL0X776PBnNqt=uOHO8E5cbTWUrAeRJwzg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Jun 8, 2017 at 4:48 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Jun 8, 2017 at 3:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Jun 7, 2017 at 9:51 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> When inodes index feature is enabled, lookup in indexdir for the index
>>> entry of lower real inode or copy up origin inode. The index entry name
>>> is the hex representation of the lower inode file handle.
>>>
>>> If the index dentry in negative, then either no lower aliases have been
>>> copied up yet, or aliases have been copied up in older kernels and are
>>> not indexed.
>>>
>>> If the index dentry for a copy up origin inode is positive, but points
>>> to an inode different than the upper inode, then either the upper inode
>>> has been copied up and not indexed or it was indexed, but since then
>>> index dir was cleared. Either way, that index cannot be used to indentify
>>> the overlay inode.
>>>
>>> If a negative index dentry is found or a positive dentry that matches the
>>> upper inode, store it in the overlay dentry to be used later. A non-upper
>>> overlay dentry may still have a positive index from copy up of another
>>> lower hardlink. This situation can be tested with the path type macros
>>> OVL_TYPE_INDEX(type) && !OVL_TYPE_UPPER(type).
>>>
>>> This is going to be used to prevent breaking hardlinks on copy up.
>>
>> Why is a negative index (or any index, for that matter) stored in the
>> overlay dentry?
>
> One of the reasons it is stored in the overlay dentry is to be able to
> test OVL_TYPE_INDEX() on the dentry, for example, in:
> "ovl: adjust overlay inode nlink for indexed inodes".

OVL_TYPE_INDEX() is just a bool.  When we do the *first* copy up of a
file with multiple links we need to update all the aliases anyway:
i.e. do the hardlink-ups, update ->upperdentry, etc.

> OVL_TYPE_INDEX() is only interested in positive index, so it may seem
> like a better idea to save memory and store the index dentry on lookup
> only if it is positive, but then OVL_TYPE_INDEX() will be wrong for lower
> aliases that became lower indexed aliases due to another alias copy up.
> This is important for reasons that are mentioned below.
>
> There may be an opportunity for a massive optimization though.
> For all practical purpose, ovl_type_indexed_lower() should always be
> false for lower with nlink == 1, so there is no reason so store the negative
> index dentry in that case.
>
>> This seems a big waste, since the index dentry will
>> be allocated for all lower files, yet never used unless copied up.
>>
>> Index is used:
>>
>>   - at lookup need to find any copied up alias
>>   - at copyup need to set up new index
>
> So it has several more subtle uses:
> - When whiteout a lower aliases, we need to count down nlink to
>   know when we can unlink the an orphan index (TODO)

If we do the link-up early (at lookup) then whiteout won't need
special casing.  The link-up would be unnecessary in this case, but
delaying it will just cause headaches.

> - Same when renaming over a lower indexed alias

And the same case here.

> - The lower hardlinks copy up on read [1] is another big user

Again, doing it on lookup will be earlier than at read, so no issue.

Thanks,
Miklos
