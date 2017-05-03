From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix visible whiteout on not merged dir
Date: Wed, 3 May 2017 15:05:54 +0300
Message-ID: <CAOQ4uxhXDx9PcTVX1bGkn=b1g02zUQ3+=MC_b6sqLwGhoF21Xg@mail.gmail.com>
References: <1493797155-43637-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxiiVxZt+bQ-vo7QAekm8KP51uGx87h=hyYVRRLfyyNySA@mail.gmail.com> <cd632f46-3d8c-87ec-332a-d8bb205f1c71@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:32814 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdECMGA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 May 2017 08:06:00 -0400
Received: by mail-oi0-f52.google.com with SMTP id w10so31020956oif.0
        for <linux-unionfs@vger.kernel.org>; Wed, 03 May 2017 05:06:00 -0700 (PDT)
In-Reply-To: <cd632f46-3d8c-87ec-332a-d8bb205f1c71@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com, zhaohongjiang@huawei.com

On Wed, May 3, 2017 at 2:25 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>
>
> on 2017/5/3 16:38, Amir Goldstein wrote:
>> On Wed, May 3, 2017 at 10:39 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>> When we mount overlayfs which have whiteout on the directory that
>>> are not merged(single lower or upper layer only), the whiteout will
>>> be visible on the merge layer, because of readdir on this directory
>>> is simply handled by the underlying directory.
>>>
>>
>> Hi Zhang,
>>
>> I am interested in one specific use case of visible whiteouts in non-merge
>> dir and that is the use case of a lower dir that has been deleted leaving
>> upper with possible visible whiteouts.
>>
>> With some of my patches related to constant inode numbers, that use case
>> could be fixed simply by replacing OVL_TYPE_MERGE in readdir.c with
>> OVL_TYPE_COPYUP. Every dir that has *ever* been copied up is marked
>> with an xattr overlay.origin, which may or may not be uptodate, but will
>> forever indicate that this is a 'suspect impure' directory.
>>
>> My question is whether this solution is sufficient to cover your use cases
>> and if not, where and how did those whiteouts get to your lower/upper
>> impure directory?
>>
>> You patch does provide extra optimization for 'purifying' a 'suspect impure'
>> directory, but:
>> 1. Not sure if that optimization is that important.
>> 2. Upcoming changes related to constant inode numbers will have to use
>>     ovl_dir_read_merged() for 'suspect impure' dir, not only if that dir may
>>     contain whiteouts, but also if that dir may contain copyups, namely files
>>     with overlay.origin, which may need to report non-real d_ino.
>>
>
>   I think there are three(or more) cases can cause this problem:
>   1. Some one create whiteouts in lower/upper's single subdir manually(as my
>      reproducer show) and then mount overlayfs;
>   2. User create whiteouts in upper's opaque dir manualy and remount
>      overlayfs.
>      For example:
>      mkdir -p low/dir up/dir work merge
>      mount -t overlay -o lowerdir=low,upperdir=up,workdir=work overlayfs merge
>      rm -rf merge/dir
>      mkdir merge/dir
>      umount merge
>      mknod up/dir/aa c 0 0
>      mount -t overlay -o lowerdir=low,upperdir=up,workdir=work overlayfs merge
>      ls -l merge/dir
>
>         ls: cannot access merge/dir/aa: No such file or directory
>         total 0
>         c????????? ? ? ? ?            ? aa
>
>   3. User clean lower dir and remount overlayfs (as you interested in).
>
>   If we use OVL_TYPE_COPYUP in readdir.c, we can find out 'suspect impure'
>   directory in the third case only, we still can not make sure dir have
>   whiteout or not. Especially in the first case, we even haven't any
>   information to deduce it's 'suspect' or not. (Am I miss something ?)
>

Of course it is *possible* to hand craft use cases 1 and 2, but so what?
I am asking for *your* use case. You must have a reason to propose this
purification that is not a user hand crafted impure lower/upper, don't you?
So I am asking of for your use case, OVL_TYPE_COPYUP is enough.
If you need a test branch to test if OVL_TYPE_COPYUP
answers your needs, I can prepare one for you.

>   I want to find a way to fix this and minimize the performance impact,
>   so I use the merged flow in ovl_iterate() to 'purifying' the dir is 'pure'
>   or not, if this dir is not merged and don't have whiteout, no need to create
>   dir cache.
>

If you are able to argue that cases 1 and 2 are important, then your proposed
solution seems fine to me, but if you will also want to benefit from constant
d_ino going forward, then it won't be enough.

>   I didn't find a better way, if it's not important, can we use the merged
>   flow to all directories and remove the is_real flag (not handled by
>   underlying directory)? or other better solutions?
>

Removing the is_real flag would cause performance overhead and bloated
memory usage (for large dir cache), so it is unlikely to be adopted as default
behavior. If you can convince that there is demand for purification, then
perhaps the only way would be to introduce a mount option to ignore the
is_real flag.


Cheers,
Amir.
