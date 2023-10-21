Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC71C001E0
	for <linux-unionfs@archiver.kernel.org>; Sat, 21 Oct 2023 12:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjJUMa5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 21 Oct 2023 08:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjJUMa4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 21 Oct 2023 08:30:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B7FD51
        for <linux-unionfs@vger.kernel.org>; Sat, 21 Oct 2023 05:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697891408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zB7rKJHURX+shbfVJLl9aod2ne3PmJe7YPtkabCyJeU=;
        b=aVEBIaRXxdKaCfwSPoSYLlsOzE073rHeVm9XWGzyYgA6K2AKmzOlw9sdfM7gTXe92peke9
        0JX/v/oVlZ0Yb+MXFVImw+p79gg9X1bgiRXZu81ByvMB1IFidLH9vQ8CCIpCDaG97QQYVJ
        xnS1A5VtO0etVoeg2gEQ3iTSPcXXJ5w=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-KOCfs0vfOti6Fqmd7w97AA-1; Sat, 21 Oct 2023 08:30:06 -0400
X-MC-Unique: KOCfs0vfOti6Fqmd7w97AA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-27dc8165d4bso1816556a91.0
        for <linux-unionfs@vger.kernel.org>; Sat, 21 Oct 2023 05:30:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697891405; x=1698496205;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zB7rKJHURX+shbfVJLl9aod2ne3PmJe7YPtkabCyJeU=;
        b=DrfhMg2Pz4/Emy88RDh0tmG5KV6oBLTyoXk71nN8AFe9sXzTYsMHEbgAYNsyNO4m8S
         eYbdefjvD0slVssM/BxVh+93W+V622Q9e5lde+NiQxxGzveOWpDCqD3FaS+XBlcZtmaE
         zGR3NF7RMft+nNuAnOQ9i2VwenOb81+d0Tzi+RSlZq6wASJHMntY8RRJ5g/uvpvTHz+6
         zFCb/iRCZY70cTQZd4/oYWZD6cL3WeXNQNmj2FI+rSQvq66OEkSfrlvIgCxB2Jww68Rj
         TvqcdmvMEc/f9DfE5LLZnfUcEG0EWoqNDcrGFq0FXncsKgm/YlRPMHvQui/GtXzp+Poz
         AwcQ==
X-Gm-Message-State: AOJu0YyMH66vPjIrVCbXTnFKEs+M4l8tPrgH+H1cxsblksyiIwFTdAyM
        rKUWytbcLEKdgLXi5Ln+16otE1S9yV1J4pVvKzkY/v1gKYsSYugDjHHztA02nWE9oOu3QQ5l4zc
        Iz4/oTOlf9BYT3ap9qOjR2MUs9fnHQ+BIhHSG
X-Received: by 2002:a17:90a:ff0d:b0:27d:5693:7340 with SMTP id ce13-20020a17090aff0d00b0027d56937340mr4311515pjb.24.1697891404972;
        Sat, 21 Oct 2023 05:30:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaQ1dgonQKTMvgCzd7qFNyYUIm/7IcjkMv4nKbetbQ922I0h/p0gNuqL7WzbaSeKuwUs3mHg==
X-Received: by 2002:a17:90a:ff0d:b0:27d:5693:7340 with SMTP id ce13-20020a17090aff0d00b0027d56937340mr4311498pjb.24.1697891404556;
        Sat, 21 Oct 2023 05:30:04 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f7-20020a17090274c700b001c61e628e98sm3073792plt.175.2023.10.21.05.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Oct 2023 05:30:04 -0700 (PDT)
Date:   Sat, 21 Oct 2023 20:30:00 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] overlay: add test for lowerdir mount option parsing
Message-ID: <20231021123000.4rp7iykcomfdk6ev@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231017101145.2348571-1-amir73il@gmail.com>
 <20231019175000.afv2b5fma3ttkt4v@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgYyEfyFrQbyzdzXko6ZUmdRS6g2gH8znOrz-7M3KCUXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgYyEfyFrQbyzdzXko6ZUmdRS6g2gH8znOrz-7M3KCUXg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Oct 20, 2023 at 07:18:55PM +0300, Amir Goldstein wrote:
