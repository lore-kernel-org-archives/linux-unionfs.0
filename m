Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8BDEB64D8
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Jun 2023 09:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjFVJsk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 05:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbjFVJsZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Jun 2023 05:48:25 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC0235A9
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Jun 2023 02:38:00 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-3f9e33a3d3fso65963371cf.1
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Jun 2023 02:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687426630; x=1690018630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9d7SJTWDzyLBq0FOBDDPWEchjvCD3K+2+FvT0uCOCy8=;
        b=M94nXLsiRpyMFlY66kOOKFSJ7Rd/Y/iOxz0kbEkfh+N4iIumH5pJoJzs32KD6p2ToL
         8z77h8ZN++EJTi0XR+hukDwmCdSg6WX5DN9VIDIF7YfCgcbNJ6zLSHORBiZrsAroFupF
         VjOllWGq1BEvDoClXn3JeRErQfvCit1F4qSmkwiHUT8+WFsxJarkKnXn0T3TPf1Xp3La
         aTD+HEc+nXzqM5NuZzOwKl28di2zMh8zZYvd2PoKc+mLrHMEEMX2GRyd0+wlMec9FMtK
         kifrEhRAKbtH2JjI5YUa7YbIweFl6N36BHDBg5r9nj90dEM3jocPYLP+2+gjPAt+U16J
         iE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687426630; x=1690018630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9d7SJTWDzyLBq0FOBDDPWEchjvCD3K+2+FvT0uCOCy8=;
        b=LGEFb/YGWW4HKwJxJ0UsXs+S4gpbBQscpihZvOLvoNoKlu/esyYgbQzxLnvVFdnd9v
         mKryXipzsWJzNdQyFNHaPYtFJUt5slTjKPyWjV53J2YqhEXnMA5FgJOe1qpcSUPSS9V9
         hGhX8yYflb5G0+2URd3F/Cf+Fg3m380qPXW0a2NVlEBOJNqy5qk1TWkU+dAyoQ1SHSLA
         FMMLnskSYhcmNq700vHrsC3iP/cM8vlCE0apQLl8fziuCMFqYEYX1ghlJKdCbvinVLft
         6EPX63EiHlOJ8OYk5i6NQVL6/cCWVdPnjWJ/AFJnU6qN5nPkSjrTTUUnLsPe1oo5ubeb
         WSig==
X-Gm-Message-State: AC+VfDzgXFqZWaBYYHAt2LXkk4Ca/vUgfQ9vceQBQmWYRJStigvzRDEJ
        qhD+n2rbTSD4B4nB3FYqnl2JDrg1LFrcy1h3/zixzXNLVuY=
X-Google-Smtp-Source: ACHHUZ5+hcMtiEmX7gyIvmmdzj6x0Si5ypWVpWFZf9e7YbCro2PaPPdEBcIeM4PoX/5rwyoRHxrVADGmgOwQoq/L5s0=
X-Received: by 2002:a05:622a:552:b0:3fd:dfbd:3225 with SMTP id
 m18-20020a05622a055200b003fddfbd3225mr19442609qtx.57.1687426630174; Thu, 22
 Jun 2023 02:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <CAOQ4uxgmV1KKCeq8=8FPkAciwqPpz8JiSM8WEuxDaZbVuYcQ7Q@mail.gmail.com>
 <CAL7ro1EiYOOOqexrKy+UXRzmpGyCaNec3+LHGxnA0YfmoMDN3A@mail.gmail.com>
 <CAL7ro1FKwgUY4e7N_vYi0cFsuVx6St0-oKvcBkiRFnzLH8D1eQ@mail.gmail.com>
 <CAOQ4uxgVnv7wtwFZaBnEotFCwQD1EZcSK2KW4K4vRD8d9fzCiw@mail.gmail.com> <CAL7ro1FY6OmhypFGDjinOkkjyJzymntVje4nRA558dKY+KsgzQ@mail.gmail.com>
