From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 03/23] ovl: store layer index in ovl_layer
Date: Fri, 5 Jan 2018 07:05:45 +0200
Message-ID: <CAOQ4uxjwQ++dQT0w6cVq+BZv3d2cjPvdLLenCAqx-CdSnp3h1g@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-4-git-send-email-amir73il@gmail.com> <20180104210018.GB2808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:38042 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751267AbeAEFFq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jan 2018 00:05:46 -0500
Received: by mail-yb0-f195.google.com with SMTP id 129so1485266ybe.5
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 21:05:46 -0800 (PST)
In-Reply-To: <20180104210018.GB2808@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 4, 2018 at 11:00 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Jan 04, 2018 at 06:39:58PM +0200, Amir Goldstein wrote:
>> Store the fs root layer index inside ovl_layer struct, so we can
>> get the root fs layer index from merge dir lower layer instead of
>> find it with ovl_find_layer() helper.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/namei.c     | 17 +----------------
>>  fs/overlayfs/ovl_entry.h |  2 ++
>>  fs/overlayfs/super.c     |  1 +
>>  3 files changed, 4 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> index 71db9a966d88..a48ee02c4524 100644
>> --- a/fs/overlayfs/namei.c
>> +++ b/fs/overlayfs/namei.c
>> @@ -572,18 +572,6 @@ int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
>>       return (idx < oe->numlower) ? idx + 1 : -1;
>>  }
>>
>> -static int ovl_find_layer(struct ovl_fs *ofs, struct ovl_path *path)
>> -{
>> -     int i;
>> -
>> -     for (i = 0; i < ofs->numlower; i++) {
>> -             if (ofs->lower_layers[i].mnt == path->layer->mnt)
>> -                     break;
>> -     }
>> -
>> -     return i;
>> -}
>> -
>>  /* Fix missing 'origin' xattr */
>>  static int ovl_fix_origin(struct dentry *dentry, struct dentry *lower,
>>                         struct dentry *upper)
>> @@ -733,11 +721,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>>
>>               if (d.redirect && d.redirect[0] == '/' && poe != roe) {
>>                       poe = roe;
>> -
>>                       /* Find the current layer on the root dentry */
>> -                     i = ovl_find_layer(ofs, &lower);
>> -                     if (WARN_ON(i == ofs->numlower))
>> -                             break;
>> +                     i = lower.layer->idx - 1;
>>               }
>>       }
>>
>> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>> index 9d0bc03bf6e4..608e48755070 100644
>> --- a/fs/overlayfs/ovl_entry.h
>> +++ b/fs/overlayfs/ovl_entry.h
>> @@ -22,6 +22,8 @@ struct ovl_config {
>>  struct ovl_layer {
>>       struct vfsmount *mnt;
>>       dev_t pseudo_dev;
>> +     /* Index of this layer in fs root (upper == 0) */
>> +     int idx;
>
> Just curious. If we are stroing idx, then do we have to store ovl_layer
> and every ovl_entry. Just idx can give us the position and we should
> be able to then access mnt and pseudo_dev directly from
> ofs->lower_layers[idx]. If yes, we can avoid storing vfsmount and
> pseudo_dev per dentry.
>

But we are not storing vfsmount and pseudo_dev per dentry
We are storing &ofs->lower_layers[idx] per dentry.
Do we gain anything from storing the idx instead?
Most of the times code needs to access ofs->lower_layers[idx]
fields (mnt mostly).
The cases where idx itself matter are rare, for example:
if dentry has numlower == 1 and idx > 1, this is a quick indication
that a parent of lower dir may be copied up but not be indexed
(because a dir on top of it in layer 1 is indexed).

The current series does not make use of the example above,
but it can be used to relax copy up of dir on encode when
lower idx == 1.

Amir.
