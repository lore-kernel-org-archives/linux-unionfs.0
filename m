From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/9] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Thu, 12 Oct 2017 16:39:18 +0300
Message-ID: <CAOQ4uxj__oZVeHU_OrToz03DbPY-GVBDa+JJOxdeX19xTe=HLg@mail.gmail.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
 <1507649544-4539-4-git-send-email-vgoyal@redhat.com> <CAOQ4uxiU6BNrwKnfx1ToY4ZARV8X4S6HRNmfhCmaON=+46B7bg@mail.gmail.com>
 <20171011135715.GB8086@redhat.com> <CAOQ4uxg1OwbFuytiHLn3fwXzu3mZ8cwW6Vadj3YgTihbiL0BdA@mail.gmail.com>
 <20171011165348.GC8086@redhat.com> <CAOQ4uxiano2-_YBOgND9O+D3B8bbHK1fUvUwQWev9HGmCkFmjQ@mail.gmail.com>
 <20171011183416.GD8086@redhat.com> <CAOQ4uxgrzTpgu09ZdpHkVHbKA=aqHDk+yu9Qq6xXpxMbN4v0wg@mail.gmail.com>
 <20171012132346.GC3132@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35531 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752702AbdJLNjT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2017 09:39:19 -0400
Received: by mail-qt0-f195.google.com with SMTP id z19so2905695qtg.2
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2017 06:39:19 -0700 (PDT)
In-Reply-To: <20171012132346.GC3132@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>

On Thu, Oct 12, 2017 at 4:23 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Oct 11, 2017 at 11:29:02PM +0300, Amir Goldstein wrote:
>> On Wed, Oct 11, 2017 at 9:34 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
...
>> > So this is failing if we find a dentry which has origin but no index. And
>> > this will hit if a overlay was mounted with index=off, hard link copied up
>> > and then remounted with index=on. In that case it will return -EIO.
>> >
>> > My question is, that does this have to be an error. If we are supporting
>> > this use case, where index can be turned on later, then can we just warn
>> > and continue? Or set OVL_XATTR_INDEX on upper to indicate that this
>> > upper should have an index.
>> >
>> > I mean ORIGIN started with the exclusive purpose of inode number stability.
>> > But this is sort of infrastructure which keeps track of ORIGIN of copy
>> > up source and can be used for metadata copy up as well. So indexing should
>> > not put restrictions on what files ORIGIN can be set on. Instead both
>> > metacopy and index should not make use of ORIGIN where they this things
>> > are broken for them.
>> >
>> > Thoughts?
>> >
>>
>> It is interesting to note that the commit that introduced this limitation
>> fbaf94ee3cd5 ("ovl: don't set origin on broken lower hardlink")
>> was merged as a "last minute" (rc7) fix patch before final v4.12
>> and had this text in commit message:
>> "We can relax this in the future when we are able to index upper object by
>>     origin."
>>
>> I am not sure it is easy to relax this limitation, but I may be wrong.
>> I'll take another swing at writing the full story. Hope I will get it
>> right this time...
>>
>> Index is a 1-to-1 mapping from origin *inode* to upper *inode*.
>> Highlighting *inode* because there may be many lower or upper
>> aliases of that inode.
>>
>> The index key (its name) is the file handle of origin inode.
>> The index itself is an upper alias (link) of upper inode.
>>
>> If more than 1 upper inode point to the same origin inode,
>> then index cannot be consistent for both upper aliases.
>> This would actually be a common scenario if hardlinks are broken
>> due to index=off (or kernel v4.12 without the rc7 fix)
>> and then index is turned on and more lower aliases are copied up.
>>
>> On lookup, we can detected that index found by origin
>> file handle is not a hardlink of upper inode and ignore it instead of
>> returning EIO on:
>>         if (upper && d_inode(upper) != inode) {
>>                 pr_warn_ratelimited("overlayfs: wrong index found
>> (index=%pd2, ino=%lu, upper ino=%lu).\n",
>>                                     index, inode->i_ino, d_inode(upper)->i_ino);
>>                 goto fail;
>>         }
>>
>> And we could have allowed for "hard link with origin but no index"
>> instead of returning EIO.
>>
>> In those cases, we would need to get a hashed overlay inode by address
>> of upper inode, instead of by address of origin inode and we would have to
>> not set the OVL_INDEX flag on lookup.
>>
>> I guess one of the reasons we did not do it on first version of index feature
>> is that we wanted to keep things simple and we did not have a good enough
>> reason to set ORIGIN for broken hardlinks.
>>
>> So I am now open to the possibility that we may be able to set ORIGIN
>> for broken hardlinks without breaking anything, but will need to see patches
>> before I can say if we missed something. Maybe Miklos can see something
>> that I have missed.
>>
>> In any case, for the sake of simplicity, I wouldn't bother doing metacopy up
>> of lower hardlinks in first version of metacopy feature.
>
> Ok, I can see that current code will return -EIO if index is enabled after
> some copy up have taken place with index=off. So for now, I will disable
> metadata copyup on hardlinks if index=off.
>

Well, if it takes me so much effort to hardly convince myself that this
behavior is correct, then I may be trying to rationalize a bug...

The current EIO behavior is not nice so say the least.
The protection of fbaf94ee3cd5 ("ovl: don't set origin on broken lower
hardlink")
doesn't hold if lower is not a hardlink when it is copied up (with
either index=off/on)
and then lower is hardlinked while overlay is offline.

> But it would be nice if we can move away from this restriction.
>

I've already written the xfstest of the use case above and will try to get
rid of those EIO.

Amir.
