From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 08/20] ovl: lookup index entry for non-dir
Date: Thu, 8 Jun 2017 19:09:30 +0300
Message-ID: <CAOQ4uxhHPa-Og__irD8MTCvy+vkWDibi-sw7wuekVnYx5Jh+Yg@mail.gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
 <1496821884-5178-9-git-send-email-amir73il@gmail.com> <CAJfpegsDv__Er79=m824pioYXnVeFP3ZCnDEvz0Ync5KnUSpwQ@mail.gmail.com>
 <CAOQ4uxieGBvCFFsSaL0X776PBnNqt=uOHO8E5cbTWUrAeRJwzg@mail.gmail.com> <CAJfpegvbExTESQQTF0rkV7oTX2R-HxGuk=EJ6i3qLMYr56Kd4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34652 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbdFHQJc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Jun 2017 12:09:32 -0400
In-Reply-To: <CAJfpegvbExTESQQTF0rkV7oTX2R-HxGuk=EJ6i3qLMYr56Kd4A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Jun 8, 2017 at 6:17 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jun 8, 2017 at 4:48 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, Jun 8, 2017 at 3:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Wed, Jun 7, 2017 at 9:51 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> When inodes index feature is enabled, lookup in indexdir for the index
>>>> entry of lower real inode or copy up origin inode. The index entry name
>>>> is the hex representation of the lower inode file handle.
>>>>
>>>> If the index dentry in negative, then either no lower aliases have been
>>>> copied up yet, or aliases have been copied up in older kernels and are
>>>> not indexed.
>>>>
>>>> If the index dentry for a copy up origin inode is positive, but points
>>>> to an inode different than the upper inode, then either the upper inode
>>>> has been copied up and not indexed or it was indexed, but since then
>>>> index dir was cleared. Either way, that index cannot be used to indentify
>>>> the overlay inode.
>>>>
>>>> If a negative index dentry is found or a positive dentry that matches the
>>>> upper inode, store it in the overlay dentry to be used later. A non-upper
>>>> overlay dentry may still have a positive index from copy up of another
>>>> lower hardlink. This situation can be tested with the path type macros
>>>> OVL_TYPE_INDEX(type) && !OVL_TYPE_UPPER(type).
>>>>
>>>> This is going to be used to prevent breaking hardlinks on copy up.
>>>
>>> Why is a negative index (or any index, for that matter) stored in the
>>> overlay dentry?
>>
>> One of the reasons it is stored in the overlay dentry is to be able to
>> test OVL_TYPE_INDEX() on the dentry, for example, in:
>> "ovl: adjust overlay inode nlink for indexed inodes".
>
> OVL_TYPE_INDEX() is just a bool.  When we do the *first* copy up of a
> file with multiple links we need to update all the aliases anyway:
> i.e. do the hardlink-ups, update ->upperdentry, etc.
>

You mean iterate all existing the overlay inode dentry cache aliases?
Makes sense. together with hardlink-up on lookup, this will make
ovl_type_indexed_lower() impossible. I guess we need not worry about
unhashed/disconnected overlay aliases right now?
although we might need to revisit this assumption with NFS export.

>>
>>> This seems a big waste, since the index dentry will
>>> be allocated for all lower files, yet never used unless copied up.
>>>
>>> Index is used:
>>>
>>>   - at lookup need to find any copied up alias
>>>   - at copyup need to set up new index
>>
>> So it has several more subtle uses:
>> - When whiteout a lower aliases, we need to count down nlink to
>>   know when we can unlink the an orphan index (TODO)
>
> If we do the link-up early (at lookup) then whiteout won't need
> special casing.  The link-up would be unnecessary in this case, but
> delaying it will just cause headaches.
>

While on the subject, maybe you also have an idea about how to
account for whiteouts *before* the first copy up:
If we have N lower hardlinks, delete/whiteout N-1 then copy up
the Nth and then delete the Nth, we need to store the negative nlink
count (N-1) before the index exists to know that we can turn the
orphan index into a whiteout (so NFS decode will guaranty ESTALE).

One though I had was to keep an "anti-index" dir with whiteouts
that are covering the anti-indexed lower.
On mount and on ovl_inode_evict, need to test:
origin.nlink == anti-index.nlink && index.nlink == 1 and unlink
the (positive) index entry. NFS decode can find the anti-index
compare origin.nlink == anti-index.nlink and reach the right
conclusion.

I couldn't find an appropriate solution for rename over though.

>> - Same when renaming over a lower indexed alias
>
> And the same case here.
>
>> - The lower hardlinks copy up on read [1] is another big user
>
> Again, doing it on lookup will be earlier than at read, so no issue.
>

Yes, that would be much better.
I'll rework the patches.

Amir.
