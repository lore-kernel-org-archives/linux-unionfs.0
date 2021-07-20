Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822CDC07E95
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 04:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D106610F7
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 04:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhGTDlP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 23:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346248AbhGTDj0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jul 2021 23:39:26 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0019BC061574
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jul 2021 21:20:03 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id h5so10572425vsg.12
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jul 2021 21:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hPUYLrROn99wAsGGGpEySd1Ch9a7vLrfHImIXk23MK8=;
        b=fTWlVpZ6C2fw0lbGywZXSouknnewi8u3xOu4Wnbc3ef7sQ9symRG8Jt6Hb42nveGMO
         yCIWi41LUgMVsX+YduRgUdi2v5+uVmvMzU32oAPJXBemBtCm5MeG41HXcVKIoT/54oX6
         9m1esEF9Z+tv3RU8nWErOzQCu7NHblNtYNQuI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hPUYLrROn99wAsGGGpEySd1Ch9a7vLrfHImIXk23MK8=;
        b=Xx1QZLQPleX3VhLlCboDLJl7OEuyX3IwsgJFV35NzXQ0KUN/ogDRj0K0vz04Xwlt5o
         65Qax5Y9sfUgw/kMJLk56XOCVHU1AbQq3eZ3YAnmnL6egVH8ozoi1pCNtdL/gcvjfCM+
         wvEFpVRXaqu49nvI39nMwRGnyo4KPEROGNmg7Lnlm5qsxpKBhGhW0U2l3b564aq+nBgu
         xuPiMquqA9aIfQXGV1NFUQRwPxaoQXxJbZVb+4HdJ+/rW/IwD16ea+anJXv8wFg/5cfN
         MALJ/24dXdssm/xLidc+xbtpmBaTNQaGuPtDJSFNv0HbtN2aW+U6iUrCgStcJBkldiC5
         Ky1A==
X-Gm-Message-State: AOAM5331YtrIy3+JDF3TdJVX/f2cY/21tI7N6Buout0TeweWn9nEbG3F
        srpHZuEHa3FN6YkGX9nmb4yyj8oqi3uPP7MyQpggEw==
X-Google-Smtp-Source: ABdhPJzIIxV4t8vs73NtmLKO/n8FfnpqcZAnayUlPSiieSSwoYqpo7n55+5+tlVP0ray/a63CCgg79Q4Qkmwji0VE9c=
X-Received: by 2002:a05:6102:2143:: with SMTP id h3mr23212593vsg.9.1626754803100;
 Mon, 19 Jul 2021 21:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210426152021.1145298-1-amir73il@gmail.com> <CAOQ4uxg3CJGstSGsihibXvUtivOhRimnQKqrh=5mSqZa1hA8fQ@mail.gmail.com>
 <CAJfpegtZq=EPuoU_wxr4yEJtime4vW6oPFBnX5whrXS3ZSA6oQ@mail.gmail.com> <CAOQ4uxjeHfEy-NHQ3s8gX6Rge9xUkJhfGWGNBFSRj6t4mhAUMQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjeHfEy-NHQ3s8gX6Rge9xUkJhfGWGNBFSRj6t4mhAUMQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 20 Jul 2021 06:19:52 +0200
Message-ID: <CAJfpeguiqGfx150nQ3Y9mMgAreNdrg0Ha-wO-sRzMtk8eXVz7Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: skip stale entries in merge dir cache iteration
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 19 Jul 2021 at 18:43, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Jul 19, 2021 at 6:24 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Fri, 4 Jun 2021 at 12:43, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Mon, Apr 26, 2021 at 6:20 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > On the first getdents call, ovl_iterate() populates the readdir cache
> > > > with a list of entries, but for upper entries with origin lower inode,
> > > > p->ino remains zero.
> > > >
> > > > Following getdents calls traverse the readdir cache list and call
> > > > ovl_cache_update_ino() for entries with zero p->ino to lookup the entry
> > > > in the overlay and return d_ino that is consistent with st_ino.
> > > >
> > > > If the upper file was unlinked between the first getdents call and the
> > > > getdents call that lists the file entry, ovl_cache_update_ino() will not
> > > > find the entry and fall back to setting d_ino to the upper real st_ino,
> > > > which is inconsistent with how this object was presented to users.
> > > >
> > > > Instead of listing a stale entry with inconsistent d_ino, simply skip
> > > > the stale entry, which is better for users.
> > > >
> > >
> > > Miklos,
> > >
> > > I forgot to follow up on this patch.
> > > Upstream xfstest overlay/077 is failing without this patch.
> >
> > Can't reproduce (on ext4/xfs and "-oxino=on").
> >
> > Is there some trick?
>
> Not sure. overlay/077 fails for me on v5.14.0-rc2 on ext4/xfs.
>
>      QA output created by 077
>     +entry m100 has inconsistent d_ino (234 != 232)
>     +entry f100 has inconsistent d_ino (335 != 16777542)
>      Silence is golden
>
> Maybe you need to build src/t_dir_offset2?

root@kvm:/opt/xfstests-dev# git log -1 --pretty=%h
10f6b231
root@kvm:/opt/xfstests-dev# cat local.config
export TEST_DEV=/dev/vdb1
export TEST_DIR=/test
export SCRATCH_DEV=/dev/vdb2
export SCRATCH_MNT=/scratch
export FSTYP=ext4
export OVERLAY_MOUNT_OPTIONS="-o xino=on"
root@kvm:/opt/xfstests-dev# make src/t_dir_offset2
make: 'src/t_dir_offset2' is up to date.
root@kvm:/opt/xfstests-dev# ./check -overlay overlay/077
FSTYP         -- overlay
PLATFORM      -- Linux/x86_64 kvm 5.14.0-rc2 #276 SMP Tue Jul 20
05:54:44 CEST 2021
MKFS_OPTIONS  -- /scratch
MOUNT_OPTIONS -- -o xino=on /scratch /scratch/ovl-mnt

overlay/077 1s ...  1s
Ran: overlay/077
Passed all 1 tests

root@kvm:/opt/xfstests-dev# cat results/overlay/077.full

Create file in pure upper dir:
getdents at offset 0 returned 192 bytes
created entry p0
entry p0 found as expected

Remove file in pure upper dir:
getdents at offset 0 returned 192 bytes
unlinked entry p100
entry p100 not found as expected

Create file in impure upper dir:
getdents at offset 0 returned 192 bytes
created entry o0
entry o0 found as expected

Remove file in impure upper dir:
getdents at offset 0 returned 192 bytes
unlinked entry o100
entry o100 not found as expected

Create file in merge dir:
getdents at offset 0 returned 192 bytes
created entry m0
entry m0 found as expected

Remove file in merge dir:
getdents at offset 0 returned 192 bytes
unlinked entry m100
entry m100 not found as expected

Create file in former merge dir:
getdents at offset 0 returned 192 bytes
created entry f0
entry f0 found as expected

Remove file in former merge dir:
getdents at offset 0 returned 192 bytes
unlinked entry f100
entry f100 not found as expected

Ideas for further debugging why this test isn't failing for v4.12-rc2?

Thanks,
Miklos
