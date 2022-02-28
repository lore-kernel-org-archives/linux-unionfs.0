Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A08FC433F5
	for <linux-unionfs@archiver.kernel.org>; Mon, 28 Feb 2022 16:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiB1QcG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 11:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbiB1QcF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 28 Feb 2022 11:32:05 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6051B85BCD
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Feb 2022 08:31:26 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id w4so13586585vsq.1
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Feb 2022 08:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rEXCndZSqLw0KM8FF9WWJNcYaW+CrKBAI4mMearLYPA=;
        b=ANoxucz13gEbrU2XLyJD6T/y/p9MiAGAUqM62cR9ahEyy/aYJzqZDmd7hBIkvtPvy1
         xJr6OR3uS9molaigPyNOU44vUw3vClQbGNZvsckB+Lzc8zRvHP4e/sc81iswdocSlcwz
         mzVk6xW932C2C+84CVZgHEydzH2p6eY3ohp1k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rEXCndZSqLw0KM8FF9WWJNcYaW+CrKBAI4mMearLYPA=;
        b=lLCOroc8EXp7XfkfQTwVkPhZP8aIzdfCmzHhsRWJQ9HctFybFWq/1LzFU/9wNM6bJk
         lovzmIJp8Kqzwd5DPQLr1FjEByFE0fHiNKx0ENuq4qc3If2i3sCei5eIYdiY61O3AHKh
         GxipESv7j8NmetqkTqZ/8rX1eL8s/jsfyRn7KvGllT0C77fdCoHasJ8OhXmhqd1s2a73
         e/fUZtY5OJiL8zMkycWa6aFnsCGkd4s34p1HYgWvZ8hL3o2Hzg1TdwwnLGypPsJxHHVd
         zxlMtqBkOSTePQGFKE+APTKYWQfslPpHisocK1bGWdMdRMjsmPHHPoapCeswUxk86qqY
         O2ug==
X-Gm-Message-State: AOAM533mOvRtbgqpFR0v6O5ppDwzbcIGw09rnm2Gk0tw3fD8NW05m7N/
        hXfRsh2BusRxymDHrpKJyZn04M/clk3hgO0EpyBrNg==
X-Google-Smtp-Source: ABdhPJxl9qhvXsw99bcbpm0zcQ74AP/OgSf/MYNZUyPpf3nKztuC8fS11Im4ziH++b6Yi5zrBpk+AdkBUkJhAQz8K4M=
X-Received: by 2002:a05:6102:32c7:b0:31b:8f98:5fd with SMTP id
 o7-20020a05610232c700b0031b8f9805fdmr7917679vss.24.1646065885559; Mon, 28 Feb
 2022 08:31:25 -0800 (PST)
MIME-Version: 1.0
References: <20220228113910.1727819-1-amir73il@gmail.com> <20220228113910.1727819-5-amir73il@gmail.com>
 <CAJfpegvZefGp9NChm_69Km0FgpxwUs+og-uc2mpMAbH6mZ2azQ@mail.gmail.com> <CAOQ4uxgg8PDweNvkhXE20Gbb+=OGBbwLXjR6Yffc4ZkiKzGM0w@mail.gmail.com>
In-Reply-To: <CAOQ4uxgg8PDweNvkhXE20Gbb+=OGBbwLXjR6Yffc4ZkiKzGM0w@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 28 Feb 2022 17:31:14 +0100
Message-ID: <CAJfpegvnhsBB_Ym3VGs7xBQM3OWsXCsqBZncBVNFCDJXka_AwA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] fs: report per-mount io stats
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        containers@lists.linux.dev,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 28 Feb 2022 at 17:19, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Feb 28, 2022 at 5:06 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Mon, 28 Feb 2022 at 12:39, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > Show optional collected per-mount io stats in /proc/<pid>/mountstats
> > > for filesystems that do not implement their own show_stats() method
> > > and opted-in to generic per-mount stats with FS_MOUNT_STATS flag.
> >
> > This would allow some filesystems to report per-mount I/O stats, while
> > leaving CIFS and NFS reporting a different set of per-sb stats.  This
> > doesn't sound very clean.
> >
> > There was an effort to create saner and more efficient interfaces for
> > per-mount info.  IMO this should be part of that effort instead of
> > overloading the old interface.
> >
>
> That's fair, but actually, I have no much need for per-mount I/O stats
> in overlayfs/fuse use cases, so I could amend the patches to collect and
> show per-sb I/O stats.
>
> Then, the generic show_stats() will not be "overloading the old interface".
> Instead, it will be creating a common implementation to share among different
> filesystems and using an existing vfs interface as it was intended.
>
> Would you be willing to accept adding per-sb I/O stats to overlayfs
> and/or fuse via /proc/<pid>/mountstats?

Yes, that would certainly be more sane.   But I'm also wondering if
there could be some commonality with the stats provided by NFS...

Thanks,
Miklos
