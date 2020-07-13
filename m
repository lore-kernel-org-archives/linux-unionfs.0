Return-Path: <SRS0=r5kD=AY=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1472FC433E1
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 06:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E13FC2068F
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 06:06:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="akpGzdPM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgGMGG5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 02:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgGMGG5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jul 2020 02:06:57 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2109EC061794
        for <linux-unionfs@vger.kernel.org>; Sun, 12 Jul 2020 23:06:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g67so5573431pgc.8
        for <linux-unionfs@vger.kernel.org>; Sun, 12 Jul 2020 23:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JCrZkMen5Y8Qgl3RYtWnjJuqoYHVIL9ulhjpx91u9D0=;
        b=akpGzdPMCISLashwKFZSn3QNRrzBIhWaFNaBAY+iF3UTuPx3LddW7U+aWVY++e19m/
         31P3Ev1EJuf8msF3IrN8zwQromSVl6zRexsCvvAzNW2hL1NBRxOhQMw6CE2aYzzU4/CY
         E4RXdpr++iTxK7X7Shp+t+9b8CEvMTLYP6HrNIALlf5uMEevPXbb5svlZ5o01EElQZrG
         Q1S7+WEiKY1yLImIbdF6MlHOHofZYCsmJszx0oovaOxtFQ4rsddfWRZsRx1e+/mOjXuQ
         5oEimF8imsyOyAWx3OGY5JmUdnqctBc6w3MfpYYSJV26DgcCZB+5yNQCkMaecGjywzbC
         5RNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JCrZkMen5Y8Qgl3RYtWnjJuqoYHVIL9ulhjpx91u9D0=;
        b=ONHbPnrMkElHMuG1xqrZbwlDFykY2n32sTj3k+8vasUcbmky3byBiPkfBEbKIguVf6
         FCX65UBJhk7mzJrYHENAIK/efPNgf7UeBacriS0Xky5Hk3IQfDlwMBCQXSQMXUeFtlgy
         2JExM9YnJC9Or6wXdv2r/QcADbnwZUm5CdMZQNMqz96G1wfNTMCZwnLosrhgRe7ngSzz
         zrYnXAYFU3m0EDsTP0nR47Ucjdo2Wa3QR9H1PHBbosVxUr4CeUdF/514XjyiB0HML57q
         yqsbgAJe6DnvSV4U3Sj1t1jXUDjx2+cNuP1XBN2+uEfOkCwW1Gkv69LXJcCy6DjeQLFr
         JutQ==
X-Gm-Message-State: AOAM533kuaFhPrTcUcBrmwqAn4zRzn6SJGctsFp6LUdPq2x571mevagV
        9AkITSRWNLQQJnT14qnHdxor0LK2
X-Google-Smtp-Source: ABdhPJyrA+nXvLKNHn/PGC6tm4QXKFb6Ajpzt8Bm4OfoIStXbK5vKKZwQYgdrlfipozxgFYzswcJnw==
X-Received: by 2002:a63:4419:: with SMTP id r25mr59829676pga.198.1594620416644;
        Sun, 12 Jul 2020 23:06:56 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m3sm15078047pfk.171.2020.07.12.23.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 23:06:56 -0700 (PDT)
Date:   Mon, 13 Jul 2020 14:06:48 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Murphy Zhou <jencce.kernel@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH] ovl: fix oops in ovl_indexdir_cleanup() with
 nfs_export=on
Message-ID: <20200713060648.4f663ajxsfk6ycis@xzhoux.usersys.redhat.com>
References: <20200621063759.15497-1-amir73il@gmail.com>
 <CAOQ4uxh203q=t98GV_+2FSAo1oEVmJPjP1CfhSAqY0cO_moAjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh203q=t98GV_+2FSAo1oEVmJPjP1CfhSAqY0cO_moAjQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Copying Miklos' another email.

On Mon, Jul 06, 2020 at 03:15:06PM +0300, Amir Goldstein wrote:
> On Sun, Jun 21, 2020 at 9:38 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Mounting with nfs_export=on, xfstests overlay/031 triggers a kernel panic
> > since v5.8-rc1 overlayfs updates.
> 
> Ping.
> 
> This is a kernel OOPS regression in v5.8-rc1.
> 
> Push tested branch ovl-fixes based on v5.8-rc3 with this change.
> It contains two other non-critical fixes, which are pretty obvious,
> so you may want to consider taking them as well.
> 
> Thanks,
> Amir.
> 
> >
> >  overlayfs: orphan index entry (index/00fb1..., ftype=4000, nlink=2)
> >  BUG: kernel NULL pointer dereference, address: 0000000000000030
> >  RIP: 0010:ovl_cleanup_and_whiteout+0x28/0x220 [overlay]
> >
> > Bisect point at commit c21c839b8448 ("ovl: whiteout inode sharing")
> >
> > Minimal reproducer:
> > --------------------------------------------------
> > rm -rf l u w m
> > mkdir -p l u w m
> > mkdir -p l/testdir
> > touch l/testdir/testfile
> > mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
> > echo 1 > m/testdir/testfile
> > umount m
> > rm -rf u/testdir
> > mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
> > umount m
> > --------------------------------------------------
> >
> > When mount with nfs_export=on, and fail to verify an orphan index, we're
> > cleaning this index from indexdir by calling ovl_cleanup_and_whiteout().
> > This dereferences ofs->workdir, that was earlier set to NULL.
> >
> > The design was that ovl->workdir will point at ovl->indexdir, but we are
> > assigning ofs->indexdir to ofs->workdir only after ovl_indexdir_cleanup().
> > There is no reason not to do it sooner, because once we get success from
> > ofs->indexdir = ovl_workdir_create(... there is no turning back.
> >
> > Reported-and-tested-by: Murphy Zhou <jencce.kernel@gmail.com>
> > Fixes: commit c21c839b8448 ("ovl: whiteout inode sharing")
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/super.c | 16 +++++++---------
> >  1 file changed, 7 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 91476bc422f9..15939ab39c1c 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -1354,6 +1354,12 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
> >
> >         ofs->indexdir = ovl_workdir_create(ofs, OVL_INDEXDIR_NAME, true);
> >         if (ofs->indexdir) {
> > +               /* index dir will act also as workdir */
> > +               iput(ofs->workdir_trap);
> > +               ofs->workdir_trap = NULL;
> > +               dput(ofs->workdir);
> > +               ofs->workdir = dget(ofs->indexdir);
> > +
> >                 err = ovl_setup_trap(sb, ofs->indexdir, &ofs->indexdir_trap,
> >                                      "indexdir");
> >                 if (err)
> > @@ -1843,20 +1849,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >                 sb->s_flags |= SB_RDONLY;
> >
> >         if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
> > -               /* index dir will act also as workdir */
> > -               dput(ofs->workdir);
> > -               ofs->workdir = NULL;
> > -               iput(ofs->workdir_trap);
> > -               ofs->workdir_trap = NULL;
> > -
> >                 err = ovl_get_indexdir(sb, ofs, oe, &upperpath);
> >                 if (err)
> >                         goto out_free_oe;
> >
> >                 /* Force r/o mount with no index dir */
> > -               if (ofs->indexdir)
> > -                       ofs->workdir = dget(ofs->indexdir);
> > -               else
> > +               if (!ofs->indexdir)
> >                         sb->s_flags |= SB_RDONLY;
> >         }
> >
> > --
> > 2.17.1
> >

-- 
Murphy