In-Reply-To: <CAL7ro1FY6OmhypFGDjinOkkjyJzymntVje4nRA558dKY+KsgzQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 22 Jun 2023 12:36:59 +0300
Message-ID: <CAOQ4uxjuhzxgTxmRXxczJLDrMzKKr-jzS3R8ESwkw4XQ+UyAfQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] ovl: Add support for fs-verity checking of lowerdata
To:     Alexander Larsson <alexl@redhat.com>, ebiggers@kernel.org,
        tytso@mit.edu
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 14, 2023 at 10:17=E2=80=AFAM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> On Wed, Jun 14, 2023 at 8:14=E2=80=AFAM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Mon, Jun 12, 2023 at 5:54=E2=80=AFPM Alexander Larsson <alexl@redhat=
.com> wrote:
> > >
> > > On Mon, Jun 12, 2023 at 1:09=E2=80=AFPM Alexander Larsson <alexl@redh=
at.com> wrote:
> > > >
> > > > On Mon, Jun 12, 2023 at 12:54=E2=80=AFPM Amir Goldstein <amir73il@g=
mail.com> wrote:
> > > > >
> > > > > On Mon, Jun 12, 2023 at 1:27=E2=80=AFPM Alexander Larsson <alexl@=
redhat.com> wrote:
> > > > > >
> > > > > > This patchset adds support for using fs-verity to validate lowe=
rdata
> > > > > > files by specifying an overlay.verity xattr on the metacopy
> > > > > > files.
> > > > > >
> > > > > > This is primarily motivated by the Composefs usecase, where the=
re will
> > > > > > be a read-only EROFS layer that contains redirect into a base d=
ata
> > > > > > layer which has fs-verity enabled on all files. However, it is =
also
> > > > > > useful in general if you want to ensure that the lowerdata file=
s
> > > > > > matches the expected content over time.
> > > > > >
> > > > > > I have also added some tests for this feature to xfstests[1].
> > > > >
> > > > > I can't remember if there is a good reason why your test does
> > > > > not include verify in a data-only layer.
> > > > >
> > > > > I think this test coverage needs to be added.
> > > >
> > > > Yeah. I'll add that.
> > >
> > > Updated the git branch with some lowerdata tests.
> > >
> >
> > What do I need to do in order to enable verity on ext4 besides
> > enabling FS_VERITY in the kernel?
> >
> > I'm getting these on verity tests on ext4 in the default 4k config.
> > _require_scratch_verity() doesn't mention any requirement other
> > that 4K blocks and extent format files.
> >
> > Thanks,
> > Amir.
> >
> > BEGIN TEST 4k (10 tests): Ext4 4k block Wed Jun 14 06:04:25 UTC 2023
> > DEVICE: /dev/vdb
> > EXT_MKFS_OPTIONS: -b 4096
> > EXT_MOUNT_OPTIONS: -o block_validity
> > FSTYP         -- ext4
> > PLATFORM      -- Linux/x86_64 kvm-xfstests
> > 6.4.0-rc2-xfstests-00026-g35774ba7f07c #1596 SMP PREEMPT_DYNAMIC Tue
> > Jun 13 18:16:59 IDT 2023
> > MKFS_OPTIONS  -- -F -q -b 4096 /dev/vdc
> > MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
> >
> > generic/572        [06:04:42] [06:04:47] [not run]
> > generic/572 -- ext4 verity isn't usable by default with these mkfs opti=
ons
> > ...
>
> You need to "tune2fs -O verity" (or pass -O verity to mkfs.ext4).
>

That was indeed missing in my setup, but it did not fix the problem.

Turned out that I had a very old version of fsverity installed in my
kvm-xfstest test VM, where there is no --block-size option to
fsverity enable would always fail.

Eric,

You may consider adding a check for minimal version of
fsverity or check for support of --block-size option to make
this error reason more clear for testers.

Ted,

FYI, FSVERITY_GIT in fstests-bld/config points to an out of date URL

How come there is no ext4/cfg/verity in fstests-bld?
Are you guys not testing fsverity with fstests-bld?
Should we just add fsverity config or add verity to ext4/cfg/encrypt
instead to avoid growing the test matrix?

I can send patches for fstests-bld fixing the above if you like.

Alex,

Verified that your verity-tests2 work as expected with v5 patches.

Thanks,
Amir.
