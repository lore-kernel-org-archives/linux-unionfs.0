From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: overlayfs in 4.12-rc1. Files in lower become unwritable in the overlay
Date: Tue, 16 May 2017 00:52:47 +0300
Message-ID: <CAOQ4uxiyx5n60vuSU+zxCsGVF6Si3rNWaGLyYzv=Ky5md2RDUQ@mail.gmail.com>
References: <E1dAI7k-0006Fd-6q@tux00.mathematik.uni-freiburg.de> <CAJfpegs_FGhA4yj=W6eraLrw4GAavTv1-Zxwj27XM4QgGvo-_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34369 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbdEOVws (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 May 2017 17:52:48 -0400
Received: by mail-oi0-f54.google.com with SMTP id b204so3898504oii.1
        for <linux-unionfs@vger.kernel.org>; Mon, 15 May 2017 14:52:48 -0700 (PDT)
In-Reply-To: <CAJfpegs_FGhA4yj=W6eraLrw4GAavTv1-Zxwj27XM4QgGvo-_Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Martin Ziegler <ziegler@uni-freiburg.de>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, May 15, 2017 at 8:57 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, May 15, 2017 at 5:41 PM,  <ziegler@uni-freiburg.de> wrote:
>>
>> How to reproduce: Make sure that the kernel is compiled with
>> CONFIG_TMPFS_XATTR not set. (Otherwise, as Miklos suggested, the bug
>> does not occur)
>>
>> Start with a directory "lower" (btrfs in my case) containing an empty
>> file "x", and three empty directories "upper", "workdir", "over" on
>> "/tmp" (tmpfs). Then mount the overlayfs
>>
>>    sudo mount -t overlay -o \
>>      lowerdir=lower,upperdir=/tmp/upper,workdir=/tmp/workdir overlay \
>>      /tmp/over
>>
>> Then the commands
>>
>>    sudo touch /tmp/over/x
>>    sudo mv /tmp/over/x /tmp/over/z
>>
>> fail:
>>   touch: cannot touch '/tmp/over/x': Operation not supported
>>   mv: cannot move '/tmp/over/x' to '/tmp/over/z': Operation not
>>   supported
>
> Thanks for the report.  Fix pushed to overlayfs-next branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
>

I don't see the fix on the branch..
