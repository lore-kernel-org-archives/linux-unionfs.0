From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v5 2/4] ovl: allocate anonymous devs for lowerdirs
Date: Thu, 2 Nov 2017 14:47:07 +0200
Message-ID: <CAOQ4uxiQSuQo0jrRZwiq_66zgcfb_pYdBJHqC_vrkF0oyQCy3A@mail.gmail.com>
References: <1509395247-15180-1-git-send-email-amir73il@gmail.com>
 <1509395247-15180-3-git-send-email-amir73il@gmail.com> <20171101144249.GA8259@redhat.com>
 <CAOQ4uxiReuzqQ09b8f0YxxTzT-Lt0pSPxsTsxz9feuFPrmTGWg@mail.gmail.com>
 <20171101154700.GA3125@redhat.com> <CAOQ4uxhpq_mEyyUj0M5AELPYGuHwyCpxz9+HE4K0qaY1+-XQGw@mail.gmail.com>
 <20171102122730.GA16677@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:45539 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbdKBMrI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 08:47:08 -0400
Received: by mail-yw0-f194.google.com with SMTP id j4so4650199ywb.2
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Nov 2017 05:47:08 -0700 (PDT)
In-Reply-To: <20171102122730.GA16677@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Nov 2, 2017 at 2:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Nov 01, 2017 at 06:41:51PM +0200, Amir Goldstein wrote:
>
> [..]
>> >> I can't remember if there was a reason for not allocating anonymous bdev
>> >> for upper
>> >
>> > That's a good point.
>> >
>> >> or if it just because we did not need it to guaranty uniqueness
>> >> of st_dev/st_ino *among* overlay inodes
>> >
>> > Even for lower, st_dev will be unique for different lower on non same-fs,
>> > right. IOW, when it come to uniqueness of st_dev/st_ino pair, among
>> > overlay inodes, lower and upper should have same requirements.
>> >
>> >> while guarantying constant
>> >> st_dev/st_ino across copy up.
>> >
>> > Hmm..., I did not get this point. Over copy up, atleast st_ino will change
>> > for non-samefs case.
>> >
>> > I will spend more time on patch.
>> >
>>
>> Urgh! It took me a while to remember the reason why system wide uniqueness
>> is important for lower but less for upper.
>> An upper object has the same content as the "real" object and they have the
>> same st_ino/st_dev so its ok that diff will skip comparing them.
>> A copy-up object does not have the same content as the lower "real" object,
>> so if it has the same st_ino/st_dev as real object, diff will skip compare and
>> we have a problem.
>
> I am not sure I understand this.  So you are doing a diff between a file
> on overlayfs and same file accessed outside overlayfs?
>

Yes.

> If a file is on lower, then it has not been modified and diff skipping
> it makes perfect sense?

Yes.

But!
With constant st_ino/st_dev across copy up (the next patch)
the overlay object still has the lower inode st_dev/st_inode also *after*
copy up and modification. Now if you diff overlay file and lower
file diff will say they are equal, but in fact they have a different content.

This is how I phrased this in latest patch set per your request:

-----------------------
[V6 4/9] ovl: return anonymous st_dev for lower inodes

For non-samefs setup, to make sure that st_dev/st_ino pair
is unique across the system, we return a unique anonymous
st_dev for stat(2) of lower layer inode.

We need to make this change before fixing constant st_dev/st_ino across
copy up for non-samefs. Otherwise, we can end up with two objects
in the system, the real lower inode and the overlay inode which
have same st_dev/st_ino value, but different content.


Hope this is clear.

Amir.
