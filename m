Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E2DC433F5
	for <linux-unionfs@archiver.kernel.org>; Sun, 27 Feb 2022 13:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiB0NjR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 27 Feb 2022 08:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiB0NjR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 27 Feb 2022 08:39:17 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDD45D65C
        for <linux-unionfs@vger.kernel.org>; Sun, 27 Feb 2022 05:38:40 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id w4so8089170ilj.5
        for <linux-unionfs@vger.kernel.org>; Sun, 27 Feb 2022 05:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j3jwlTw6RbN0yhxQqLQkIgcRLhpKIF91SyFBNtDGZhw=;
        b=P1+L6VaejGLxjxq5fZib4j+77LJtQREYZYSerxVxQmhGqxKkgZ44JZHPZCAH+23ZrX
         YYDKUHzMCoLFobHgMsMAqRsGG+Zfw/uzza2pVS83O1ECob45Fnevt2LPSTh48AF+1uxm
         f+k7h0E0gSulsY8Ya0Y8aoBmTnoA7kA0sLIkaFtrQu7AWJOR6e40pePNPRdfN+cEKIA7
         znZL5rKg5TKe/yubJYZ7qyqWM9UYvu7lFiH+MQtLf6YXX8ubUi1eExY8JQSKIv0tzAiH
         577L3x1J7zQxB5gNcMi5iVqmD0dvDA75xS2gZ2g587GOTTuiLSecDd6AdtL3gLUwxauo
         wAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j3jwlTw6RbN0yhxQqLQkIgcRLhpKIF91SyFBNtDGZhw=;
        b=thoXswMfQ0P4Rs07e6ta35H0BdJCFjEiOMhJMJsIEChZDHT0zoSLac0kPVil+jxPoN
         51IphDc05DdDTY9NgRnKpJm3bv/TKd6k8zN2dn3w+xERvINJjh8Bn6Ev8dyWlATHOcxw
         4PnzbQafw3lXaKvo6Ey5OJ69JnvjjpSkx6TV+79NJDDsFvDwE4ZtF/l7ERSzhA7m8XUw
         7y3BDXhlhJmHYH4w4hB2YldFr/D8meqN+UOsaCKx0xF2CcmYActEGxf6TzeUpE1wlgEq
         DMsA66oCgWiCpy3IQNq8lixhw8dRkq6rEDe7KP+5mhOpJrHDuwL0IUumFUN3z3Q7J4oi
         wWZQ==
X-Gm-Message-State: AOAM531CV1fkildRIr4x1Rv8aC9JOVHnqiKD8TRyS9EI2bu0s1BfKWnc
        AwRt4M3XsB10WFXTWDeTHhzCTViChdBp3KGvZ30=
X-Google-Smtp-Source: ABdhPJzUhYzagMkiOsfU+wYBaJKNSeM/HDZv1EM7B16vutcvQYXG+2MoIhgoazf6Tr4z2rnml4JLr8l5wzsB7cDAScI=
X-Received: by 2002:a05:6e02:214a:b0:2bf:a442:cbff with SMTP id
 d10-20020a056e02214a00b002bfa442cbffmr15296659ilv.107.1645969120053; Sun, 27
 Feb 2022 05:38:40 -0800 (PST)
MIME-Version: 1.0
References: <20220226152058.288353-1-cgxu519@mykernel.net> <CAOQ4uxiWZ4TWq4LuNOHYMHDgX+2Srq_3HNe+t5z-Ch4AFw9bRA@mail.gmail.com>
 <3a37de83-a48d-e0b5-f934-c4b4219de7fe@mykernel.net> <CAOQ4uxgOxgXiDZocixLLp253_DDC-3X7SGQoLc1Vv7s2F1g+EQ@mail.gmail.com>
 <c9705270-72bc-d446-0f58-6e803d2367e5@mykernel.net>
In-Reply-To: <c9705270-72bc-d446-0f58-6e803d2367e5@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 27 Feb 2022 15:38:28 +0200
Message-ID: <CAOQ4uxhr6SeL_-rRNCeogaYfnHVQQq8Hv2G9xAu5McrO7_fCpg@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: fsync parent directory in copy-up
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Feb 27, 2022 at 3:25 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> =E5=9C=A8 2022/2/27 13:16, Amir Goldstein =E5=86=99=E9=81=93:
> > On Sun, Feb 27, 2022 at 6:28 AM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
> >> =E5=9C=A8 2022/2/27 0:38, Amir Goldstein =E5=86=99=E9=81=93:
> >>> On Sat, Feb 26, 2022 at 5:21 PM Chengguang Xu <cgxu519@mykernel.net> =
wrote:
> >>>> Calling fsync for parent directory in copy-up to
> >>>> ensure the change get synced.
> >>> It is not clear to me that this change is really needed
> >>> What if the reported problem?
> >> I found this issue by eyeball scan when I was looking for
> >> the places which need to mark overlay inode dirty in change.
> >>
> >> However, I think there are still some real world cases will be impacte=
d
> >> by this kind of issue,
> >> for example, using docker build to make new docker image and power
> >> failure makes new
> >> image inconsistant.
> > A very good example where the fsync of parent will be counter productiv=
e.
> > The efficient way of building a docker image would be:
> > 1. Write/copy up all the files
> > 2. Writeback all the upper inodes
> > 3. syncfs() upper fs
> >
> > 2 and 3 should happen on overlayfs umount as long as we properly
> > marked all the copied up overlayfs inodes dirty.
> >
> > So the question is not if parent dir needs fsync, but if it needs to be
> > dirtied.
> >
> >>
> >>> Besides this can impact performance in some workloads.
> >>>
> >>> The difference between parent copy up and file copy up is that
> >>> failing to fsync to copied up data and linking/moving the upper file
> >>> into place may result in corrupted data after power failure if temp
> >>> file data is not synced.
> >>>
> >>> Failing the fsync the parent dir OTOH may result in revert to
> >>> lower file data after power failure.
> >>>
> >>> The thing is, although POSIX gives you no such guarantee, with
> >>> ext4/xfs fsync of the upper file itself will guarantee that parents
> >>> will be present after power failure (see [1]).
> >> In the new test case (079) which I posted, I've tried xfs as underlyin=
g
> >> fs and found the parent of
> >> copy-up file didn't present after power failure. Am I missing somethin=
g?
> >>
> > I think you are.
> > The test does not reproduce an inconsistency.
> > The test reproduced changes that did not persist to storage after
> > power failure and that is the expected behavior when a user does
> > not fsync after making changes - unless the 'sync' or 'dirsync' mount
> > options have been used.
> >
> > I think your test will become correct if you use -o sync for the overla=
yfs
> > mount and your patch will become correct if you do:
> >
> > +        if (inode_needs_sync(d_inode(dentry)) {
> > +               parent_file =3D ovl_path_open(&parentpath, O_DIRECTORY|=
O_RDONLY);
>
> Why should parent_file open with O_RDONLY flag? Meanwhile, I think the

It's a directory. What is the meaning of opening it for write?
fsync doesn't need a writable fd.

> fix is not sufifcient for fully supporting 'dirsync' or 'sync' in overlay=
fs.

Right.

> Anyway, I think the description of expected behavior above makes sense
> so maybe the topic should turn to implement 'sync' or 'dirsync' mount
> options or reject specifying those options in overlayfs.

If anything, I would reject them, unless you know of users that are
going to use this functionality, but maybe you better complete the
syncfs work before going into new adventures ;-)

Thanks,
Amir.
