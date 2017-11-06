From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v7 8/8] ovl: ovl_iterate_real() for all pure upper/lower
 in non-samefs case
Date: Mon, 6 Nov 2017 16:30:40 +0200
Message-ID: <CAOQ4uxjmWUnQfCfpP_MncQSmcy978qj8tBo_pUsS7+3ektpsfg@mail.gmail.com>
References: <1509655091-13630-1-git-send-email-amir73il@gmail.com>
 <1509655091-13630-9-git-send-email-amir73il@gmail.com> <CAJfpegt8d6iqWfmwdQtjaag47JkvebKrNgn0SvWSegVJ5VZPyA@mail.gmail.com>
 <CAOQ4uxiaQM+VKLmg=+SHTf1Li_r=jqTU=4BLA6Q6RGeDuE_ZCQ@mail.gmail.com> <CAJfpegtBX7aAmNPg-2Wh+R40EaH2cmteNTBeJnCnvTZ++vXnqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:55561 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752276AbdKFOam (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Nov 2017 09:30:42 -0500
Received: by mail-yw0-f194.google.com with SMTP id t11so7915367ywg.12
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Nov 2017 06:30:41 -0800 (PST)
In-Reply-To: <CAJfpegtBX7aAmNPg-2Wh+R40EaH2cmteNTBeJnCnvTZ++vXnqQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Nov 6, 2017 at 3:57 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Nov 6, 2017 at 12:45 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Mon, Nov 6, 2017 at 11:35 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>>> And I'm still hoping we can get some infrastructure for partitioning
>>> the ino space (i.e. filesystem can report that it will only use N bits
>>> from the available 64).  This would allow properly solving the
>>> non-samefs case without adding hacks.
>>>
>>
>> Oh! there is a ridiculously simple way for some file systems to know
>> that they are using 32 bit inodes.
>> We already call ovl_can_decode_fh() for upper and all lower layers.
>> All we need to do is actually encode the layer directory and check
>> returned fh_type.
>>
>> If fh_type is FILEID_INO32_GEN, bingo!
>> That turns out to be true to all file systems that use the default
>> implementation of .encode_fh, including the ext* family, squashfs
>> and more.
>
> That's good.  However testing FILEID_INO32_GEN is not particularly
> reliable since that constant is defined as "1" and AFAIR there are
> other uses of "1" as type, just not with this name.  And nothing
> guarantees that all those uses are for 32bit inode numbers, although
> that may be the case.
>

Right... although for most fs I mentioned, default .encode_fh *is* in fact
a guaranty for 32bit inodes, so we can start with that and add explicit
number of bits to super block later.

> I'd be more happy with an explicit bit count in struct super_block
> indicating the number of bits in use.
>
> Such an interface wouldn't limit filesystem implementors in any way.
> They'd just be more flexibly declare the needs they have.
>
> Also there is possibly a usecase for a large fs (non 32-bit inum) as
> overlayfs upper layer.   I would guess it wouldn't be too difficult to
> add an "inumbits=N" parameter to mkfs.xfs for that case.
>

Cannot set inumbits, because they are already determined by fs
geometry (MSB bits are AG #).
The good news is that you can always know the max inumbits of
any existing xfs, so it would be possible for admin to mount overlay
with mount option upperinumbits=.
The bad news is that I think any xfs can potentially be grown to
use all inode bits, so it is unlikely that xfs will be willing to make
any inumbits commitment in super block besides the already
supported case of inode32 mount option.

Amir.
