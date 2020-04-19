Return-Path: <SRS0=BYJY=6D=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37860C38A30
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 17:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0603221974
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 17:54:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mehVJFSN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgDSRyW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 19 Apr 2020 13:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgDSRyW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Apr 2020 13:54:22 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400A6C061A0C;
        Sun, 19 Apr 2020 10:54:22 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id z2so3953488iol.11;
        Sun, 19 Apr 2020 10:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QfPjhFgIKm4qP+rOC17KFK+bG+EbnUsXMpg+xXvCJDM=;
        b=mehVJFSNNgoj6SuTZ1zsqLuBPHWmXoR1E1737QdMd3XsCMYk3+Bj1XkiFWqOxS+DIq
         xsUC0nUeOR7ynH+B4Dpe5b2cdrYTeNQCZISaX7vOkmcxHI672HRhqfvbzM6iGO5CwFv+
         /7eXs7r3vmwitSstfDOSS8GjFbAQBOMaY2txdzpy2vUc03zqv8zI1P/aivRsVovPOOyR
         VKX+8RJAhfxVDygNAuyQaB7JKd0KRnnhS4HqLfQ7djexwczbuDGn4/BD9sxNkxsDpHQ+
         IhHLr2yNA7ITdMBpj6IjiGcfndsAny+qAofwnP3JMbNWRfkzwJsJemO4vIkso1X1WeIL
         2I2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QfPjhFgIKm4qP+rOC17KFK+bG+EbnUsXMpg+xXvCJDM=;
        b=CBCb+fqHWg9W8wkwTXoI9+n75u/lvQLJiIZrN3JZcKha8lbKewqkjFRfjl+q06spla
         x+R3CR0MpURwcjPR18dmC761Jn9wLa1jwnTGLRRlUQPSn5TYUJvlPfaFQk5Nwp+yuwYW
         viCHdNBXs2QOmLcF2K6mFI2z2I2zpwUDnmBbbKxyekuoUaQIKMboPTAnzLykQxGq6Wqe
         ajzaijG2S6JzP9MpJptZz+gR8JFYrGcsog2M6+ja66+8OXGkkYZXzrYub3dG3q7awpNE
         lt+DOKmu1zOWonYcj+5FXaE5nt8Az4SEaGT4XUctF0wx2s0ojpE3MhgPng63/SUVp5Fa
         j1cw==
X-Gm-Message-State: AGi0PuafXCwgBBedJpjQmd8XMFFbtxcU8ZD4YY5YDF3ER0hzFA0IHgpl
        P4MzFsmCogpKqYQ66Li3ViCc8QEVOgCzuYJcDeI=
X-Google-Smtp-Source: APiQypIygrXxnkoJNg2/86SFWraAZzwhbt7bbKn1maE/Rwe0RFtOsUeLxreH5bk/0prdPI44urHF6JMeWc6cOwyJ6n0=
X-Received: by 2002:a6b:cd4a:: with SMTP id d71mr12240997iog.5.1587318861367;
 Sun, 19 Apr 2020 10:54:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200409112900.15341-1-amir73il@gmail.com> <20200419160635.GI388005@desktop>
 <CAOQ4uxg15=Yv3rCiKXxZqsF+5+y__foRbW_D6kfbRWhZ-gEAwA@mail.gmail.com> <20200419170119.GJ388005@desktop>
In-Reply-To: <20200419170119.GJ388005@desktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 19 Apr 2020 20:54:09 +0300
Message-ID: <CAOQ4uxjJ4cfbN0xBYkT6F2TsMiiaEvoGnNiOTsDVGNSNFE-S8g@mail.gmail.com>
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

On Sun, Apr 19, 2020 at 8:00 PM Eryu Guan <guan@eryu.me> wrote:
>
> On Sun, Apr 19, 2020 at 07:12:33PM +0300, Amir Goldstein wrote:
> > On Sun, Apr 19, 2020 at 7:05 PM Eryu Guan <guan@eryu.me> wrote:
> > >
> > > On Thu, Apr 09, 2020 at 02:29:00PM +0300, Amir Goldstein wrote:
> > > > When overlayfs index feature is enabled by default in either kernel
> > > > config or module parameters, this test fails:
> > > >
> > > >     mount: /tmp/8751/mnt: mount(2) system call failed: Stale file handle.
> > > >     cat: /tmp/8751/mnt/bar: No such file or directory
> > > >
> > > > The reason is that with index feature enabled, an upper/work dirs cannot
> > > > be reused for mounting with a different lower layer.
> > >
> > > I re-built my test kernel with CONFIG_OVERLAY_FS_INDEX=y, and confirmed
> > > /sys/module/overlay/parameters/index is 'Y', but test still passes for
> > > me. And I do notice the following info in dmesg:
> > >
> > > [  598.663923] overlayfs: fs on '/mnt/scratch/ovl-mnt/up' does not support file handles, falling back to index=off,nfs_export=off.
> > > [  598.674299] overlayfs: fs on '/mnt/scratch/ovl-mnt/low' does not support file handles, falling back to index=off,nfs_export=off.
> > > [  598.684594] overlayfs: fs on '/mnt/scratch/ovl-mnt/' does not support file handles, falling back to index=off,nfs_export=off.
> > >
> > > Seems it has something to do with nfs_export feature? I have it disabled
> > > by default.
> > >
> > >  # CONFIG_OVERLAY_FS_NFS_EXPORT is not set
> > >
> > > Could you please help confirm?
> > >
> >
> > I confirm. enabling index on nested overlay requires that
> > the lower overlay has nfs_export enabled.
>
> Thanks!
>
> >
> > Missed that, but in the bug report, CONFIG_OVERLAY_FS_NFS_EXPORT
> > was indeed set.
>
> Would you please update the commit log accordingly as well?
>

OK.

Thanks,
Amir.
