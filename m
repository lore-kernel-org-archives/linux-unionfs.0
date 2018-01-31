From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [QUESTION] problem about origin xattr
Date: Wed, 31 Jan 2018 17:38:45 +0200
Message-ID: <CAOQ4uxgK+fsRp=gRmQa-9zp8BZFwaJNxTP9ioCg+gOij2G-RCQ@mail.gmail.com>
References: <1594ffa4-1877-0331-d662-bf9e1e0dcca1@huawei.com>
 <CAOQ4uxhGmD2g4Z9EY504OfssyiVvUskKGec0vqraHOHia88PPQ@mail.gmail.com> <20180131152041.GA8087@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:34271 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751447AbeAaPir (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 10:38:47 -0500
Received: by mail-yw0-f169.google.com with SMTP id t201so7827317ywf.1
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 07:38:46 -0800 (PST)
In-Reply-To: <20180131152041.GA8087@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: yangerkun <yangerkun@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jan 31, 2018 at 5:20 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jan 31, 2018 at 03:57:12PM +0200, Amir Goldstein wrote:
>
> ORIGIN behavior is little unintuitive though. Despite the fact that file
> is not searchable through lower, it is visible through decoding of file
> handle and it is atleast non-intuitive.
>

Maybe not intuitive at first glance, but try again:

The only thing we *need* from underlying fs is to provide us with a unique
and persistent inode number we can use for the overlay object.

Even if the inode number we get from underlying fs is not in any of the
layers, it is still a  viable inode number we can use in overlay coupled
with overlay unique st_dev, to create a system wide unique st_dev;st_ino
tuple.

So I don't see any reason to fix this.
However, if one would want to fix this, that will require at least:
1. storing a 'connectable' non-dir file handle in ORIGIN xattr
2. but still use the non-connectable file handle for index
3. in ovl_acceptable(), check if non-dir is !IS_ROOT and validate
    it with is_subdir() same as done for directories

Cheers,
Amir.

>
>
>> Hi yangerkun,
>>
>> Replying from phone so sorry for excluding list.
>> Please add list back if replying.
>>
>> This behavior is expected and sort of documented in ovl_acceptable()
>>
>> The only property required from st_ino
>> Is that it is unique together with st_dev of overlay.
>>
>> Nothing in that example breaks this requirement.
>>
>> The only semi problem is that when the old origin will be unlinked st_ino
>> of overlay inode will change.
>> That is an acceptable behavior for offline changes in overlay layers.
>>
>> Cheers,
>> Amir.
>> On Jan 31, 2018 12:36 PM, "yangerkun" <yangerkun@huawei.com> wrote:
>>
>> Hi,
>>
>> While thinking about "origin" xattr, i find a problem which retrieval
>> methods show as below:
>>
>> $mkdir lower lower1 lower2 upper work merge
>> $touch lower1/a
>> $mount -t overlay -olowerdir=lower:lower1,upperdir=upper,workdir=work merge
>> merge
>> $echo abc > merge/a
>> $ls -li merge/a
>> Then, we can get the ino of file a equals to the ino of lower1/a.
>> $umount merge
>> $mount -t overlay -olowerdir=lower:lower2,upperdir=upper,workdir=work merge
>> merge
>> $ls -li merge/a
>>
>> The ino for file a is same as file lower1/a, while there is no file a in
>> lower and lower2. Because ovl_get_origin will get the wrong origin.
>>
>> Thanks,
>> yangerkun
