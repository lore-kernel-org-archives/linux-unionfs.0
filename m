Return-Path: <SRS0=voRt=7G=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678B8C433DF
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 May 2020 10:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 336E32077D
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 May 2020 10:29:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pwC91qRE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgEXK27 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 24 May 2020 06:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgEXK27 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 24 May 2020 06:28:59 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB208C061A0E
        for <linux-unionfs@vger.kernel.org>; Sun, 24 May 2020 03:28:57 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id r2so5740654ioo.4
        for <linux-unionfs@vger.kernel.org>; Sun, 24 May 2020 03:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vMt/zjgPSaavMH3EHZOPXfBfjSGAnTzC/1ULA/QAqbg=;
        b=pwC91qRET7eqo1160ZFmEcEX6Ju6JlOAQ2WCgg5DEr74TNc3N8r0PTnVXA47BJOhrz
         7sA5C3DOurmR1urCmY0HE7VksDSAfAF3aGIH/+IAeTQ4mIrBO9xVoQsMCCa8VxhPV7ZP
         hxRMJzrScafTRKKgiO6v+X8BrbbUx5HZ7vR3V5F3L8D7ktHK9XfLpx2e0Bke2eKHQycG
         fjuXRYvI0NeD26cTj31i5ECSHfrGgXbqJXk3BsOCfg7fug+MmNbfpitM4GG9GXRo8r6y
         EKga+BtrION/RvZMb+Jad0GQL5zP3d+2yiPnpgEfdWAO1qMr/AMODPvsfMkxI+Rxx2ls
         KW2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vMt/zjgPSaavMH3EHZOPXfBfjSGAnTzC/1ULA/QAqbg=;
        b=bdWi8MM/zbAGoOxBNzWpWHeM35HtuInziOmFZbl4pxzepwsuGD41FZ+SH6NpXaL9U0
         05lQRn0Menb4X4p32esKZ+FApE+3UX6aBGQ9xm0sgfqW7sM0Vg41dHQ0IAJjvT9CECi9
         3m/y/f527lgC+++z2yTNWDGiBfH4butemo+fOfHkb++VFuzTONsEeESuWLOalCZADr1r
         1VW7WCuctZFAsiiHs11otC15AkMGf15b1ssHz040BJ8UytxBYIAjCk6tTQlScAxubQwA
         ofeBmkIWY4eDS5+zQRYtx42dy5JJUubAiQoawIHJkPoTfY6gqB6VS/WQffnz6k2wvUMq
         ED3g==
X-Gm-Message-State: AOAM532AUXrjyHxGX5wXqKgndqQ3ji3jpINuos0R/hwJf5flUIaH0Hth
        1KpqhGcFTzs52dVI6j6GHt+Ea4A0NJoX4HHWNsuIpXEd
X-Google-Smtp-Source: ABdhPJwTB++y9wLOmFlStR1A8gQLdwiUhjMQgQaOgaW21aKwvuXhE5ulWfFhMMwZWKW5dKGXes8JBeLYvrbRQHLVyo0=
X-Received: by 2002:a05:6638:45d:: with SMTP id r29mr14503440jap.93.1590316136936;
 Sun, 24 May 2020 03:28:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200415153032.GC239514@redhat.com> <CAOQ4uxhmxxjGGB3bBoK1OmcAWDsoNi3WdORtH7WDLOcp8=sYSQ@mail.gmail.com>
 <20200415194243.GE239514@redhat.com> <CAOQ4uxjZ4Yd3ZWi+Fe64fVkrD=XMDjF1=C=XN_PNdywbGx_gzQ@mail.gmail.com>
 <20200416125807.GB276932@redhat.com> <CAOQ4uxi=mT2JYGSXro5YW8gTE5256cxauBddYe2HXM=ZfZ=+ZA@mail.gmail.com>
 <CAOQ4uxjvtGLn=SvLXy3KU6uKbonBUznL==OjdVVjjB6sM=-mgg@mail.gmail.com>
 <20200420191453.GA21057@redhat.com> <CAOQ4uxjVU6gcQMmyMiBsVV73gik931-7QjAO9TCu+N2ik6109w@mail.gmail.com>
 <CAOQ4uxgVnT3ZXZZa4-YktZaRDpU1hHujPoEtZ2vdFmsGxj=66A@mail.gmail.com>
 <20200522143606.GB58162@redhat.com> <CAOQ4uxj8Qhw-r8E+Fb-YYnMwmApkCPXD1136CA=oNo-81rzdVQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxj8Qhw-r8E+Fb-YYnMwmApkCPXD1136CA=oNo-81rzdVQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 24 May 2020 13:28:44 +0300
Message-ID: <CAOQ4uxgnRFZ8uTWV1_woCFutACc193X9eTzTOn4wzDkE8-huDQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Configure custom layers via environment variables
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > Hi Amir,
> >
> > Do you want to mention a word upper dir also when UNIONMOUNT_BASEDIR. That
> > is upperdir is also created under UNIONMOUNT_BASEDIR. IOW, all directories
> > lower, upper and mount point are under UNIONMOUNT_BASEDIR (until and
> > unless overridden by other environment variables).
>

Hi Vivek,

Please approve this text before I update master.
Pushed this work to branch 'envvars'

Thanks,
Amir.

-----
The following environment variables are supported:

     UNIONMOUNT_BASEDIR  - parent dir of all samefs layers (default: /base)
     UNIONMOUNT_LOWERDIR - lower layer path for non samefs (default: /lower)
     UNIONMOUNT_MNTPOINT - mount point for executing tests (default: /mnt)

     When user provides UNIONMOUNT_LOWERDIR:

     1) Path should be an existing directory whose content will be deleted.
     2) Path is assumed to be on a different filesystem than base dir, so
        --samefs setup is not supported.

     When user provides UNIONMOUNT_BASEDIR:

     1) Path should be an existing directory whose content will be deleted.
     2) Upper layer and middle layers will be created under base dir.
     3) If UNIONMOUNT_MNTPOINT is not provided, the overlay mount point will
        be created under base dir.
     4) If UNIONMOUNT_LOWERDIR is not provided, the lower layer dir will be
        created under base dir.
     5) If UNIONMOUNT_LOWERDIR is not provided, the test setup defaults to
        --samefs (i.e. lower and upper layers are on the same base fs).
        However, if --maxfs=<M> is specified, a tmpfs instance will be mounted
        on the lower layer dir that was created under base dir.
