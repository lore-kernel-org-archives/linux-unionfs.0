From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 08/20] ovl: lookup index entry for non-dir
Date: Fri, 9 Jun 2017 10:43:35 +0200
Message-ID: <CAJfpegtLfm2vPmzarUnf-EkVN+J=tii6J0UApOJ3sRp4UVDEUg@mail.gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
 <1496821884-5178-9-git-send-email-amir73il@gmail.com> <CAJfpegsDv__Er79=m824pioYXnVeFP3ZCnDEvz0Ync5KnUSpwQ@mail.gmail.com>
 <CAOQ4uxieGBvCFFsSaL0X776PBnNqt=uOHO8E5cbTWUrAeRJwzg@mail.gmail.com>
 <CAJfpegvbExTESQQTF0rkV7oTX2R-HxGuk=EJ6i3qLMYr56Kd4A@mail.gmail.com> <CAOQ4uxhHPa-Og__irD8MTCvy+vkWDibi-sw7wuekVnYx5Jh+Yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34737 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdFIInh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jun 2017 04:43:37 -0400
Received: by mail-oi0-f48.google.com with SMTP id o65so28205864oif.1
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jun 2017 01:43:36 -0700 (PDT)
In-Reply-To: <CAOQ4uxhHPa-Og__irD8MTCvy+vkWDibi-sw7wuekVnYx5Jh+Yg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Jun 8, 2017 at 6:09 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> You mean iterate all existing the overlay inode dentry cache aliases?

Yes.

And locking is needed.  The INUSE flag could provide that, but I'd
prefer something local to the overlay instance (i.e. in ovl_fs).  The
reason is that lower layers could be shared and then separate
instances would be interfering with each other, which is not nice.
First version could just do a single mutex in ovl_fs.  Could refine
that to an array of locks hashed by origin inode, or something.

>
>>>
>>>> This seems a big waste, since the index dentry will
>>>> be allocated for all lower files, yet never used unless copied up.
>>>>
>>>> Index is used:
>>>>
>>>>   - at lookup need to find any copied up alias
>>>>   - at copyup need to set up new index
>>>
>>> So it has several more subtle uses:
>>> - When whiteout a lower aliases, we need to count down nlink to
>>>   know when we can unlink the an orphan index (TODO)
>>
>> If we do the link-up early (at lookup) then whiteout won't need
>> special casing.  The link-up would be unnecessary in this case, but
>> delaying it will just cause headaches.
>>
>
> While on the subject, maybe you also have an idea about how to
> account for whiteouts *before* the first copy up:

Ah, another special case.  We could un-special it by doing the copy-up
to index anyway before commencing with the delete (only for i_nlink >
1, obviously).  Bit of a hack, but would make things simpler.

Thanks,
Miklos
