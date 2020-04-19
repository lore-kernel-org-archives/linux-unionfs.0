Return-Path: <SRS0=BYJY=6D=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF07C38A30
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 16:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE40B214D8
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 16:12:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rkxj/zuC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgDSQMp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 19 Apr 2020 12:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgDSQMp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Apr 2020 12:12:45 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191EEC061A0C;
        Sun, 19 Apr 2020 09:12:45 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id w1so8076774iot.7;
        Sun, 19 Apr 2020 09:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gcxq4ofSN4wgNF8j5jrdlYzXizMthllEizPi6ywGKOs=;
        b=Rkxj/zuC6UH6YTtfAcsp9r+fQ49T+njLzQRRmFmp5aL5+IcoBDDEusLyDwWceTfcAc
         hf7Osf1nwAIgIMOqUg8+IbdYnDfkemEMVIflTKldjnGYP6V9/uxh9ECVrMOP0rsJn7ZF
         qPsYHmI7h0PYiReS3Oe+AjqCI+Jwo0TbpUVLxiBZEdyx+ssM9KDZkDKaXf+1/RtdGhOs
         /pSujZW01kXJaoo/X7/k6JpwhAtd6GMHkzVE/hrEPV3VFepAHUFl7jFo7hpKP2FygTOG
         kIO+aj9gcJ2TElXDVN0WQHa4EF1jxb6lV7a2mysFFNLDsN7YawxnDljYzAGLqOqezf+a
         NiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gcxq4ofSN4wgNF8j5jrdlYzXizMthllEizPi6ywGKOs=;
        b=LefC1rodw1/ocxYoCwEFZPmqSfJolzOm52gFykfD1APEXzCVQcGdL1XNgiOqiJr/j+
         u2NIXq/gItHUB2zPhFoin+ocYVgfdrZH2j9Uq5nOG2YHDs5XWFGna9LcSy4SAzgmP+U9
         L6LGnLMijhi4223ybTrGyi69O9OX2ORH1HqhBCS3Vsfbuon0Usb2ocDaM+v1u8ZHKOn2
         HR+68y9944Hwov82AIk9MPXYTYNqVCjkML6pjKH02JbgTKquJOkcVxkCVxsYX+KihqVi
         /9NZXrLHjLk/HCyBrVWIN02Ak5auRBHOCPbbm1p0GzSuJcZibYPvvCUqzoukT8pRTez8
         PyqQ==
X-Gm-Message-State: AGi0PubnUslv0qF8sZ/abYE7zFCleu3N0PWxk7BxV+NpD59blmFUOYxt
        XdmlnXWCVnOXGCarBuMQ/28XP4W35kC6LVe5I7M=
X-Google-Smtp-Source: APiQypKeZv3VQ0iz0Y6HMmoR/hGXys8dNA6PXLHXMyRsi21EJrHfnncJBw7wcQSjse4NaRZzFIdqVSye15dHX5vLSX8=
X-Received: by 2002:a6b:cd4a:: with SMTP id d71mr11984938iog.5.1587312764280;
 Sun, 19 Apr 2020 09:12:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200409112900.15341-1-amir73il@gmail.com> <20200419160635.GI388005@desktop>
In-Reply-To: <20200419160635.GI388005@desktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 19 Apr 2020 19:12:33 +0300
Message-ID: <CAOQ4uxg15=Yv3rCiKXxZqsF+5+y__foRbW_D6kfbRWhZ-gEAwA@mail.gmail.com>
Subject: Re: [PATCH] overlay/029: fix test failure with index feature enabled
To:     Eryu Guan <guan@eryu.me>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Apr 19, 2020 at 7:05 PM Eryu Guan <guan@eryu.me> wrote:
>
> On Thu, Apr 09, 2020 at 02:29:00PM +0300, Amir Goldstein wrote:
> > When overlayfs index feature is enabled by default in either kernel
> > config or module parameters, this test fails:
> >
> >     mount: /tmp/8751/mnt: mount(2) system call failed: Stale file handle.
> >     cat: /tmp/8751/mnt/bar: No such file or directory
> >
> > The reason is that with index feature enabled, an upper/work dirs cannot
> > be reused for mounting with a different lower layer.
>
> I re-built my test kernel with CONFIG_OVERLAY_FS_INDEX=y, and confirmed
> /sys/module/overlay/parameters/index is 'Y', but test still passes for
> me. And I do notice the following info in dmesg:
>
> [  598.663923] overlayfs: fs on '/mnt/scratch/ovl-mnt/up' does not support file handles, falling back to index=off,nfs_export=off.
> [  598.674299] overlayfs: fs on '/mnt/scratch/ovl-mnt/low' does not support file handles, falling back to index=off,nfs_export=off.
> [  598.684594] overlayfs: fs on '/mnt/scratch/ovl-mnt/' does not support file handles, falling back to index=off,nfs_export=off.
>
> Seems it has something to do with nfs_export feature? I have it disabled
> by default.
>
>  # CONFIG_OVERLAY_FS_NFS_EXPORT is not set
>
> Could you please help confirm?
>

I confirm. enabling index on nested overlay requires that
the lower overlay has nfs_export enabled.

Missed that, but in the bug report, CONFIG_OVERLAY_FS_NFS_EXPORT
was indeed set.

You do not need to rebuild the kernel.
You can reproduce the failure by setting overlay module parameter before
running the tests.

echo Y > /sys/module/overlay/parameters/index
echo Y > /sys/module/overlay/parameters/nfs_export

Thanks,
Amir.
