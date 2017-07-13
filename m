From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] check_layer: Add tests for constant st_dev
Date: Thu, 13 Jul 2017 17:59:02 +0300
Message-ID: <CAOQ4uxi16ZT-=ghVsXT0iCcGtKSXeMSPYZLMv+5X6+szMxJf8Q@mail.gmail.com>
References: <20170704170028.4278-1-chandan@linux.vnet.ibm.com>
 <CAOQ4uxjuKCGGK1shB1YO3Ony5Gqcv_mm7kidoeO8mgvnTqi7kw@mail.gmail.com>
 <CAOQ4uxicgyZRKxBVv+KTU8jQ0g7kSS7TWcjpNj8v5Za_gsP9iA@mail.gmail.com> <10642288.FqVSjOuREu@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:35695 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdGMO7D (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2017 10:59:03 -0400
Received: by mail-yb0-f194.google.com with SMTP id p203so2760191yba.2
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2017 07:59:03 -0700 (PDT)
In-Reply-To: <10642288.FqVSjOuREu@localhost.localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Jul 13, 2017 at 5:17 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Saturday, July 8, 2017 1:42:41 PM IST Amir Goldstein wrote:
>> OK, my pseudo patch was mostly correct, but full of brainoes,
>> push a tested patch to
>> https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel
>>
>> Please review and verify.
>>
>
>
> Hi Amir,
>
> './run --ov' on 'next' kernel (i.e. the one containing code which returns
> pseudo st_devs for files on lowerdir) fails as shown below,

Are you sure?
I'm pretty sure that I tested this.
What is the HEAD commit of the branch you are testing with?

>
> $ ./run --ov
> ***
> *** ./run --ov --ts=0 open-plain
> ***
> TEST open-plain.py:10: Open O_RDONLY
> /mnt/a/foo100: File not on lower/upper layer
>
> The corresponding code from check_layer() is,
>
>             elif dev != self.upper_fs() and dev != self.lower_fs():
>                 raise TestError(name + ": File not on lower/upper layer")
>
>
> This happens due to open-plain.py's subtest_1() opening a file on lowerdir in
> read-only mode (i.e. copy-up does not occur). Later, stat(2) invocation from
> check_layer() would end up returning the pseudo st_dev corresponding to
> lowerdir.
>
>
> './run --ov --samefs --verify' on 4.12 kernel fails as shown below,
>
> $ ./run --ov --samefs --verify
> ***
> *** ./run --ov --ts=0 hard-link
> ***
> TEST hard-link.py:10: Hard link file
> ./run --link /mnt/a/foo100 /mnt/a/no_foo100
> /mnt/a/no_foo100: inode number wrong (got 39001, want 37581)
>
> The failure happens because the dentry representing the new hard link wouldn't
> have __OVL_PATH_ORIGIN set.
>

Right.
That is because of fbaf94ee3cd5 ("ovl: don't set origin on broken
lower hardlink")
that Miklos added just before final v4.12.
It will be fixed on kernel v4.13-rc1 with CONFIG_OVERLAYFS_INDEX=y

Thanks!
