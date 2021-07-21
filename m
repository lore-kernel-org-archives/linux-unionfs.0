Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49452C636C9
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jul 2021 13:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2487661029
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jul 2021 13:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhGUM2e (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Jul 2021 08:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhGUM1o (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jul 2021 08:27:44 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72593C061574
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jul 2021 06:08:21 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id f4so1365998vsh.11
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jul 2021 06:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dt9aDr0YJ9OipK4M1aA2G+MpBHasElMd5/QYQDX4pXQ=;
        b=jfgYg2DauwNXLT98x1VyAzN3sZmfwHyxfxfxug+2/RWvktHDGzfABdvVZC1pVkGiJM
         jUa0SNIgACnNw8TLozBrcnF1evIBSK8PM7Wzp0LRWbw9nhJwmPV07CBm/4QTAkV9BLFH
         lhrDeKOj5fXRu3JOSdRpNcAnI6LyBYqowumME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dt9aDr0YJ9OipK4M1aA2G+MpBHasElMd5/QYQDX4pXQ=;
        b=UbxzONpLWTVpa05oYTIQBrPL8w+ES5s7piJ5C1pdFO+tabTX51vQO24m6PecXYep2L
         rY3fICYbsto5mGvw9I0zjMxfEkZdcQFgUghZWIz1KmV8qVx/zeOllKjY+oEMmClA23nV
         qrenWJKad9/Q3mioVHGE8Y9DhpLSgmCXOPaOq3QfR9C+tO5kXID5QiJ3NaTnVKmcCoqB
         M0FH4fCKPJNqZF7IwB93+3Ner66R5mb1jiEGG1RNYRoOQB+g/h5KMXaVtwJLYx9/wsP1
         jN5iS0aBKTZebxKhBptYR7QF6ybLI1+V2mFIypzkTYE2GFYwcEYzg+FxrM5pk/Br19jU
         x0QQ==
X-Gm-Message-State: AOAM530q4fqUF9uLNAZ0cpEKOMMgoATB0z9pBMk8Qlah7QUxXqJJA/pe
        yXoO/Uc8LhcfRm+B5VJc2ypbT2Ph281rfjbPw+fDZw==
X-Google-Smtp-Source: ABdhPJyqxSeaX+uDdhtw7EKkRvfT1t32hb+2dwJWqPv+Mg8ei4nzS3QAk7F7TmMVUeyK1VPMFEHtYMvVHHOOeRNtDzg=
X-Received: by 2002:a05:6102:2143:: with SMTP id h3mr30756362vsg.9.1626872898079;
 Wed, 21 Jul 2021 06:08:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210426152021.1145298-1-amir73il@gmail.com> <CAOQ4uxg3CJGstSGsihibXvUtivOhRimnQKqrh=5mSqZa1hA8fQ@mail.gmail.com>
 <CAJfpegtZq=EPuoU_wxr4yEJtime4vW6oPFBnX5whrXS3ZSA6oQ@mail.gmail.com>
 <CAOQ4uxjeHfEy-NHQ3s8gX6Rge9xUkJhfGWGNBFSRj6t4mhAUMQ@mail.gmail.com>
 <CAJfpeguiqGfx150nQ3Y9mMgAreNdrg0Ha-wO-sRzMtk8eXVz7Q@mail.gmail.com>
 <CAJfpegvMV7Grpzk7A=_Bp9bupg1S22VYoG3XcqL9bstfVwkXgw@mail.gmail.com>
 <CAOQ4uxhLyBntfWZYA-Q=Xu6Zzu6VfyxWks5sCZcwZCR1FHv2TQ@mail.gmail.com>
 <CAOQ4uxhVy3Y7BB2uTM4jW6=w0sFf6uW824QAXVEqwepNuGtMNg@mail.gmail.com> <CAOQ4uximehHRdZMR-=n-QUjBdsdD7+GXYmnn11=9eE8UznuFVg@mail.gmail.com>
In-Reply-To: <CAOQ4uximehHRdZMR-=n-QUjBdsdD7+GXYmnn11=9eE8UznuFVg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 21 Jul 2021 15:08:07 +0200
Message-ID: <CAJfpegsi-VmwvQbdMnfMOCGb5s43hrXJOPAdjCQC8X6RQwZAGQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: skip stale entries in merge dir cache iteration
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 20 Jul 2021 at 18:17, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Jul 20, 2021 at 5:55 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Jul 20, 2021 at 10:18 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Tue, Jul 20, 2021 at 7:22 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Tue, 20 Jul 2021 at 06:19, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > >
> > > > > On Mon, 19 Jul 2021 at 18:43, Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Jul 19, 2021 at 6:24 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > > > >
> > > > > > > On Fri, 4 Jun 2021 at 12:43, Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, Apr 26, 2021 at 6:20 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > On the first getdents call, ovl_iterate() populates the readdir cache
> > > > > > > > > with a list of entries, but for upper entries with origin lower inode,
> > > > > > > > > p->ino remains zero.
> > > > > > > > >
> > > > > > > > > Following getdents calls traverse the readdir cache list and call
> > > > > > > > > ovl_cache_update_ino() for entries with zero p->ino to lookup the entry
> > > > > > > > > in the overlay and return d_ino that is consistent with st_ino.
> > > > > > > > >
> > > > > > > > > If the upper file was unlinked between the first getdents call and the
> > > > > > > > > getdents call that lists the file entry, ovl_cache_update_ino() will not
> > > > > > > > > find the entry and fall back to setting d_ino to the upper real st_ino,
> > > > > > > > > which is inconsistent with how this object was presented to users.
> > > > > > > > >
> > > > > > > > > Instead of listing a stale entry with inconsistent d_ino, simply skip
> > > > > > > > > the stale entry, which is better for users.
> > > > > > > > >
> > > > > > > >
> > > > > > > > Miklos,
> > > > > > > >
> > > > > > > > I forgot to follow up on this patch.
> > > > > > > > Upstream xfstest overlay/077 is failing without this patch.
> > > > > > >
> > > > > > > Can't reproduce (on ext4/xfs and "-oxino=on").
> > > > > > >
> > > > > > > Is there some trick?
> > > > > >
> > > > > > Not sure. overlay/077 fails for me on v5.14.0-rc2 on ext4/xfs.
> > > > > >
> > > > > >      QA output created by 077
> > > > > >     +entry m100 has inconsistent d_ino (234 != 232)
> > > > > >     +entry f100 has inconsistent d_ino (335 != 16777542)
> > > > > >      Silence is golden
> > > > > >
> > > > > > Maybe you need to build src/t_dir_offset2?
> > > > >
> > > > > root@kvm:/opt/xfstests-dev# git log -1 --pretty=%h
> > > > > 10f6b231
> > > > > root@kvm:/opt/xfstests-dev# cat local.config
> > > > > export TEST_DEV=/dev/vdb1
> > > > > export TEST_DIR=/test
> > > > > export SCRATCH_DEV=/dev/vdb2
> > > > > export SCRATCH_MNT=/scratch
> > > > > export FSTYP=ext4
> > > > > export OVERLAY_MOUNT_OPTIONS="-o xino=on"
> > > > > root@kvm:/opt/xfstests-dev# make src/t_dir_offset2
> > > > > make: 'src/t_dir_offset2' is up to date.
> > > > > root@kvm:/opt/xfstests-dev# ./check -overlay overlay/077
> > > > > FSTYP         -- overlay
> > > > > PLATFORM      -- Linux/x86_64 kvm 5.14.0-rc2 #276 SMP Tue Jul 20
> > > > > 05:54:44 CEST 2021
> > > > > MKFS_OPTIONS  -- /scratch
> > > > > MOUNT_OPTIONS -- -o xino=on /scratch /scratch/ovl-mnt
> > > > >
> > > > > overlay/077 1s ...  1s
> > > > > Ran: overlay/077
> > > > > Passed all 1 tests
> > > > >
> > > > > root@kvm:/opt/xfstests-dev# cat results/overlay/077.full
> > > > >
> > > > > Create file in pure upper dir:
> > > > > getdents at offset 0 returned 192 bytes
> > > > > created entry p0
> > > > > entry p0 found as expected
> > > > >
> > > > > Remove file in pure upper dir:
> > > > > getdents at offset 0 returned 192 bytes
> > > > > unlinked entry p100
> > > > > entry p100 not found as expected
> > > > >
> > > > > Create file in impure upper dir:
> > > > > getdents at offset 0 returned 192 bytes
> > > > > created entry o0
> > > > > entry o0 found as expected
> > > > >
> > > > > Remove file in impure upper dir:
> > > > > getdents at offset 0 returned 192 bytes
> > > > > unlinked entry o100
> > > > > entry o100 not found as expected
> > > > >
> > > > > Create file in merge dir:
> > > > > getdents at offset 0 returned 192 bytes
> > > > > created entry m0
> > > > > entry m0 found as expected
> > > > >
> > > > > Remove file in merge dir:
> > > > > getdents at offset 0 returned 192 bytes
> > > > > unlinked entry m100
> > > > > entry m100 not found as expected
> > > > >
> > > > > Create file in former merge dir:
> > > > > getdents at offset 0 returned 192 bytes
> > > > > created entry f0
> > > > > entry f0 found as expected
> > > > >
> > > > > Remove file in former merge dir:
> > > > > getdents at offset 0 returned 192 bytes
> > > > > unlinked entry f100
> > > > > entry f100 not found as expected
> > > > >
> > > > > Ideas for further debugging why this test isn't failing for v4.12-rc2?
> > > >
> > >
> > > It's not you, it's me ;-)
> > >
> > > The failure was lost during cleanup of t_dir_offset2 patches
> > > for submission and it is I who was running an older version
> > > of t_dir_offset2. Let me figure this out and get back to you
> > > with a working test.
> > >
> >
> > How about you try again with a version of the test that actually has
> > the check and the error print that I reported.... ;-)
> >
>
> P.S.1:
> xino=on is futile for this test as it uses all layers on same fs
>
> P.S.2:
> The attached patch to t_dir_offset2 only reproduces the first
> inconsistency I reported:
> entry m100 has inconsistent d_ino (234 != 232)
>
> The second inconsistency requires another small patch to overlay/077
> (attached). I will post both those patches once the kernel fix is in
> overlayfs-next.

Thanks.

Verified and pushed.

Miklos
