Return-Path: <SRS0=2h5r=7E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A831AC433E1
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 16:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 882FB2072C
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 16:33:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XX85PHO7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgEVQdR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 May 2020 12:33:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21647 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730474AbgEVQdP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 May 2020 12:33:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590165194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L4sy0ib9KEdvEVMUccLs1iu3r+olJXF2ra9ooHBixRc=;
        b=XX85PHO7/nZiZW4LcIq5AxX/Jhpj1PXBqOx637ofR+Y5RrPZodPXKtY/cxnqRep9Kf/3oV
        Qv9QqxzeHg37CFkb77HZqU1uvyS12bbs3zXKz0iMm+7LcFJL0rwLPdRt/Ww23LrfquQfWh
        imfYxJXeQUIVhYjstLO/NBr9dd6VrFk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-BiuN42cAM9WWEt3bi9jPDw-1; Fri, 22 May 2020 12:33:10 -0400
X-MC-Unique: BiuN42cAM9WWEt3bi9jPDw-1
Received: by mail-qv1-f71.google.com with SMTP id q4so11200264qve.19
        for <linux-unionfs@vger.kernel.org>; Fri, 22 May 2020 09:33:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L4sy0ib9KEdvEVMUccLs1iu3r+olJXF2ra9ooHBixRc=;
        b=rqP6m0k9vFAbfe3CU9qScVRB8a49N9/qNSi31zDKToRWewowtPS8g6/GkcqRkyqP2O
         hTNx+W4axHUnRQwdAkx6qUk1Odgm2Lo9OewQdeyV7ejuSP908oQ8v0gkP8MWnapcRETe
         KhwjDlrBwIdoPAq7q/QClqTaoScVuVMu1DcjD6EkDcwHjBdYeuhXsearPzZj0ZAQQLlI
         Jglu+XPMFUz+gLfHtP0xQh6pEzCZar1M4zCjL06H3NV6hNFeD7EAOa80jB4pH81ncooR
         4rE+CFzq0/LRnA9l1KoErK9agl2fatTikMC0/GcPDagWQTQBLL/WHDVam+6xmZ/RdSLD
         UpBg==
X-Gm-Message-State: AOAM533KMr0BQ3msVmFfm27pRX9cOWLOcNfg3vRNfppA7VvHfQAosSW9
        e7VQYtKQJcN/zQJLNMUgUy4UPkGfgdBuFHMSL2nO6cvfe4cNLg/UXpxgbCpJOEilLytWqGvedNm
        PlABDtTeMoxavth9c1/qh/ACGmEktyjKmFTtluLV4Vg==
X-Received: by 2002:a37:8187:: with SMTP id c129mr15675241qkd.211.1590165190418;
        Fri, 22 May 2020 09:33:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwan68PpwoXP+D6L8Pi8mUQ11pMuHqUW7nq4FeZkfYH5C3xdBN7yioropShBDXxBxctjj/0oxtD9IHE2Fx9vMw=
X-Received: by 2002:a37:8187:: with SMTP id c129mr15675212qkd.211.1590165190105;
 Fri, 22 May 2020 09:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200522085723.29007-1-mszeredi@redhat.com> <20200522160815.GT23230@ZenIV.linux.org.uk>
In-Reply-To: <20200522160815.GT23230@ZenIV.linux.org.uk>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Fri, 22 May 2020 18:32:59 +0200
Message-ID: <CAOssrKcpQwYh39JpcNmV3JiuH2aPDJxgT5MADQ9cZMboPa9QaQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: make private mounts longterm
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 22, 2020 at 6:08 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Fri, May 22, 2020 at 10:57:23AM +0200, Miklos Szeredi wrote:
> > Overlayfs is using clone_private_mount() to create internal mounts for
> > underlying layers.  These are used for operations requiring a path, such as
> > dentry_open().
> >
> > Since these private mounts are not in any namespace they are treated as
> > short term, "detached" mounts and mntput() involves taking the global
> > mount_lock, which can result in serious cacheline pingpong.
> >
> > Make these private mounts longterm instead, which trade the penalty on
> > mntput() for a slightly longer shutdown time due to an added RCU grace
> > period when putting these mounts.
> >
> > Introduce a new helper kern_unmount_many() that can take care of multiple
> > longterm mounts with a single RCU grace period.
>
> Umm...
>
> 1) Documentation/filesystems/porting - something along the lines
> of "clone_private_mount() returns a longterm mount now, so the proper
> destructor of its result is kern_unmount()"
>
> 2) the name kern_unmount_many() has an unfortunate clash with
> fput_many(), with arguments that look similar and mean something
> entirely different.  How about kern_unmount_array()?
>
> 3)
> > -     mntput(ofs->upper_mnt);
> > -     for (i = 1; i < ofs->numlayer; i++) {
> > -             iput(ofs->layers[i].trap);
> > -             mntput(ofs->layers[i].mnt);
> > +
> > +     if (!ofs->layers) {
> > +             /* Deal with partial setup */
> > +             kern_unmount(ofs->upper_mnt);
> > +     } else {
> > +             /* Hack!  Reuse ofs->layers as a mounts array */
> > +             struct vfsmount **mounts = (struct vfsmount **) ofs->layers;
> > +
> > +             for (i = 0; i < ofs->numlayer; i++) {
> > +                     iput(ofs->layers[i].trap);
> > +                     mounts[i] = ofs->layers[i].mnt;
> > +             }
> > +             kern_unmount_many(mounts, ofs->numlayer);
> > +             kfree(ofs->layers);
>
> That's _way_ too subtle.  AFAICS, you rely upon ->upper_mnt == ->layers[0].mnt,
> ->layers[0].trap == NULL, without even mentioning that.  And the hack you do
> mention...  Yecchhh...  How many layers are possible, again?

500, mounts array would fit inside a page and a page can be allocated
with __GFP_NOFAIL. But why bother?  It's not all that bad, is it?

Thanks,
Miklos

