From: zhangyi <yizhang089@gmail.com>
Subject: Re: [PATCH] ovl: fix inconsistent d_ino for merge dir
Date: Sun, 31 Dec 2017 14:11:04 +0800
Message-ID: <4d71f377-6b52-7be3-9271-298543c4a2b2@gmail.com>
References: <20171230074915.33685-1-yi.zhang@huawei.com>
 <CAOQ4uxjt6+UuSbWoACRsFbpstJVuRJGJgby_DqbqJfEJBk6odw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38607 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbdLaGLK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 31 Dec 2017 01:11:10 -0500
Received: by mail-pf0-f193.google.com with SMTP id u25so23612158pfg.5
        for <linux-unionfs@vger.kernel.org>; Sat, 30 Dec 2017 22:11:10 -0800 (PST)
In-Reply-To: <CAOQ4uxjt6+UuSbWoACRsFbpstJVuRJGJgby_DqbqJfEJBk6odw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On 2017/12/30 17:51, Amir Goldstein Wrote:

> On Sat, Dec 30, 2017 at 9:49 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Current ovl_getattr() (stat(2)) return lower's d_ino for merge
>> directory (No any extended attribute) but ovl_iterate()
>> (getdents(2)) return upper's d_ino.
>>
>> This patch correct inconsistent d_ino for this case, change to
>> return lower's d_ino in ovl_iterate() for merge dir.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>   fs/overlayfs/readdir.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
>> index 8c98578..9548712 100644
>> --- a/fs/overlayfs/readdir.c
>> +++ b/fs/overlayfs/readdir.c
>> @@ -136,6 +136,11 @@ static bool ovl_calc_d_ino(struct ovl_readdir_data *rdd,
>>              ovl_test_flag(OVL_IMPURE, d_inode(rdd->dentry)))
>>                  return true;
>>
>> +       /* Recalc d_ino for all dir in merge dir (contains merge subdirs) */
>> +       if (p->type == DT_DIR &&
>> +           OVL_TYPE_MERGE(ovl_path_type(rdd->dentry)))
> Why only subdirs and not files with origin?
> This is a partial fix and I think Miklos has rejected a similar fix by Chandan
> and said that this should be fixed by a future fsck.overlay (hint hint).
> The inconsistency is that the directory contains origin (and merge subdir)
> and is not marked "impure". That is what fsck.overlay needs to fix and then
> "Recalc d_ino for for all entries if dir is impure (contains copied up entries)"
> will do the right thing.
>
I understand the inconsistency of missing impure xattr should be fixed 
by fsck.overlay,
but the case of this patch want to fix is not this one.

It's for the case of newly created overlay image. There is no origin 
xattr for the merge
subdir and no impure xattr for it's parent, and there is also no 
requirement that user
should run fsck.overlay before first mount.

eg (a simplest situation):
# mkdir lower upper work merge
# mkdir lower/dir upper/dir
# mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work 
merge
# stat -c "%i" merge/dir/
389572
# getdents merge | grep dir                     (getdents is program 
list in getdents(2))
389573  directory    16          2  dir

I think if we set origin for merge dir and set impure for it's parent in 
ovl_lookup() can also
fix this problem.

Thanks,
Yi.
