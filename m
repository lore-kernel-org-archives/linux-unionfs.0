From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH] ovl: fix visible whiteout on not merged dir
Date: Thu, 4 May 2017 16:36:00 +0800
Message-ID: <580c8b09-1d3c-94d6-4d07-2a4a21a2dc59@huawei.com>
References: <1493797155-43637-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxiiVxZt+bQ-vo7QAekm8KP51uGx87h=hyYVRRLfyyNySA@mail.gmail.com>
 <cd632f46-3d8c-87ec-332a-d8bb205f1c71@huawei.com>
 <CAOQ4uxhXDx9PcTVX1bGkn=b1g02zUQ3+=MC_b6sqLwGhoF21Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:5861 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750773AbdEDIgr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 May 2017 04:36:47 -0400
In-Reply-To: <CAOQ4uxhXDx9PcTVX1bGkn=b1g02zUQ3+=MC_b6sqLwGhoF21Xg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com, zhaohongjiang@huawei.com

On 2017/5/3 20:05, Amir Goldstein wrote:
> On Wed, May 3, 2017 at 2:25 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> on 2017/5/3 16:38, Amir Goldstein wrote:
>>> On Wed, May 3, 2017 at 10:39 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:

>>> I am interested in one specific use case of visible whiteouts in non-merge
>>> dir and that is the use case of a lower dir that has been deleted leaving
>>> upper with possible visible whiteouts.
>>>
>>> With some of my patches related to constant inode numbers, that use case
>>> could be fixed simply by replacing OVL_TYPE_MERGE in readdir.c with
>>> OVL_TYPE_COPYUP. Every dir that has *ever* been copied up is marked
>>> with an xattr overlay.origin, which may or may not be uptodate, but will
>>> forever indicate that this is a 'suspect impure' directory.
>>>
>>> My question is whether this solution is sufficient to cover your use cases
>>> and if not, where and how did those whiteouts get to your lower/upper
>>> impure directory?
>>>
>>> You patch does provide extra optimization for 'purifying' a 'suspect impure'
>>> directory, but:
>>> 1. Not sure if that optimization is that important.
>>> 2. Upcoming changes related to constant inode numbers will have to use
>>>     ovl_dir_read_merged() for 'suspect impure' dir, not only if that dir may
>>>     contain whiteouts, but also if that dir may contain copyups, namely files
>>>     with overlay.origin, which may need to report non-real d_ino.
>>>
>>
>>   I think there are three(or more) cases can cause this problem:
>>   1. Some one create whiteouts in lower/upper's single subdir manually(as my
>>      reproducer show) and then mount overlayfs;
>>   2. User create whiteouts in upper's opaque dir manualy and remount
>>      overlayfs.
>>      For example:
>>      mkdir -p low/dir up/dir work merge
>>      mount -t overlay -o lowerdir=low,upperdir=up,workdir=work overlayfs merge
>>      rm -rf merge/dir
>>      mkdir merge/dir
>>      umount merge
>>      mknod up/dir/aa c 0 0
>>      mount -t overlay -o lowerdir=low,upperdir=up,workdir=work overlayfs merge
>>      ls -l merge/dir
>>
>>         ls: cannot access merge/dir/aa: No such file or directory
>>         total 0
>>         c????????? ? ? ? ?            ? aa
>>
>>   3. User clean lower dir and remount overlayfs (as you interested in).
>>
>>   If we use OVL_TYPE_COPYUP in readdir.c, we can find out 'suspect impure'
>>   directory in the third case only, we still can not make sure dir have
>>   whiteout or not. Especially in the first case, we even haven't any
>>   information to deduce it's 'suspect' or not. (Am I miss something ?)
>>
> 
> Of course it is *possible* to hand craft use cases 1 and 2, but so what?
> I am asking for *your* use case. You must have a reason to propose this
> purification that is not a user hand crafted impure lower/upper, don't you?
> So I am asking of for your use case, OVL_TYPE_COPYUP is enough.
> If you need a test branch to test if OVL_TYPE_COPYUP
> answers your needs, I can prepare one for you.
> 

  Hi Amir:

  Thanks for your valuable time.

  I just found this problem inadvertently when I did some tests.
  Indeed, cases 1 and 2 may not happen unless user hand crafted, and
  I don't have these use cases.:)

  I saw your patches pushed to overlayfs-constino.v5 last night and V3.
  We can use OVL_TYPE_COPYUP to figure out dir that has *ever* been copied up,
  and use the merged flow in ovl_iterate() for these directories.

  I have another two idears, please assess:

  1. I think we can use an xattr 'overlay.whiteout' to count the whiteouts
     the OVL_TYPE_COPYUP dir have. We increase count in ovl_remove_and_whiteout()
     and decrease count in ovl_create_over_whiteout(), so we can make sure
     the dir have created whiteout or not more accurate.(is it necessary ?)

  2. Can we read underlying dir entry and get rid of whiteout every time for
     the 'impure' dircetory, not execute the merged flow ? It will save
     memory usage.

Thanks,
ZhangYi
