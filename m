From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix visible whiteout on not merged dir
Date: Thu, 4 May 2017 16:13:35 +0300
Message-ID: <CAOQ4uxjbEs4Be+Ce3kQmTZWRP5XsZ+utUYm7crf0j7bgrELm2w@mail.gmail.com>
References: <1493797155-43637-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxiiVxZt+bQ-vo7QAekm8KP51uGx87h=hyYVRRLfyyNySA@mail.gmail.com>
 <cd632f46-3d8c-87ec-332a-d8bb205f1c71@huawei.com> <CAOQ4uxhXDx9PcTVX1bGkn=b1g02zUQ3+=MC_b6sqLwGhoF21Xg@mail.gmail.com>
 <580c8b09-1d3c-94d6-4d07-2a4a21a2dc59@huawei.com> <CAOQ4uxgkeFwSNy9cHfTyXbfBJymfB6-KORtSyjFhGVkX2awd1w@mail.gmail.com>
 <9ac40576-fb08-6529-706f-6dd4de772257@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35287 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbdEDNNg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 May 2017 09:13:36 -0400
Received: by mail-io0-f194.google.com with SMTP id v34so3625456iov.2
        for <linux-unionfs@vger.kernel.org>; Thu, 04 May 2017 06:13:36 -0700 (PDT)
In-Reply-To: <9ac40576-fb08-6529-706f-6dd4de772257@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com, zhaohongjiang@huawei.com

On Thu, May 4, 2017 at 3:10 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> On 2017/5/4 17:03, Amir Goldstein wrote:
>> On Thu, May 4, 2017 at 11:36 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>
>>>   2. Can we read underlying dir entry and get rid of whiteout every time for
>>>      the 'impure' dircetory, not execute the merged flow ? It will save
>>>      memory usage.
>>>
>> Did not understand this questions.
>>
>
> Sorry, I didn't make it clear. I mean if we set is_real = !OVL_TYPE_COPYUP()
> or is_real = !OVL_TYPE_MERGE() && !ovl_dir_impure() (with optimization),
> it will create ovl_dir_cache and ovl_cache_entry when we read COPYUP directory
> or 'impure' dircetory in ovl_iterate() flow (as merged dir does). This will
> cause bloated memory usage and some performance overhead, because this dir
> is only exist in one layer(not merged), so I think it's don't need ovl_dir_cache.
> (cost too much ?)

Does it though? cache is released when dir fd is closed.

>
> Can we find a way to avoid cache use, I find two ways(maybe too complex):
> 1. Make a wapper ovl_iterate_dir_impure(), it read the underlaying dir entry
>    and get rid of whiteout entry, and use this function to deal the COPYUP or
>    or 'impure' branch in ovl_iterate() like follow example:
>

This is interesting. It does cost a bit more to iterate with whiteout filter
like this because it requires getattr() while iterating char devices, but that's
not so bad I guess.
Filtering COPYUP like this is going to be more expensive.

> static int ovl_iterate(struct file *file, struct dir_context *ctx)
>
>         if (od->is_real)
>                 return iterate_dir(od->realfile, ctx);
> +       else if (!OVL_TYPE_MERGE && COPYUP)
> +               return ovl_iterate_dir_impure(od->realfile, ctx);
>
> 2. Add a flag in struct dir_context, let underlying filesystem to return what we
>    want to read, like follow example:
>
> #define DIR_CONTEXT_HIDE_WHITEOUT  (1 << 0)
>
> struct dir_context {
>         const filldir_t actor;
> +       unsigned int flag;
>         loff_t pos;
> };
>
> static int ovl_iterate(struct file *file, struct dir_context *ctx)
>
>         if (od->is_real)   /* is_real = !OVL_TYPE_MERGE() */
>                 return iterate_dir(od->realfile, ctx);
>
> And then let underlying filesystem deal with DIR_CONTEXT_HIDE_WHITEOUT
> flag. If take on this solution, we can cover all cases, OVL_TYPE_COPYUP
> and pure check are also not required. It changes too greate, but has
> a good expansibility (flag can be used by other demand in the future).
>

I wish filesystems would be so pleased to make these changes for overlayfs
it's less likely that you can get far with this idea ;-)

Amir.
