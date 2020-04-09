Return-Path: <SRS0=VDYA=5Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F08E8C2BA2B
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 13:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B464F2078E
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 13:33:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KsuRzrty"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgDINdS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:33:18 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:43555 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgDINdS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Apr 2020 09:33:18 -0400
Received: by mail-il1-f196.google.com with SMTP id z12so2131626ilb.10
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Apr 2020 06:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hI40aefIq/yYzrf3uHd9QZG24JtEjZkmwFEWydw6eik=;
        b=KsuRzrty8sxDMOz8xtueysByBh5y8+xKear8a22fQK+BuH8TRT2pWVs8qYWuy4F2fm
         egQEFIcV7HfIndIQ1J4CcPSDgOYqU+4169pDcIieCAPiPzVTi4SCw1pLFAah2vugSBTk
         SKBsr1d3tb8nJp1VqD2mOfBBIiucIXMOuCE7sm12SPXfuKOn3hwMazSzQdIoFc+ZTx9V
         2Dcd5q2dEWd42IkAJeCyyHj2k46snlaM0s0LH89J2WSYM3HQ+1NqG+pCinZNISO3RCj/
         4wZFf4sFw7+Rf0odtDbFB28rafad37NGxXOhdwE5IDWOboyeO26tFrwor2fENcOIFo4b
         8vrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hI40aefIq/yYzrf3uHd9QZG24JtEjZkmwFEWydw6eik=;
        b=GyWyvoGeoAOHC4RN+DzRjJj/BKSmzqRupnVt6tB4aBs3NBNSn05a60WDLOO0oqHt2K
         zGlUn6Y2lpFa4apX0niyCJveoa6fJ927ItFz6kQv//cSh6GxlF6S1A6+0GKgRiTt4h8s
         PJPZx5Ec9svEAZfg9t8yPpZIccH1/Xb7Ko7cLJHQmiel0jfEMvzuxDp0tJNlK1XtS7j5
         VU605Ezx53iOYdq9UM5tskes27FTUENM92AcUYwQvcBs4cssA/PRBJdi7t2V8HN+hxln
         NTcmTu50L7QX28VKUKZvT1Zw+HA691j2cY0dQa60tNTw+il6H1+siLFUSwtcUClNZryV
         IRHw==
X-Gm-Message-State: AGi0PuaLA7YQGl87k90nWHxAJGWuMexDLFKD7SHl0myt0JshE8YYq6qQ
        HKNB54QME/4nEUPHRMnx+b2nPVx1XdXi0wLN4KYjIQ==
X-Google-Smtp-Source: APiQypISzxrqvzhJzOI7I4Pubqw2nmlJXTi6yy/CZ+S5RzJuAUCfSp13HdREe/WrHn/drrAb4fs6dLO1f0UR/gr5UC0=
X-Received: by 2002:a92:7303:: with SMTP id o3mr13204200ilc.275.1586439198402;
 Thu, 09 Apr 2020 06:33:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200403064444.31062-1-cgxu519@mykernel.net> <CAOQ4uxi8eMWRc6uuNt_R9nS9UjrOsqupcCEST4ub-kCwEpx=_Q@mail.gmail.com>
 <17153e5b537.c827c90942921.7568518513045332175@mykernel.net>
 <CAOQ4uxiHwQ4_rGLZeKS8VwP84YoUDZcju76KeYugt+SOAKVGKQ@mail.gmail.com>
 <17153f590e5.13f80af2342991.2831629093514707476@mykernel.net>
 <CAOQ4uxjhfOXaHMaXY+J67winJzFMDVfiHfF4m=yed7XNcPvFUw@mail.gmail.com>
 <171578e6477.12630feab161.147743050045149370@mykernel.net>
 <CAOQ4uxhU-KC2Yiewso_rDa3HhafzBaVWk9i8Sra4W0Y_EEiShA@mail.gmail.com>
 <1715deb04cf.11a7e625f2245.4913788754434070520@mykernel.net>
 <CAOQ4uxgQZf+RYsHAKY2=298nmRpBv5-YQDzuOqcXXOFumK058g@mail.gmail.com> <54ff2e61-422a-224a-7474-972bd154d844@huawei.com>
In-Reply-To: <54ff2e61-422a-224a-7474-972bd154d844@huawei.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 9 Apr 2020 16:33:07 +0300
Message-ID: <CAOQ4uxjoiuysjGHaxrW=ZdLxSDgt2JPy-u8Lh+xY+_5xKfry+A@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: sharing inode with different whiteout files
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 9, 2020 at 4:25 PM zhangyi (F) <yi.zhang@huawei.com> wrote:
>
> Hi, Amir
>
> On 2020/4/9 19:21, Amir Goldstein wrote:
> [...]
> >
> > Thanks for taking the time to report all those failures.
> > You must be one of few developers to actually use fsck.overlayfs...
> >
> > You need this fix for fsck.overlayfs:
> > https://github.com/hisilicon/overlayfs-progs/pull/1
> >
> > Sorry, I forgot I was carrying this patch on my setup.
> >
> > Zhangyi,
> >
> > Any chance of merging my fix?
> >
>
> Thanks for the patch, I think we'd better to remove the FS_LAYER_XATTR flag

I have no idea why I set this flag. It was a long time ago...
It really doesn't make sense and does not match what commit message says.

> for a nested overlayfs layer, so we could skip checking OVL_XATTR_PREFIX
> xattrs when scanning the layer. Something like this,
>
> +       /* A nested overlayfs does not support OVL_XATTR_PREFIX xattr */
> +       if (statfs.f_type == OVERLAYFS_SUPER_MAGIC)
> +               return 0;
>
> I will modify this and merge your patch.
>

Thanks,
Amir.
