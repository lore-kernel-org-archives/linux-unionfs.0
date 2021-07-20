Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCA8C636C8
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 07:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A95F861164
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 07:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhGTGji (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 02:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhGTGi1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jul 2021 02:38:27 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C16FC061766
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jul 2021 00:18:57 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id z9so22865983iob.8
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jul 2021 00:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WKsm4ExhmVdVLkqUQkRRypXOZYiqBSMKNfwW8cLyVd0=;
        b=drlZs/Mlpncxpq68VDrU9c7HSCs4WdrkXyQ3eBllm77GKQOm1xMLTkGUq1EFcLfejd
         BLzH3byq01v6Qq1Gd7h099ciGUTkXaONAI0BjvmyMLC8/7yvW3NzoyearajgaZGAKXIf
         GWHt8fktDIDmFEjhTadyqzO4YcZIjMzaR6w0U3EVklNAMOqFGZ7E8mNi4HZTYSV4UgAL
         RWdntLOGVJEEfx/WYgXW1SjuGn99Bo7XXp5XE46g4Zpl9BOpQ/7FgSFko08dxetVyIzX
         eX3DrIw3v5EqpIqFOPE++QRveefgw+gB+fPd7c7I3oR4UCLdaDtDcTicef56Mj8f6l80
         1qRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WKsm4ExhmVdVLkqUQkRRypXOZYiqBSMKNfwW8cLyVd0=;
        b=gFPaQiKG/zYUW353/jHyZdklJ59C1Hqs5UgWsnlcVUOYo37EFnXLAaobwnNSK/DLmj
         WjWXQtXjALK3WlPbOzDVu07puvbkPp8qxn+jZYWBixH8SII3YJcY/7zSOkLjH89LdxOa
         6yTRuHEsa1eeClhKlMvtD1Gb6zwVHPReAHrwmYvTIuSP3i2TSf9NPXQVkwbU/NCH8cyE
         Y3hHd205gvO/JbK8kdUtYsSL4ROif0UOuS9qCiUVc5kZOiBXJBQ7KEWIKosidSv+L87O
         tH2K7tH6HAah7lOOLynt0MkOAvqz1/S1LZR1VfJxdvz2JkUKD+AhaBYzGnnopJQzAMeN
         xX/w==
X-Gm-Message-State: AOAM533MngAB9J24oRADaNQi7aO5/3r0ttB242cFa5Qmhe446a2rVswq
        45GxzCuYlvuQDP1zCjzgMSkZ8j421km6iC4IXGU=
X-Google-Smtp-Source: ABdhPJyPF4VKFi6yhAbvWxCst0NZFm0BWj3RV/13Da9E73xfJu1uOH8bvyesnDjvRXY6DDENE9IFNUWhdLOxD4JeEMo=
X-Received: by 2002:a05:6602:3304:: with SMTP id b4mr21628261ioz.186.1626765537030;
 Tue, 20 Jul 2021 00:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210426152021.1145298-1-amir73il@gmail.com> <CAOQ4uxg3CJGstSGsihibXvUtivOhRimnQKqrh=5mSqZa1hA8fQ@mail.gmail.com>
 <CAJfpegtZq=EPuoU_wxr4yEJtime4vW6oPFBnX5whrXS3ZSA6oQ@mail.gmail.com>
 <CAOQ4uxjeHfEy-NHQ3s8gX6Rge9xUkJhfGWGNBFSRj6t4mhAUMQ@mail.gmail.com>
 <CAJfpeguiqGfx150nQ3Y9mMgAreNdrg0Ha-wO-sRzMtk8eXVz7Q@mail.gmail.com> <CAJfpegvMV7Grpzk7A=_Bp9bupg1S22VYoG3XcqL9bstfVwkXgw@mail.gmail.com>
In-Reply-To: <CAJfpegvMV7Grpzk7A=_Bp9bupg1S22VYoG3XcqL9bstfVwkXgw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 20 Jul 2021 10:18:46 +0300
Message-ID: <CAOQ4uxhLyBntfWZYA-Q=Xu6Zzu6VfyxWks5sCZcwZCR1FHv2TQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: skip stale entries in merge dir cache iteration
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 20, 2021 at 7:22 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Tue, 20 Jul 2021 at 06:19, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Mon, 19 Jul 2021 at 18:43, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Mon, Jul 19, 2021 at 6:24 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Fri, 4 Jun 2021 at 12:43, Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > On Mon, Apr 26, 2021 at 6:20 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > >
> > > > > > On the first getdents call, ovl_iterate() populates the readdir cache
> > > > > > with a list of entries, but for upper entries with origin lower inode,
> > > > > > p->ino remains zero.
> > > > > >
> > > > > > Following getdents calls traverse the readdir cache list and call
> > > > > > ovl_cache_update_ino() for entries with zero p->ino to lookup the entry
> > > > > > in the overlay and return d_ino that is consistent with st_ino.
> > > > > >
> > > > > > If the upper file was unlinked between the first getdents call and the
> > > > > > getdents call that lists the file entry, ovl_cache_update_ino() will not
> > > > > > find the entry and fall back to setting d_ino to the upper real st_ino,
> > > > > > which is inconsistent with how this object was presented to users.
> > > > > >
> > > > > > Instead of listing a stale entry with inconsistent d_ino, simply skip
> > > > > > the stale entry, which is better for users.
> > > > > >
> > > > >
> > > > > Miklos,
> > > > >
> > > > > I forgot to follow up on this patch.
> > > > > Upstream xfstest overlay/077 is failing without this patch.
> > > >
> > > > Can't reproduce (on ext4/xfs and "-oxino=on").
> > > >
> > > > Is there some trick?
> > >
> > > Not sure. overlay/077 fails for me on v5.14.0-rc2 on ext4/xfs.
> > >
> > >      QA output created by 077
> > >     +entry m100 has inconsistent d_ino (234 != 232)
> > >     +entry f100 has inconsistent d_ino (335 != 16777542)
> > >      Silence is golden
> > >
> > > Maybe you need to build src/t_dir_offset2?
> >
> > root@kvm:/opt/xfstests-dev# git log -1 --pretty=%h
> > 10f6b231
> > root@kvm:/opt/xfstests-dev# cat local.config
> > export TEST_DEV=/dev/vdb1
> > export TEST_DIR=/test
> > export SCRATCH_DEV=/dev/vdb2
> > export SCRATCH_MNT=/scratch
> > export FSTYP=ext4
> > export OVERLAY_MOUNT_OPTIONS="-o xino=on"
> > root@kvm:/opt/xfstests-dev# make src/t_dir_offset2
> > make: 'src/t_dir_offset2' is up to date.
> > root@kvm:/opt/xfstests-dev# ./check -overlay overlay/077
> > FSTYP         -- overlay
> > PLATFORM      -- Linux/x86_64 kvm 5.14.0-rc2 #276 SMP Tue Jul 20
> > 05:54:44 CEST 2021
> > MKFS_OPTIONS  -- /scratch
> > MOUNT_OPTIONS -- -o xino=on /scratch /scratch/ovl-mnt
> >
> > overlay/077 1s ...  1s
> > Ran: overlay/077
> > Passed all 1 tests
> >
> > root@kvm:/opt/xfstests-dev# cat results/overlay/077.full
> >
> > Create file in pure upper dir:
> > getdents at offset 0 returned 192 bytes
> > created entry p0
> > entry p0 found as expected
> >
> > Remove file in pure upper dir:
> > getdents at offset 0 returned 192 bytes
> > unlinked entry p100
> > entry p100 not found as expected
> >
> > Create file in impure upper dir:
> > getdents at offset 0 returned 192 bytes
> > created entry o0
> > entry o0 found as expected
> >
> > Remove file in impure upper dir:
> > getdents at offset 0 returned 192 bytes
> > unlinked entry o100
> > entry o100 not found as expected
> >
> > Create file in merge dir:
> > getdents at offset 0 returned 192 bytes
> > created entry m0
> > entry m0 found as expected
> >
> > Remove file in merge dir:
> > getdents at offset 0 returned 192 bytes
> > unlinked entry m100
> > entry m100 not found as expected
> >
> > Create file in former merge dir:
> > getdents at offset 0 returned 192 bytes
> > created entry f0
> > entry f0 found as expected
> >
> > Remove file in former merge dir:
> > getdents at offset 0 returned 192 bytes
> > unlinked entry f100
> > entry f100 not found as expected
> >
> > Ideas for further debugging why this test isn't failing for v4.12-rc2?
>

It's not you, it's me ;-)

The failure was lost during cleanup of t_dir_offset2 patches
for submission and it is I who was running an older version
of t_dir_offset2. Let me figure this out and get back to you
with a working test.

Thanks,
Amir.