> On Thu, Oct 19, 2023 at 8:50 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Tue, Oct 17, 2023 at 01:11:45PM +0300, Amir Goldstein wrote:
> > > Check parsing and display of spaces and escaped colons and commans in
> > > lowerdir mount option.
> > >
> > > This is a regression test for two bugs introduced in v6.5 with the
> > > conversion to new mount api.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Zorro,
> > >
> > > This is a test for two regressions in kernel v6.5.
> > > The two fixes were merged in 6.6-rc6 and have been picked for
> > > the upcoming LTS 6.5.y release.
> >
> >
> > >
> > > Thanks,
> > > Amir.
> > >
> > >  tests/overlay/083     | 54 +++++++++++++++++++++++++++++++++++++++++++
> > >  tests/overlay/083.out |  2 ++
> > >  2 files changed, 56 insertions(+)
> > >  create mode 100755 tests/overlay/083
> > >  create mode 100644 tests/overlay/083.out
> > >
> > > diff --git a/tests/overlay/083 b/tests/overlay/083
> > > new file mode 100755
> > > index 00000000..071b4b84
> > > --- /dev/null
> > > +++ b/tests/overlay/083
> > > @@ -0,0 +1,54 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> > > +#
> > > +# FS QA Test 083
> > > +#
> > > +# Test regressions in parsing and display of special chars in mount options.
> > > +#
> > > +# The following kernel commits from v6.5 introduced regressions:
> > > +#  b36a5780cb44 ("ovl: modify layer parameter parsing")
> > > +#  1784fbc2ed9c ("ovl: port to new mount api")
> > > +#
> > > +
> > > +. ./common/preamble
> > > +_begin_fstest auto quick mount
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +
> > > +# real QA test starts here
> > > +_supported_fs overlay
> > > +_fixed_by_kernel_commit 32db51070850 \
> > > +     "ovl: fix regression in showing lowerdir mount option"
> > > +_fixed_by_kernel_commit c34706acf40b \
> > > +     "ovl: fix regression in parsing of mount options with escaped comma"
> >
> > Hi Amir,
> >
> > I tried this case on the latest linux kernel which contains the
> > two commits, but still hit below failure:
> >
> > FSTYP         -- overlay
> > PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 6.6.0-rc6-mainline+ #7 SMP PREEMPT_DYNAMIC Thu Oct 19 22:34:28 CST 2023
> > MKFS_OPTIONS  -- /mnt/scratch
> > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /mnt/scratch /mnt/scratch/ovl-mnt
> >
> > overlay/083       - output mismatch (see /root/git/xfstests/results//overlay/083.out.bad)
> >     --- tests/overlay/083.out   2023-10-19 14:07:18.099496414 +0800
> >     +++ /root/git/xfstests/results//overlay/083.out.bad 2023-10-20 00:25:47.682874383 +0800
> >     @@ -1,2 +1,4 @@
> >      QA output created by 083
> >     +mount: /mnt/scratch/ovl-mnt: special device ovl_esc_test does not exist.
> >     +       dmesg(1) may have more information after failed mount system call.
> >      Silence is golden
> >
> 
> Strange.
> I was under the impression that the 'dev' argument to mount command
> of overlayfs is a completely opaque string.
> 
> Maybe you are using a different libmount version that I do.
> I have libmount 2.36.1.

I'm using Fedora rawhide, the libmount version is libmount-2.39.2-1.fc40.

> 
> Anyway, can you please try if this variation works for you:
> 
> --- a/tests/overlay/083
> +++ b/tests/overlay/083
> @@ -42,12 +42,12 @@ mkdir -p "$lowerdir1" "$lowerdir2" "$lowerdir3"
> 
>  # _overlay_mount_* helpers do not handle special chars well, so
> execute mount directly.
>  # if escaped colons and commas are not parsed correctly, mount will fail.
> -$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
> +$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \

I doubt it works. This looks like to try to mount /mnt/scratch on
/mnt/scratch/ovl-mnt.

Thanks,
Zorro

>         -o"upperdir=$upperdir,workdir=$workdir,lowerdir=$lowerdir3_esc:$lowerdir2_esc:$lowerdir1"
> 
>  # if spaces are not escaped when showing mount options,
>  # mount command will not show the word 'spaces' after the spaces
> -$MOUNT_PROG -t overlay | grep ovl_esc_test  | tee -a $seqres.full |
> grep -v spaces
> +$MOUNT_PROG -t overlay | grep lower3 | tee -a $seqres.full | grep -v spaces
> 
> Thanks,
> Amir.
> 
> >
> > > +
> > > +# _overlay_check_* helpers do not handle special chars well
> > > +_require_scratch_nocheck
> > > +
> > > +# Remove all files from previous tests
> > > +_scratch_mkfs
> > > +
> > > +# Create lowerdirs with special characters
> > > +lowerdir1="$OVL_BASE_SCRATCH_MNT/lower1 with  spaces"
> > > +lowerdir2="$OVL_BASE_SCRATCH_MNT/lower2:with::colons"
> > > +lowerdir3="$OVL_BASE_SCRATCH_MNT/lower3,with,,commas"
> > > +lowerdir2_esc="$OVL_BASE_SCRATCH_MNT/lower2\:with\:\:colons"
> > > +lowerdir3_esc="$OVL_BASE_SCRATCH_MNT/lower3\,with\,\,commas"
> > > +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> > > +workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> > > +mkdir -p "$lowerdir1" "$lowerdir2" "$lowerdir3"
> > > +
> > > +# _overlay_mount_* helpers do not handle special chars well, so execute mount directly.
> > > +# if escaped colons and commas are not parsed correctly, mount will fail.
> > > +$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
> > > +     -o"upperdir=$upperdir,workdir=$workdir,lowerdir=$lowerdir3_esc:$lowerdir2_esc:$lowerdir1"
> > > +
> > > +# if spaces are not escaped when showing mount options,
> > > +# mount command will not show the word 'spaces' after the spaces
> > > +$MOUNT_PROG -t overlay | grep ovl_esc_test  | tee -a $seqres.full | grep -v spaces
> > > +
> > > +echo "Silence is golden"
> > > +status=0
> > > +exit
> > > diff --git a/tests/overlay/083.out b/tests/overlay/083.out
> > > new file mode 100644
> > > index 00000000..0beba309
> > > --- /dev/null
> > > +++ b/tests/overlay/083.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 083
> > > +Silence is golden
> > > --
> > > 2.34.1
> > >
> >
> 

