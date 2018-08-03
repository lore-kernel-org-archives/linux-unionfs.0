Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:10628 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726343AbeHCNsy (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Aug 2018 09:48:54 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 670F558D520EF
        for <linux-unionfs@vger.kernel.org>; Fri,  3 Aug 2018 19:52:52 +0800 (CST)
Subject: Re: [RFC PATCH v2 5/9] ovl: add redirect dir feature when set
 redirect xattr to dir
References: <20180731093727.26855-1-yi.zhang@huawei.com>
 <20180731093727.26855-6-yi.zhang@huawei.com>
 <CAOQ4uxgwUnna5zs1n2S9UkHKv4wH1n0QA-96kSsTJ+iDiah8gQ@mail.gmail.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <3d2b993b-6046-784a-765a-c5fd65adcc10@huawei.com>
Date: Fri, 3 Aug 2018 19:52:46 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgwUnna5zs1n2S9UkHKv4wH1n0QA-96kSsTJ+iDiah8gQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On 2018/8/1 19:03, Amir Goldstein Wrote:
> On Tue, Jul 31, 2018 at 12:37 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Redirect dir feature is backward incompatible because old kernel (which
>> not support this feature) may corrupt the merge relationship between
>> directories when change the directory which have redirect xattr.
>>
>> This patch check and set the upper layer's redirect dir feature when
>> kernel set redirect xattr to directory in the upper layer.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>  fs/overlayfs/dir.c       | 11 +++++++++++
>>  fs/overlayfs/overlayfs.h |  5 ++++-
>>  2 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>> index f480b1a2cd2e..238999e5f47b 100644
>> --- a/fs/overlayfs/dir.c
>> +++ b/fs/overlayfs/dir.c
>> @@ -969,6 +969,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>>         bool is_dir = d_is_dir(old);
>>         bool new_is_dir = d_is_dir(new);
>>         bool samedir = olddir == newdir;
>> +       struct ovl_fs* ofs = old->d_sb->s_fs_info;
>>         struct dentry *opaquedir = NULL;
>>         const struct cred *old_cred = NULL;
>>         LIST_HEAD(list);
>> @@ -1061,6 +1062,16 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>>                 }
>>         }
>>
>> +       if ((is_dir && ovl_type_merge_or_lower(old)) ||
>> +           (!overwrite && new_is_dir && ovl_type_merge_or_lower(new))) {
>> +               /*
>> +                * Set redirect dir feature to the upper root dir if this
>> +                * feature doesn't exist.
>> +                */
>> +               if (!ovl_has_feature_redirect_dir(ofs->upper_layer))
>> +                       err = ovl_set_feature_redirect_dir(ofs);
>> +       }
>> +
> 
> Please just place a call to  ovl_set_feature_redirect_dir(ofs)
> inside ovl_set_redirect(). There is no need to check all those
> conditions.
> Also, there is no need to check ovl_has_feature_redirect_dir()
> as ovl_set_feature() already checks for existing bit.
>

I understand check those condition is not perfect, but place it
to ovl_set_redirect() will lead to inode AA dead lock if the
parent dir of the renamed dir is the upper root dir, because
lock_rename() and vfs_setxattr() will get the same inode lock.

ovl_rename()
  ->lock_rename(upperdir)   //get the upper root inode lock
  ->ovl_set_redirect()
    ->ovl_set_feature_redirect_dir()
      ->vfs_setxattr(upperdir)  //dead lock in inode_lock()

Thanks,
Yi.

