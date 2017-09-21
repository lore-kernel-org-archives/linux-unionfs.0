From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V3] ovl: Allocate anonymous devs for lowerdirs
Date: Thu, 21 Sep 2017 20:46:26 +0300
Message-ID: <CAOQ4uxi1TrUtFZAdn-j65Y9gNeg9Vi0+0LRk9_Ve_C=9rkbVsQ@mail.gmail.com>
References: <CAJfpegs9W=qQRXBeF7h4t4bxnXvbGnTbUi+iGaZhft79Mvxgtw@mail.gmail.com>
 <20170724091722.23252-1-chandan@linux.vnet.ibm.com> <2098530.dS0XS0MFtf@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:37688 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbdIURq1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2017 13:46:27 -0400
Received: by mail-yw0-f195.google.com with SMTP id s62so3276864ywg.4
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Sep 2017 10:46:27 -0700 (PDT)
In-Reply-To: <2098530.dS0XS0MFtf@localhost.localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Jul 27, 2017 at 9:24 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Monday, July 24, 2017 2:47:22 PM IST Chandan Rajendra wrote:
>> For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
>> provides unique values for st_dev. The unique values are obtained by
>> allocating anonymous bdevs for each of the lowerdirs in the overlayfs
>> instance.
>>
>> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> ---
>> Changelog:
>>
>> v2->v3: Optimize away O(n) search for pseudo dev in ovl_get_pseudo_dev().
>>
>> v1->v2: Drop code that provided unique st_dev across copy up.
>>
>
> I have rebased Amir's "ovl: relax same fs constrain for constant st_ino"
> patch on top of the changes made in this patch. The tree containing
> the rebased patch can be found at
> "https://github.com/chandanr/linux.git rework-anonymous-dev"
>
> I have tested this by executing unionmount-testsuite's "./run --ov --verify".
>


Chandan,

Can you rebase your work on v4.14-rc1?

You now need to add another patch to relax same fs constrain for
constant d_ino in readdir.
Note that you will also need to relax in ovl_cache_update_ino()
WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev)

unionmount-testsuite's --verify (non-samefs) does not verify d_ino and
the your constant d_ino xfstest does not cover the non-samefs case.
A new xfstest, a simple variant of your samefs xfstest should be sufficient.

Cheers,
Amir.
