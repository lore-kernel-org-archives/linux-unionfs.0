From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 08/20] ovl: lookup index entry for non-dir
Date: Fri, 9 Jun 2017 13:49:52 +0200
Message-ID: <CAJfpegvARnYsEaqq+3Roypvkacf0n9R5A8A-NDL4=t3EaffJyQ@mail.gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
 <1496821884-5178-9-git-send-email-amir73il@gmail.com> <CAJfpegsDv__Er79=m824pioYXnVeFP3ZCnDEvz0Ync5KnUSpwQ@mail.gmail.com>
 <CAOQ4uxieGBvCFFsSaL0X776PBnNqt=uOHO8E5cbTWUrAeRJwzg@mail.gmail.com>
 <CAJfpegvbExTESQQTF0rkV7oTX2R-HxGuk=EJ6i3qLMYr56Kd4A@mail.gmail.com>
 <CAOQ4uxhHPa-Og__irD8MTCvy+vkWDibi-sw7wuekVnYx5Jh+Yg@mail.gmail.com>
 <CAJfpegtLfm2vPmzarUnf-EkVN+J=tii6J0UApOJ3sRp4UVDEUg@mail.gmail.com> <CAOQ4uxgRiNx6VkfLM+m50b2w5Y3c7+Gks=uhNknRmzNBDU5PDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34586 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbdFILtx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jun 2017 07:49:53 -0400
Received: by mail-oi0-f65.google.com with SMTP id d99so4440157oic.1
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jun 2017 04:49:53 -0700 (PDT)
In-Reply-To: <CAOQ4uxgRiNx6VkfLM+m50b2w5Y3c7+Gks=uhNknRmzNBDU5PDA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Jun 9, 2017 at 11:38 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Jun 9, 2017 at 11:43 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Jun 8, 2017 at 6:09 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>>> You mean iterate all existing the overlay inode dentry cache aliases?
>>
>> Yes.
>>
>> And locking is needed.  The INUSE flag could provide that, but I'd
>> prefer something local to the overlay instance (i.e. in ovl_fs).  The
>> reason is that lower layers could be shared and then separate
>> instances would be interfering with each other, which is not nice.
>> First version could just do a single mutex in ovl_fs.  Could refine
>> that to an array of locks hashed by origin inode, or something.
>>
>
> Then how about inuse_lock the overlay inode?
> It is already unique among all lower/upper aliases.
> In fact,  oe->copying and ovl_{start,end}_copy_up could probably
> be moved from the overlay dentry to the overlay inode.
> It should work the same for the old use cases and provide the needed
> (granular) locking for hardlinks copy-aliases-up.

I like that.

> I would just need to implement inode_inuse_lock().

Just put the mutex in the new struct ovl_inode?

>
>>>
>>> While on the subject, maybe you also have an idea about how to
>>> account for whiteouts *before* the first copy up:
>>
>> Ah, another special case.  We could un-special it by doing the copy-up
>> to index anyway before commencing with the delete (only for i_nlink >
>> 1, obviously).  Bit of a hack, but would make things simpler.
>>
>
> This certainly works for my use case of clone up, so I don't mind wiring up
> this workaround. We would still need to keep persistent count of copy ups
> (e.g. in trusted.overlay.nlink of upper), because the condition to whiteout the
> index on mount/evict is (origin->i_nlink == trusted.overlay.nlink &&
> index->i_nlink == 1), but I was planning to do that anyway.

Yes.

The challenge is in accounting the number of link-ups atomically with
the link-up itself.  No ideas off-hand.

> <soliciting> copy-up-on-delete is also classic use case for metadata-copy-up.
> And then we can proceed to metadata-index-copy-up on open for read to
> solve the consistent ro/rw fd.
> Did you get a chance to look at the page mapping sharing?

Not yet.

Thanks,
Miklos
