Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154ACC433EF
	for <linux-unionfs@archiver.kernel.org>; Sun, 27 Feb 2022 05:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiB0FRS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 27 Feb 2022 00:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiB0FRS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 27 Feb 2022 00:17:18 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0720C110B
        for <linux-unionfs@vger.kernel.org>; Sat, 26 Feb 2022 21:16:42 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id w7so11329816ioj.5
        for <linux-unionfs@vger.kernel.org>; Sat, 26 Feb 2022 21:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KH7I9L4jLfCzlS7+b2DwdpPcFKSYayiyEBIMT/l+ubY=;
        b=eobJPz542pb3kewWlWJRmPN0yF8XkEtTzbmpsfkKunEAews40wj3jYs1FTnrpg0QDs
         9Ftthu5DnJmQrAHwWKlgcSNWReuyJnoTCmeaR9LxEHnTD/A6UsAdMlTqppcYeAol92A1
         d0CZBie+IQyn0DXC+KcEKZ5gD9P2YZFLek/nZxm+YejRNgEv6+PYEuw3bZti5zFuvij0
         PQFOIvE34yHtwT/G4V9PFGPP1+G/0GIWApPo04dZBY8Ccn/AAcrp3/V/Gyc/L4Ue4RoS
         JxIF7YkWgc4vjh8/i1ndYxBU+fHMhwx4EUN1zXqx9NwEFs+SHGtdzrNIsqllxtuG3ows
         oYhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KH7I9L4jLfCzlS7+b2DwdpPcFKSYayiyEBIMT/l+ubY=;
        b=Fwa9t0NfqxugMYms7cuOci9KR/pVRMneTlzS6OwAG+0wWWZHir80gtfavK1r/o52H9
         YBqsb/zE6dIZZFWL3Fzg561nG1muFoRjI6tiDYaU3crZe5UQTng6SYPNNOzazZjBeEQX
         n2H/FC7I1VQ/zbuwXHKwLNyTvykIXD5VuUn7fJlYYpLBOBCNjY8IhWgzmNgOOtFfHwVM
         dNu601VB2yVWkEOlxanaLwJhAWM/dfsI9C4l+Gb4IiH9QCgrLsAldFrim4b1AebEteSv
         BrdVrDEud3DR7/YoGA5VPQYUDfw3EJwUQN/8VdxK+7eKX4HYmoV/6D97IikYFfrFgWoW
         3oIw==
X-Gm-Message-State: AOAM5306c/U6HkQfGmEu7vDK6/H69UPNkxZf7hnme/zcV9xVZ2UscS0T
        Z3nVLWuPZZNMfKzgs7JIi7UBepF2hMeRzCqjVJEmUBDSZeU=
X-Google-Smtp-Source: ABdhPJybu4B1v8ZdPVIDKDq9Uq9IsiFI8Ck1m8QA0uc3txT377XuO/tDwIbk8pgHjNyzZaWCl0a9b3RoYmyuL6wItVc=
X-Received: by 2002:a02:a1c7:0:b0:314:cc99:3c4f with SMTP id
 o7-20020a02a1c7000000b00314cc993c4fmr11919961jah.53.1645939001349; Sat, 26
 Feb 2022 21:16:41 -0800 (PST)
MIME-Version: 1.0
References: <20220226152058.288353-1-cgxu519@mykernel.net> <CAOQ4uxiWZ4TWq4LuNOHYMHDgX+2Srq_3HNe+t5z-Ch4AFw9bRA@mail.gmail.com>
 <3a37de83-a48d-e0b5-f934-c4b4219de7fe@mykernel.net>
In-Reply-To: <3a37de83-a48d-e0b5-f934-c4b4219de7fe@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 27 Feb 2022 07:16:30 +0200
Message-ID: <CAOQ4uxgOxgXiDZocixLLp253_DDC-3X7SGQoLc1Vv7s2F1g+EQ@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: fsync parent directory in copy-up
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Feb 27, 2022 at 6:28 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> =E5=9C=A8 2022/2/27 0:38, Amir Goldstein =E5=86=99=E9=81=93:
> > On Sat, Feb 26, 2022 at 5:21 PM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
> >> Calling fsync for parent directory in copy-up to
> >> ensure the change get synced.
> > It is not clear to me that this change is really needed
> > What if the reported problem?
>
> I found this issue by eyeball scan when I was looking for
> the places which need to mark overlay inode dirty in change.
>
> However, I think there are still some real world cases will be impacted
> by this kind of issue,
> for example, using docker build to make new docker image and power
> failure makes new
> image inconsistant.

A very good example where the fsync of parent will be counter productive.
The efficient way of building a docker image would be:
1. Write/copy up all the files
2. Writeback all the upper inodes
3. syncfs() upper fs

2 and 3 should happen on overlayfs umount as long as we properly
marked all the copied up overlayfs inodes dirty.

So the question is not if parent dir needs fsync, but if it needs to be
dirtied.

>
>
> >
> > Besides this can impact performance in some workloads.
> >
> > The difference between parent copy up and file copy up is that
> > failing to fsync to copied up data and linking/moving the upper file
> > into place may result in corrupted data after power failure if temp
> > file data is not synced.
> >
> > Failing the fsync the parent dir OTOH may result in revert to
> > lower file data after power failure.
> >
> > The thing is, although POSIX gives you no such guarantee, with
> > ext4/xfs fsync of the upper file itself will guarantee that parents
> > will be present after power failure (see [1]).
>
> In the new test case (079) which I posted, I've tried xfs as underlying
> fs and found the parent of
> copy-up file didn't present after power failure. Am I missing something?
>

I think you are.
The test does not reproduce an inconsistency.
The test reproduced changes that did not persist to storage after
power failure and that is the expected behavior when a user does
not fsync after making changes - unless the 'sync' or 'dirsync' mount
options have been used.

I think your test will become correct if you use -o sync for the overlayfs
mount and your patch will become correct if you do:

+        if (inode_needs_sync(d_inode(dentry)) {
+               parent_file =3D ovl_path_open(&parentpath, O_DIRECTORY|O_RD=
ONLY);

Thanks,
Amir.
