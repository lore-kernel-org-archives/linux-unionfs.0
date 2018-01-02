From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH] ovl: fix inconsistent d_ino for legacy merge dir
Date: Tue, 2 Jan 2018 16:31:20 +0800
Message-ID: <66c2703f-aa79-9721-4f06-99c62590e501@huawei.com>
References: <1514713778-15640-1-git-send-email-amir73il@gmail.com>
 <273d72b1-8c19-ef41-ef26-6304a333b532@huawei.com>
 <CAOQ4uxiJY+1nz3P1fpy8hukCGL1Vx8GOhX3PFjCO6LM5nSA3_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3254 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752556AbeABIbr (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jan 2018 03:31:47 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E3B53F0C7A128
        for <linux-unionfs@vger.kernel.org>; Tue,  2 Jan 2018 16:31:31 +0800 (CST)
In-Reply-To: <CAOQ4uxiJY+1nz3P1fpy8hukCGL1Vx8GOhX3PFjCO6LM5nSA3_Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>

On 2018/1/2 16:14, Amir Goldstein Wrote:
> On Tue, Jan 2, 2018 at 10:00 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> On 2017/12/31 17:49, Amir Goldstein Wrote:
>>> For a merge dir that was copied up before v4.12 or that was hand crafted
>>> offline (e.g. mkdir {upper/lower}/dir), upper dir does not contain the
>>> 'trusted.overlay.origin' xattr.  In that case, stat(2) on the merge dir
>>> returns the lower dir st_ino, but getdents(2) returns the upper dir d_ino.
>>>
>>> After this change, on merge dir lookup, missing origin xattr on upper
>>> dir will be fixed and 'impure' xattr will be fixed on parent of the legacy
>>> merge dir.
>>>
>>> Suggested-by: zhangyi (F) <yi.zhang@huawei.com>
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
>>>
>>> Zhangyi,
>>>
>>> Please review/test this patch.
>>> I ended up applying it at the bottom of verify_dir [1] series,
>>> so it could be merged to v4.15 and/or easily backported to v4.14
>>> (where consistent d_ino was merged) if Miklos thinks this is an important
>>> use case to fix.
>>>
>>
>> Hi Amir,
>> This patch looks good (one nit below) but still have a case which will lead to problem
>> we missed in last discussion:
>> Call getdent(2) before invoke ovl_lookup() after first mount.
>>
>> eg:
>> 1) mkdir {upper/lower}/dir merge work
>> 2) mount to merge
>> 3) getdent merge
>> 2253114  directory    24          2  dir
>> 4) ls merge
>> 5) getdent merge
>> 2253113  directory    24          2  dir
>>
>> Strictly speaking, it is a problem ,but not sure it's worth to fix now.
> 
> Yeh, it's true.
> 
> Please note, that the sole purpose of "impure" xattr in the world,
> is to optimize away the need to lookup directory entries in getdents
> for fixing d_ino.
> So yes, I think this specific corner case is something that users will have to
> be educated about.
> 
> Also please note that I have not found any program that relies of d_ino of
> directories (not that I would know where to look). I did check that
> 'find -inum <ino>'
> does NOT reply of values of d_ino for subdirs. 'find' always call
> stat(2) for subdirs.
> So that is one less program to worry about.
> 

I see, you can add:
Reviewed-by: zhangyi (F) <yi.zhang@huawei.com>

Thanks,
Yi.
