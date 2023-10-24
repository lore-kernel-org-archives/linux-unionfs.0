Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA431C07545
	for <linux-unionfs@archiver.kernel.org>; Tue, 24 Oct 2023 08:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbjJXIhn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 04:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbjJXIhY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Oct 2023 04:37:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EF699
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2023 01:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698136600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VW1IOEDBIS/bnt1N5o/XBeY4sV2L2ykcdAvwnEDUWag=;
        b=IZkBZ9aakILfUEGvvOplg/Uybwc858HLZt0PTKu1eG5wpEFeLXlCNRD70MJtPZ4lXMANYZ
        aXqQB2HBxUDrYyce/Jkh1uS+ZqtQGH+BRkSLbT2R3Aym+FTmMgO3Ylmor1EFwrcjSdfqPc
        S7UMG8grX4VZZhpR5vdA4tF4A4AnjU0=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-JlXnB6E2PzmwXNB_5ULNPg-1; Tue, 24 Oct 2023 04:36:38 -0400
X-MC-Unique: JlXnB6E2PzmwXNB_5ULNPg-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1c9c939cc94so31557745ad.1
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2023 01:36:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698136598; x=1698741398;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VW1IOEDBIS/bnt1N5o/XBeY4sV2L2ykcdAvwnEDUWag=;
        b=r6gYejqkwLBddQPOUtI3hp6q4Oh0wOETg0t54TSDp+2O6nL92zOMW0P/xTTZ1ceM+S
         4HC6egw14lBoME6kBP30XQ0kYQ5XlUtn5SMW6/flnOBfXeQh14azDblRvNfqhY56LjSo
         sT25/9lsrUOZ8YqomdGXW2aIxf0VupWjJj3OULJE2qqBCCr+BtiwzTYAPx+hY/fkFUKn
         eQJhNC9Hr9D0JyOmSWJ6hmyBxHHHGcLHpL1opkOSFHJjNGaWKTcNH2PLaEOzuZ9SJdfh
         8cogM1dzn8y4yhV9I7JNGv4TOOG4wsEzmgaIwtH1K5KtOf7rHivpITZ28LecDgqepLgu
         DOmg==
X-Gm-Message-State: AOJu0Yxs6dx8ppcYln25vCNJrP8N8mO7C+lzTskw/0p/oIzeIBmzRjEe
        x82ksT7qRqFdfmWyJT5RzBMKkXTIokpJ7y6UjvkjjfLrsW5t0RJ/Tu+Z3gHANXTHDJT+VFcrLCi
        dFMvlnVoJgt3U4FPobczmYdGoxA==
X-Received: by 2002:a05:6a20:3ca6:b0:15a:bf8:7dfc with SMTP id b38-20020a056a203ca600b0015a0bf87dfcmr2152714pzj.15.1698136597790;
        Tue, 24 Oct 2023 01:36:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHh0GqBxL/ijWdXAT8Z33JZWhJVBCC+tA0dZPj6xswpfyTZXimP/WbL6g2BHZ9bqKUDbvTFLQ==
X-Received: by 2002:a05:6a20:3ca6:b0:15a:bf8:7dfc with SMTP id b38-20020a056a203ca600b0015a0bf87dfcmr2152706pzj.15.1698136597464;
        Tue, 24 Oct 2023 01:36:37 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q21-20020a170902789500b001c55e13bf39sm6985763pll.275.2023.10.24.01.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 01:36:37 -0700 (PDT)
Date:   Tue, 24 Oct 2023 16:36:33 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        Karel Zak <kzak@redhat.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v3] overlay: add test for lowerdir mount option parsing
Message-ID: <20231024083633.7wanwannt6r5zyft@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231023163259.2949803-1-amir73il@gmail.com>
 <20231024052433.gpalxwtb37kqd6kn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgD5KoDc5=VjvpguAO07SixYFZafJr+7fhs9J13LL2s4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgD5KoDc5=VjvpguAO07SixYFZafJr+7fhs9J13LL2s4w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 24, 2023 at 09:48:42AM +0300, Amir Goldstein wrote:
