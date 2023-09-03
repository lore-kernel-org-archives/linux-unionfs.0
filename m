Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F67C83F2C
	for <linux-unionfs@archiver.kernel.org>; Sun,  3 Sep 2023 17:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbjICRcj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 3 Sep 2023 13:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244551AbjICRci (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 3 Sep 2023 13:32:38 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61074DD
        for <linux-unionfs@vger.kernel.org>; Sun,  3 Sep 2023 10:32:35 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-44d3a5cd2f9so244279137.3
        for <linux-unionfs@vger.kernel.org>; Sun, 03 Sep 2023 10:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693762354; x=1694367154; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/OzOeSDrd8GAssKYP5q/fNq74LNE+/yk6IYjvCGAw8w=;
        b=dgVbG9aH4qCDsJwDERsnUgduoRzczuQhb/fhNsyvzvYNvi+b1OmRddBihIhPVyB/Iy
         /q7j21iT/WOXYhb7ILoW2DZTQenNBpS0R1ME/K4/YCdalIc3ulXyTydaLKXcs5kjh2Qr
         b4bbvX6LHyyn2XkvOW+kbW39TVXBpM8laCZagMiADAtFxVqN2OhQNMT3h+wiF5ux9uNH
         /UUDvkt5Szocs05Wfk8LLn1EGAeASFMKVGjAxia/zaWTUt9+WSNB8HT4Lb4J3/bkxYIG
         snJQhxULtxe+nAI8ZBLxdRsYc4yfokEpv0hd88sUKL02JYJaHiVe5rALoJ4fpe4Xn4dr
         AdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693762354; x=1694367154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/OzOeSDrd8GAssKYP5q/fNq74LNE+/yk6IYjvCGAw8w=;
        b=CQLVuYjmpbJNds6Rw4Z4M4Np8pjlRP93W10+RVeKub51CmAYKXPjEJQaflJorapyQE
         Rr+1q8GuygBA+YJvOyo7ySFHC/1qVSFOtzGavGBev6dUJ2gOJHp+TgQ4s7suHjHXvS5F
         8WkpZ0QZd4dOZb/m5OrmH14/0S1+9wSjseZyG9g7e6SHsaC28ZikuK5ZQMd4AIdKRD05
         CmtyX2SWyvTtLcF9Ef3RWQ0Y+n4EaOV5JNFFNQUlP6/71x/O4Ua7Z7eJdTMYccPVqaaq
         MMwkDV+nPD9xkCBjlePnyvFFsfSLBgIkR/rGQeurTa6Vt1QtOokVCnbQEV8CsjadIvP/
         QPNg==
X-Gm-Message-State: AOJu0Yzyo5DS1CoBhnrLyySxJv0+Ke7rfVJHaZWMHTdY5aX4DAlX+3BR
        1CnCEdsYWDpqJBhVhrECTSL+ex1Rx2GJzXKLH/6wjseQGOY=
X-Google-Smtp-Source: AGHT+IFAGZVwArF8DkDkLcAQ+DkiqJyPf1lyXCvpZSqevRfFzEW3aVZlAI4a2P9vcZt2ezyh1R/cHeeoKVqI78tUlbE=
X-Received: by 2002:a67:e24c:0:b0:44d:482a:5443 with SMTP id
 w12-20020a67e24c000000b0044d482a5443mr7496833vse.11.1693762354398; Sun, 03
 Sep 2023 10:32:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAKd=y5EeKfC6vBXh1xqTfeW6OQZiNWaZ04J1SNWxyEjY4QxhHw@mail.gmail.com>
 <CAKd=y5HZ0nJJ9XN9i6vnyhzM=COijmuSzgqJPAPFn6dguQyFQA@mail.gmail.com>
 <CAOQ4uxid-eDr2XBHo_JoPhiP99PrXj0eNKgEQXP-SOEbg4hn_Q@mail.gmail.com>
 <CAKd=y5Gsz1z1xSmHGyoEs+SckC=M0T7nrP7t5mvvuoWkCWkDLg@mail.gmail.com>
 <CAOQ4uxiQtSSHL0gLohBpRs7vwUrF5LqCLB=Oh6kSz1O-ga04Tw@mail.gmail.com>
 <CAJfpegvCEsvac5j3CSVWjjZLsxDvZ-_vX-6u1ZQra26dnUk-jg@mail.gmail.com> <CAOQ4uxjHob=nDUghkGHpcfoAYSUNV_MZB5YHEkTUXB+bOuUBoA@mail.gmail.com>
In-Reply-To: <CAOQ4uxjHob=nDUghkGHpcfoAYSUNV_MZB5YHEkTUXB+bOuUBoA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 3 Sep 2023 20:32:23 +0300
Message-ID: <CAOQ4uxhJ5jw+mY_VJeEOXR7-xauFSY+GkTNnrr+N0nqY8dFPZQ@mail.gmail.com>
Subject: Re: [Bug report] overlayfs: cannot rename symlink if lower filesystem
 is FUSE/NFS
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        Sergey Kanzhelev <skanzhelev@google.com>,
        Michael Sheinin <msheinin@google.com>,
        Theodore Tso <tytso@mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Sep 1, 2023 at 8:57=E2=80=AFPM Amir Goldstein <amir73il@gmail.com> =
wrote:
>
> On Fri, Sep 1, 2023 at 1:14=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
> >
> > On Fri, 1 Sept 2023 at 12:08, Amir Goldstein <amir73il@gmail.com> wrote=
:
> > >
> > > On Fri, Sep 1, 2023 at 12:59=E2=80=AFAM Ruiwen Zhao <ruiwen@google.co=
m> wrote:
> > > >
> > > > Thanks for the reply Amir! Really helps. I will try the easy fix (i=
.e. ignoring ENXIO) and test it. Meanwhile I have two questions:
> > > >
> > > > 1. Since ENXIO comes from ovl_security_fileattr() trying to open th=
e symlink, I was trying to find who returns ENXIO in the first place. I did=
 some code search on libfuse (https://github.com/libfuse/libfuse), but cann=
ot find ENXIO anywhere. Could it be from the kernel side? (I am trying to u=
se this as a justification of the easy fix.)
> > > >
> > >
> > > I think ENXIO comes from no_open() default ->open() method.
> > >
> > > > 2. Miklos's commit message says "The reason is that ovl_copy_fileat=
tr() is triggered due to S_NOATIME being
> > > > set on all inodes (by fuse) regardless of fileattr." Does that mean=
 `ovl_copy_fileattr` should not be triggered on symlink files but it is, an=
d therefore it is getting the errors like ENXIO and ENOTTY?
> > > >
> > >
> > > Miklos' comment explains why ovl_copy_fileattr() passes the gate:
> > >
> > >         if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
> > >
> > > S_NOATIME is an indication that the file MAY have fileattr FS_NOATIME=
_FL,
> > > but in the case of FUSE and NFS, S_NOATIME is there for another unrel=
ated
> > > reason.
> > >
> > > In any case, S_NOATIME on a symlink is never an indication of fileatt=
r,
> > > so I think the correct solution is to add the conditions to the gate:
> > >
> > >         if (inode->i_flags & OVL_COPY_I_FLAGS_MASK &&
> > >            ((S_ISDIR(inode->i_mode) || S_ISREG(inode->i_mode))) {
> > >
> >
> > I don't think this is correct: symlink's atime is updated on readlink
> > or following.
>
> I am not saying that symlink cannot have S_NOATIME, but
> i_flags of the symlink have already been copied to ovl inode.
> I don't think that symlink can have fileattr, because symlink
> cannot be opened for the FS_IOC_SETFLAGS ioctl, so there
> is never a reason to call ovl_copy_fileattr() for anything other
> than dir or regular file. Right?
>

Well, not exactly right.

Apparently, in ext*/btrfs/f2fs/... and recently also tmpfs, the
FS_NOATIME_FL | FS_NODUMP_FL flags are inherited
from parent to all file types, so they actually can exist on symlinks
and ext4 symlinks created inside FS_NOATIME_FL parent do indeed
exhibit S_NOATIME behavior.

This is not the case with xfs, which takes care not to copy any flags
to special files and symlinks.

The thing is that for those fs that inherit NOATIME to symlink:
1. lsattr cannot be used to query the NOATIME flag on symlink
2. chattr cannot be used to remove the NOATIME flag on symlink
3. overlayfs fails to copy up those symlinks

While technically, overlayfs can query and set flags directly without
opening the symlink, I don't think we should bother with this at all
and I think it should be fine if overlayfs only ever copied up
fileattr flags for directories and regular files.

Here is an xfstest for the regression [1].
It only fails when running fstests with ext4 or one of the other
mentioned fs as base fs.

Thanks,
Amir.

[1] https://github.com/amir73il/xfstests/blob/overlayfs-devel/tests/overlay=
/082
