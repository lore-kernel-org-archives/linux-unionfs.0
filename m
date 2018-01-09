From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 03/23] ovl: store layer index in ovl_layer
Date: Tue, 9 Jan 2018 09:36:40 +0100
Message-ID: <CAJfpegsSKXQWH_6zhbufFBFeLG_6F=NfzxHKQASpcneVnMEjEw@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-4-git-send-email-amir73il@gmail.com> <20180104210018.GB2808@redhat.com>
 <CAOQ4uxjwQ++dQT0w6cVq+BZv3d2cjPvdLLenCAqx-CdSnp3h1g@mail.gmail.com> <CAOQ4uxhiSryHmVtRyVCeJPDMbm-9nFqv878VBTz-cUDbbw-A3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:41649 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751374AbeAIIgl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 03:36:41 -0500
Received: by mail-qt0-f193.google.com with SMTP id i40so16876488qti.8
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 00:36:41 -0800 (PST)
In-Reply-To: <CAOQ4uxhiSryHmVtRyVCeJPDMbm-9nFqv878VBTz-cUDbbw-A3g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jan 5, 2018 at 12:22 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Jan 5, 2018 at 7:05 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, Jan 4, 2018 at 11:00 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>> On Thu, Jan 04, 2018 at 06:39:58PM +0200, Amir Goldstein wrote:
>>>> Store the fs root layer index inside ovl_layer struct, so we can
>>>> get the root fs layer index from merge dir lower layer instead of
>>>> find it with ovl_find_layer() helper.
>>>>
>>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>>> ---
>>>>  fs/overlayfs/namei.c     | 17 +----------------
>>>>  fs/overlayfs/ovl_entry.h |  2 ++
>>>>  fs/overlayfs/super.c     |  1 +
>>>>  3 files changed, 4 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>>>> index 71db9a966d88..a48ee02c4524 100644
>>>> --- a/fs/overlayfs/namei.c
>>>> +++ b/fs/overlayfs/namei.c
>>>> @@ -572,18 +572,6 @@ int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
>>>>       return (idx < oe->numlower) ? idx + 1 : -1;
>>>>  }
>>>>
>>>> -static int ovl_find_layer(struct ovl_fs *ofs, struct ovl_path *path)
>>>> -{
>>>> -     int i;
>>>> -
>>>> -     for (i = 0; i < ofs->numlower; i++) {
>>>> -             if (ofs->lower_layers[i].mnt == path->layer->mnt)
>>>> -                     break;
>>>> -     }
>>>> -
>>>> -     return i;
>>>> -}
>>>> -
>>>>  /* Fix missing 'origin' xattr */
>>>>  static int ovl_fix_origin(struct dentry *dentry, struct dentry *lower,
>>>>                         struct dentry *upper)
>>>> @@ -733,11 +721,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>>>>
>>>>               if (d.redirect && d.redirect[0] == '/' && poe != roe) {
>>>>                       poe = roe;
>>>> -
>>>>                       /* Find the current layer on the root dentry */
>>>> -                     i = ovl_find_layer(ofs, &lower);
>>>> -                     if (WARN_ON(i == ofs->numlower))
>>>> -                             break;
>>>> +                     i = lower.layer->idx - 1;
>>>>               }
>>>>       }
>>>>
>>>> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>>>> index 9d0bc03bf6e4..608e48755070 100644
>>>> --- a/fs/overlayfs/ovl_entry.h
>>>> +++ b/fs/overlayfs/ovl_entry.h
>>>> @@ -22,6 +22,8 @@ struct ovl_config {
>>>>  struct ovl_layer {
>>>>       struct vfsmount *mnt;
>>>>       dev_t pseudo_dev;
>>>> +     /* Index of this layer in fs root (upper == 0) */
>>>> +     int idx;
>>>
>>> Just curious. If we are stroing idx, then do we have to store ovl_layer
>>> and every ovl_entry. Just idx can give us the position and we should
>>> be able to then accessovl_find_layer mnt and pseudo_dev directly from
>>> ofs->lower_layers[idx]. If yes, we can avoid storing vfsmount and
>>> pseudo_dev per dentry.
>>>
>>
>> But we are not storing vfsmount and pseudo_dev per dentry
>> We are storing &ofs->lower_layers[idx] per dentry.
>> Do we gain anything from storing the idx instead?

We could go to 16bit index and decrease memory requirement of
ofs->lower_layers by 75% on 64bit archs.

Probably not worth it, though, since very few entries will have a
large enough layers to matter in most situations, I guess.

Also, someone might want >64k layers, although that really stretches
the limits of current implementation.

Thanks,
Miklos
