From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix visible whiteout on not merged dir
Date: Thu, 4 May 2017 12:03:12 +0300
Message-ID: <CAOQ4uxgkeFwSNy9cHfTyXbfBJymfB6-KORtSyjFhGVkX2awd1w@mail.gmail.com>
References: <1493797155-43637-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxiiVxZt+bQ-vo7QAekm8KP51uGx87h=hyYVRRLfyyNySA@mail.gmail.com>
 <cd632f46-3d8c-87ec-332a-d8bb205f1c71@huawei.com> <CAOQ4uxhXDx9PcTVX1bGkn=b1g02zUQ3+=MC_b6sqLwGhoF21Xg@mail.gmail.com>
 <580c8b09-1d3c-94d6-4d07-2a4a21a2dc59@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34133 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750773AbdEDJDO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 May 2017 05:03:14 -0400
Received: by mail-io0-f179.google.com with SMTP id k91so14265412ioi.1
        for <linux-unionfs@vger.kernel.org>; Thu, 04 May 2017 02:03:13 -0700 (PDT)
In-Reply-To: <580c8b09-1d3c-94d6-4d07-2a4a21a2dc59@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com, zhaohongjiang@huawei.com

On Thu, May 4, 2017 at 11:36 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:

>   Hi Amir:
>
>   Thanks for your valuable time.
>
>   I just found this problem inadvertently when I did some tests.
>   Indeed, cases 1 and 2 may not happen unless user hand crafted, and
>   I don't have these use cases.:)

That's what I thought.

>
>   I saw your patches pushed to overlayfs-constino.v5 last night and V3.
>   We can use OVL_TYPE_COPYUP to figure out dir that has *ever* been copied up,
>   and use the merged flow in ovl_iterate() for these directories.
>

Yes, but keep in mind that OVL_TYPE_COPYUP from v3 did not make it into v5
and it's not trivial to add it back.

After I rebase my OVL_TYPE_COPYUP patches over v5 I'll make the patch
to replace is_real = !OVL_TYPE_MERGE() with !OVL_TYPE_COPYUP()
and let you know so you can test it.

>   I have another two ideas, please assess:
>
>   1. I think we can use an xattr 'overlay.whiteout' to count the whiteouts
>      the OVL_TYPE_COPYUP dir have. We increase count in ovl_remove_and_whiteout()
>      and decrease count in ovl_create_over_whiteout(), so we can make sure
>      the dir have created whiteout or not more accurate.(is it necessary ?)

It's not going to be easy to update overlay.whiteout 'atomically',
because you need to update it either before or after creating/removing
whiteout and both possibilities can get it out of sync.

A simpler optimization would be to set an 'overlay.impure' xattr on a directory
*before* creating the first whiteout AND before creating/moving a COPYUP object
into the dir (so only creating uppers leave the upper dir pure).

So there is no process of purifying a dir, but an upper dir is pure until proven
otherwise by ovl_set_dir_impure() (or by finding 'overlay.impure').

With that optimization, we can set:
is_real = !OVL_TYPE_MERGE() && !ovl_dir_impure();

very similar to your suggestion (but with a twist)

For my use case (lower dirs can disappear underneath) this sort of
optimization can be useful.

>
>   2. Can we read underlying dir entry and get rid of whiteout every time for
>      the 'impure' dircetory, not execute the merged flow ? It will save
>      memory usage.
>

Did not understand this questions.

Cheers,
Amir.
