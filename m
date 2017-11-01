From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v5 2/4] ovl: allocate anonymous devs for lowerdirs
Date: Wed, 1 Nov 2017 18:41:51 +0200
Message-ID: <CAOQ4uxhpq_mEyyUj0M5AELPYGuHwyCpxz9+HE4K0qaY1+-XQGw@mail.gmail.com>
References: <1509395247-15180-1-git-send-email-amir73il@gmail.com>
 <1509395247-15180-3-git-send-email-amir73il@gmail.com> <20171101144249.GA8259@redhat.com>
 <CAOQ4uxiReuzqQ09b8f0YxxTzT-Lt0pSPxsTsxz9feuFPrmTGWg@mail.gmail.com> <20171101154700.GA3125@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:55636 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754597AbdKAQlw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 12:41:52 -0400
Received: by mail-yw0-f196.google.com with SMTP id t11so2320221ywg.12
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Nov 2017 09:41:52 -0700 (PDT)
In-Reply-To: <20171101154700.GA3125@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Nov 1, 2017 at 5:47 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Nov 01, 2017 at 05:02:55PM +0200, Amir Goldstein wrote:
>> On Wed, Nov 1, 2017 at 4:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Mon, Oct 30, 2017 at 10:27:25PM +0200, Amir Goldstein wrote:
>> >> From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> >>
>> >> For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
>> >> provides unique values for st_dev. The unique values are obtained by
>> >> allocating anonymous bdevs for each of the lowerdirs in the overlayfs
>> >> instance.
>> >
>> > Hi Amir, Chandan,
>> >
>> > In the commit message, can we also mention what's the current behavior
>> > and why this new behavior beneficial/desirable.
>> >
>>
>> This is the blurb from the uptodate patch on my branch:
>>
>>      For non-samefs setup, to make sure that st_dev/st_ino pair
>>     is unique across the system, we return a unique anonymous
>>     st_dev for stat(2) of lower layer inode.
>>
>> A bit fatter, but not fat enough...
>>
>> Actually, it is not accurate, because st_dev/st_ino pair of pure
>> upper is still same values as underlying inode for non-samefs so the
>> values are not unique among all inodes in the system.
>
> Hi Amir,
>
> So as of now for non-samefs non-dir case we return st_dev/st_ino of
> lower inode. And with this change we will return st_dev of overlayfs
> while inode of lower, right?
>
> What does unique mean in this context. IIUC, st_dev/st_inode of lower
> will be unique in the system, isn't it. Which other inode can have
> same st_dev/st_ino pair.
>
> Or is it the case that if same inode is accessed through overlayfs, we
> want to report a different st_dev.
>

That is the case.
It is not that important and we did not fix this case for upper inodes,
but this effectively the change of this patch.
We actually need this patch for constant st_ino/st_dev across copy up,
which comes right after this.

>>
>> I can't remember if there was a reason for not allocating anonymous bdev
>> for upper
>
> That's a good point.
>
>> or if it just because we did not need it to guaranty uniqueness
>> of st_dev/st_ino *among* overlay inodes
>
> Even for lower, st_dev will be unique for different lower on non same-fs,
> right. IOW, when it come to uniqueness of st_dev/st_ino pair, among
> overlay inodes, lower and upper should have same requirements.
>
>> while guarantying constant
>> st_dev/st_ino across copy up.
>
> Hmm..., I did not get this point. Over copy up, atleast st_ino will change
> for non-samefs case.
>
> I will spend more time on patch.
>

Urgh! It took me a while to remember the reason why system wide uniqueness
is important for lower but less for upper.
An upper object has the same content as the "real" object and they have the
same st_ino/st_dev so its ok that diff will skip comparing them.
A copy-up object does not have the same content as the lower "real" object,
so if it has the same st_ino/st_dev as real object, diff will skip compare and
we have a problem.

Amir.
