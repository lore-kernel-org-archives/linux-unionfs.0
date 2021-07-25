Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF68C4338F
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Jul 2021 18:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF65960E78
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Jul 2021 18:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhGYRkq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 25 Jul 2021 13:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhGYRkp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Jul 2021 13:40:45 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3835C061757;
        Sun, 25 Jul 2021 11:21:14 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id r1so6726479iln.6;
        Sun, 25 Jul 2021 11:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jx9bn5zqD+qhZqUzKuNlAtQJ3DDqHvOdAlZr3s1GbHM=;
        b=HwmgC4TCT7xSFolBMnuzYo1wkLW9oQY2mkqpb1kIRjr/rS7YPVsRXdngwSkyDcQNx+
         Dr9KBrOYPpR7lvkAIEHHOFZgrtfMcmnFqm+PBrvvJJlkD1EYXzcThmWt16ElZU1QRfq9
         3+Em/qf7AUxHqfozleg+uXPoy/wO4XYFWlgxnLXQ5DQuycLUCAIvH5IKtVTWYJzb3Gnq
         drvnDK3NPXRcFwojnFF/CZ4LNdYwJuxhH4EZG/IkX6+HyKezY0RE8yPftrBPvart3fT5
         PcaLfYpV8A8t79W9N9C5/dZyPsN6Eb+7vIxBHl29TYdijatSUtJH8My90nNgZPmK+a4F
         pySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jx9bn5zqD+qhZqUzKuNlAtQJ3DDqHvOdAlZr3s1GbHM=;
        b=Y09miLfPia66tSIvcawjauVr3FKOXp9I8ZLjf6PWAVu2Iw7fT/8/+q3O8bM+/uNTcV
         WOR7vu6Yr+S7RNNjMVt25i1Uvts+u3OxdKugpXeDHjUPL3DT6BR/Y/cGH7K24er2MCQY
         m5BFP/ilCH3zz9m+nhvPTwzvKjRzz4NGb76Qx1g6IYXOydeeKD0G3iLlGBsYoqq09bpX
         GGotq5VsSD1B1nDRPfNLtVtVPzcgBadv6Nqtg6/GlDofEQM6PnJi7W3vH/IoQ9oYRWBA
         vblBldrXXvql5ykCHHclhLxTRf+FTK9yqO3ErNCBpQo20r2r4WqOPwjSi9RP2G4GnqE3
         mywg==
X-Gm-Message-State: AOAM533fcIBMUon3MMs3qLLf3LQ8EZrFFyYoq7n20BXS3I4a9LdybE7D
        Op6iV+yUyHz8zN3l8TdIoXtHwUDbrlcDYmsvnnw=
X-Google-Smtp-Source: ABdhPJxABieF6W1F7tyADe8JXMzwrV8fDK9Vv5WIs51a7qD8WPKXcyhwNjBW2mHX8Rv1ThZlIkCH2Laa/oqZwBXGx1s=
X-Received: by 2002:a05:6e02:1c2d:: with SMTP id m13mr10202412ilh.137.1627237274363;
 Sun, 25 Jul 2021 11:21:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210722164634.394499-1-amir73il@gmail.com> <YP2Q+xTjGICXfOwl@desktop>
In-Reply-To: <YP2Q+xTjGICXfOwl@desktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 25 Jul 2021 21:21:03 +0300
Message-ID: <CAOQ4uxihqmRPms8Cedam7wT5dPAMFYA96DrFBJwUfLh+J9MJLg@mail.gmail.com>
Subject: Re: [PATCH] overlay: add test for copy up of lower file attributes
To:     Eryu Guan <guan@eryu.me>
Cc:     Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jul 25, 2021 at 7:27 PM Eryu Guan <guan@eryu.me> wrote:
>
> On Thu, Jul 22, 2021 at 07:46:34PM +0300, Amir Goldstein wrote:
> > Overlayfs copies up a subset of lower file attributes since kernel
> > commits:
> > 173ff5c9ec37 ("ovl: consistent behavior for immutable/append-only inodes")
> > 2e3f6e87c2b0 ("ovl: copy up sync/noatime fileattr flags")
> >
> > This test verifies this functionality works correctly and that it
> > survives power failure and/or mount cycle.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> Looks good to me overall, just one minor question below.
>
> > ---
> >
> > Eryu,
> >
> > This test is failing on master and passes on overlayfs-next.
> >
> > Thanks,
> > Amir.
> >
> >  tests/overlay/078     | 145 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/078.out |   2 +
> >  2 files changed, 147 insertions(+)
> >  create mode 100755 tests/overlay/078
> >  create mode 100644 tests/overlay/078.out
> >
> > diff --git a/tests/overlay/078 b/tests/overlay/078
> > new file mode 100755
> > index 00000000..b43449d1
> > --- /dev/null
> > +++ b/tests/overlay/078
> > @@ -0,0 +1,145 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018 Huawei.  All Rights Reserved.
> > +# Copyright (C) 2021 CTERA Networks. All Rights Reserved.
> > +#
> > +# FS QA Test 078
> > +#
> > +# Test copy up of lower file attributes.
> > +#
> > +# Overlayfs copies up a subset of lower file attributes since kernel commits:
> > +# 173ff5c9ec37 ("ovl: consistent behavior for immutable/append-only inodes")
> > +# 2e3f6e87c2b0 ("ovl: copy up sync/noatime fileattr flags")
> > +#
> > +# This test is similar and was derived from generic/507, but instead
> > +# of creating new files which are created in upper layer, prepare
> > +# the file with attributes in lower layer and verify that attributes
> > +# are not lost during copy up, (optional) shutdown and mount cycle.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick perms shutdown
>
> I noticed that generic/507 has the same groups defined, but I'm
> wondering if 'perms' is right group, 'attr' seems a better fit to me.

The term "attr" is now very much overloaded in filesystems.
It may refer to info of stat() (i.e. getattr())
it my refer to xattr and it may refer to lsattr/chattr,
which is referred to as fileattr in latest vfs API.

In fstests, most of the tests in the 'attr' group include
./common/attr which refers to ACL xattrs in particular...
so it is not a good fit IMO.

The group 'perm' is already used for overlayfs tests that deal with
immutable files and generic tests that deal with immutable files
don't really have a common group AFAICT.

I have no objection for creating a new group for this
purpose but that would involve marking all related tests and worse...
...finding a name for that group ;-)

> And we could add 'copyup' group as well.
>

Sure.

> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +     cd /
> > +     $CHATTR_PROG -ai $lowertestfile &> /dev/null
> > +     rm -f $tmp.*
> > +}
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs generic
>
> s/generic/overlay/

Oops. I assume you would be fix this typo on commit.

Thanks,
Amir.
