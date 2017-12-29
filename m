From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 4/6] fsck.overlay: correct redirect xattr check
Date: Fri, 29 Dec 2017 11:32:32 +0200
Message-ID: <CAOQ4uxjSRwWWbBV9qQ7XCqf6Z+JAS0RVjOS+vPKL+4eGPYk1Pw@mail.gmail.com>
References: <20171228114023.43999-1-yi.zhang@huawei.com> <20171228114023.43999-5-yi.zhang@huawei.com>
 <CAOQ4uxh89i3=TaYsAvQv7YvF0_auW3LYOf5PLtLHJkYo9kCHRQ@mail.gmail.com> <e5a0395a-ad58-37af-726b-2690f4f96789@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f171.google.com ([209.85.213.171]:42743 "EHLO
        mail-yb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751379AbdL2Jcd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 Dec 2017 04:32:33 -0500
In-Reply-To: <e5a0395a-ad58-37af-726b-2690f4f96789@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

>>> +                       goto out;
>>> +               if (chk.exist && is_dir(&chk.st) &&
>>> +                   !ovl_ask_question("Is merged dir", pathname, 1))
>>> +                       ret = ovl_set_opaque(pathname);
>>
>> Same here. Better that fsck -y will set opaque right?
>> So flip the question to "Should set opaque dir"
>>
>
> Here is also not set opaque xattr in '-y' and '-p' mode.
> I guess general user may not care about "invalid/duplicate redirect xattr"
> when they modify underlying layers (eg: call "cp -a" or remove redirect origin
> directory), but they probably know directories with the same name will merge
> in overlayfs by default, and they should know the distribution of directories
> after modification. So I prefer to merge directories. Anyway, neither will
> affect consistency.  :)
>

OK, but the question is still wrong, because answering No changes the
file systems and didn't fsck -n guaranty NOT to change the file system?
I think you probably need a more error prone interface for changing fs
that guaranties you cannot change fs when -n was specified.

The way I see it, the only way to resolve this is run several "pass"
like e2fsck.
The first pass just marks duplicate redirects
The second pass (with -y) sets redirect dirs opaque and removes redirect
The third pass will ask if to set merge dir opaque in case user answered No
for any of the redirect dirs in second pass.

Probably easier for you at this point is to flip the question and not
implement the above.

Cheers,
Amir.