> On Tue, Oct 24, 2023 at 8:24 AM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Mon, Oct 23, 2023 at 07:32:59PM +0300, Amir Goldstein wrote:
> > > Check parsing and display of spaces and escaped colons and commans in
> > > lowerdir mount option.
> > >
> > > This is a regression test for two bugs introduced in v6.5 with the
> > > conversion to new mount api.
> > >
> > > There is another regression of new mount api related to libmount parsing
> > > of escaped commas, but this needs a fix in libmount - this test only
> > > verifies the fixes in the kernel, so it uses LIBMOUNT_FORCE_MOUNT2=always
> > > to force mount(2) and kernel pasring of the comma separated options list.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Changes since v2:
> > > - Fix test for when index feature is enabled
> > >
> > > Changes since v1:
> > > - Fix test for libmount >= 2.39
> > >
> > >  tests/overlay/083     | 76 +++++++++++++++++++++++++++++++++++++++++++
> > >  tests/overlay/083.out |  2 ++
> > >  2 files changed, 78 insertions(+)
> > >  create mode 100755 tests/overlay/083
> > >  create mode 100644 tests/overlay/083.out
> > >
> > > diff --git a/tests/overlay/083 b/tests/overlay/083
> > > new file mode 100755
> > > index 00000000..df82d1fd
> > > --- /dev/null
> > > +++ b/tests/overlay/083
> > > @@ -0,0 +1,76 @@
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
> > > +
> > > +# _overlay_check_* helpers do not handle special chars well
> > > +_require_scratch_nocheck
> > > +
> > > +# Remove all files from previous tests
> > > +_scratch_mkfs
> > > +
> > > +# Create lowerdirs with special characters
> > > +lowerdir_spaces="$OVL_BASE_SCRATCH_MNT/lower1 with  spaces"
> > > +lowerdir_colons="$OVL_BASE_SCRATCH_MNT/lower2:with::colons"
> > > +lowerdir_commas="$OVL_BASE_SCRATCH_MNT/lower3,with,,commas"
> > > +lowerdir_colons_esc="$OVL_BASE_SCRATCH_MNT/lower2\:with\:\:colons"
> > > +lowerdir_commas_esc="$OVL_BASE_SCRATCH_MNT/lower3\,with\,\,commas"
> > > +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> > > +workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> > > +mkdir -p "$lowerdir_spaces" "$lowerdir_colons" "$lowerdir_commas"
> > > +
> > > +# _overlay_mount_* helpers do not handle special chars well, so execute mount directly.
> > > +# if escaped colons are not parsed correctly, mount will fail.
> > > +$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
> > > +     -o"upperdir=$upperdir,workdir=$workdir" \
> > > +     -o"lowerdir=$lowerdir_colons_esc:$lowerdir_spaces" \
> > > +     2>&1 | tee -a $seqres.full
> > > +
> > > +# if spaces are not escaped when showing mount options,
> > > +# mount command will not show the word 'spaces' after the spaces
> > > +$MOUNT_PROG -t overlay | grep ovl_esc_test  | tee -a $seqres.full | grep -v spaces && \
> > > +     echo "ERROR: escaped spaces truncated from lowerdir mount option"
> > > +
> > > +# Re-create the upper/work dirs to mount them with a different lower
> > > +# This is required in case index feature is enabled
> > > +$UMOUNT_PROG $SCRATCH_MNT
> > > +rm -rf "$upperdir" "$workdir"
> > > +mkdir -p "$upperdir" "$workdir"
> > > +
> > > +# Kernel commit c34706acf40b fixes parsing of mount options with escaped comma
> > > +# when the mount options string is provided via data argument to mount(2) syscall.
> > > +# With libmount >= 2.39, libmount itself will try to split the comma separated
> > > +# options list provided to mount(8) commnad line and call fsconfig(2) for each
> > > +# mount option seperately.  Since libmount does not obay to overlayfs escaped
> > > +# commas format, it will call fsconfig(2) with the wrong path (i.e. ".../lower3")
> > > +# and this test will fail, but the failure would indicate a libmount issue, not
> > > +# a kernel issue.  Therefore, force libmount to use mount(2) syscall, so we only
> > > +# test the kernel fix.
> > > +LIBMOUNT_FORCE_MOUNT2=always $MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_DEV $SCRATCH_MNT \
> > > +     -o"upperdir=$upperdir,workdir=$workdir,lowerdir=$lowerdir_commas_esc" 2>> $seqres.full || \
> > > +     echo "ERROR: incorrect parsing of escaped comma in lowerdir mount option"
> >
> > This version looks good to me. I just hope we can remove the "LIBMOUNT_FORCE_MOUNT2=always"
> > after that issue get fixed, to let this case cover new mount API test too.
> >
> 
> TBH, I am not really sure the best approach here would be.
> Let's say that the issue gets fixed in libmount 2.40.
> Would we then remove "LIBMOUNT_FORCE_MOUNT2=always"
> and add a hint:
> 
> _fixed_in_version libmount 2.40

Sure, that's good to me. If there's a git commit ($id $subject), I think
that would be better than the version number, e.g.

  # A known issue of util-linux/libmount ....
  _fixed_by_git_commit util-linux xxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxx

Due to ...

> 
> Do you think that would be the appropriate thing to do for fstests?
> 
> I am asking because so far fstests was used to track regressions
> in kernel and in various fs progs, e.g.:
> _fixed_by_git_commit btrfs-progs ...
> _fixed_by_git_commit xfsprogs ...
> _fixed_by_git_commit xfsdump ...
> 
> Where developers of said fs progs often build their own binaries.

... as you say, downstream progs might have their own backport and build.

Thanks,
Zorro

> 
> An alternative would be to extend _require_command to take
> an optional min_ver argument and try to figure out the version
> from running $command -V (best effort).
> I am not going to cheer for this approach...
> 
> Anyway, we plan to add new overlayfs mount options that
> are only supported with FSCONFIG_SET_PATH and libmount 2.39
> does not support this yet, so are probably going to need to use
> a helper program in src to test the new mount API on overlayfs anyway.
> 
> Thanks,
> Amir.
> 

