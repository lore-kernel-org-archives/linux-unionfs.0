From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH v3 4/6] fsck.overlay: correct redirect xattr check
Date: Fri, 29 Dec 2017 18:25:05 +0800
Message-ID: <1c598a02-6d62-0f61-2c4b-3247ef73a59c@huawei.com>
References: <20171228114023.43999-1-yi.zhang@huawei.com>
 <20171228114023.43999-5-yi.zhang@huawei.com>
 <CAOQ4uxh89i3=TaYsAvQv7YvF0_auW3LYOf5PLtLHJkYo9kCHRQ@mail.gmail.com>
 <e5a0395a-ad58-37af-726b-2690f4f96789@huawei.com>
 <CAOQ4uxjSRwWWbBV9qQ7XCqf6Z+JAS0RVjOS+vPKL+4eGPYk1Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:58049 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753781AbdL2KZj (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 Dec 2017 05:25:39 -0500
In-Reply-To: <CAOQ4uxjSRwWWbBV9qQ7XCqf6Z+JAS0RVjOS+vPKL+4eGPYk1Pw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On 2017/12/29 17:32, Amir Goldstein Wrote:
>>>> +                       goto out;
>>>> +               if (chk.exist && is_dir(&chk.st) &&
>>>> +                   !ovl_ask_question("Is merged dir", pathname, 1))
>>>> +                       ret = ovl_set_opaque(pathname);
>>>
>>> Same here. Better that fsck -y will set opaque right?
>>> So flip the question to "Should set opaque dir"
>>>
>>
>> Here is also not set opaque xattr in '-y' and '-p' mode.
>> I guess general user may not care about "invalid/duplicate redirect xattr"
>> when they modify underlying layers (eg: call "cp -a" or remove redirect origin
>> directory), but they probably know directories with the same name will merge
>> in overlayfs by default, and they should know the distribution of directories
>> after modification. So I prefer to merge directories. Anyway, neither will
>> affect consistency.  :)
>>
> 
> OK, but the question is still wrong, because answering No changes the
> file systems and didn't fsck -n guaranty NOT to change the file system?
> I think you probably need a more error prone interface for changing fs
> that guaranties you cannot change fs when -n was specified.
> 
> The way I see it, the only way to resolve this is run several "pass"
> like e2fsck.
> The first pass just marks duplicate redirects
> The second pass (with -y) sets redirect dirs opaque and removes redirect
> The third pass will ask if to set merge dir opaque in case user answered No
> for any of the redirect dirs in second pass.
> 
> Probably easier for you at this point is to flip the question and not
> implement the above.
> 

You are right, I miss that -n option will change the file system, thanks
for pointing this out. For simplicity now, I will flip the question as
you said(set opaque xattr in with -y option). For the first choice (run
several pass), we can realize it if necessary in the future.

Thanks,
Yi.
