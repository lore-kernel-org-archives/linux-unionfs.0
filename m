Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26206E7109A
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 17:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjIURG0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 13:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjIURF7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 13:05:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13D24483
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Sep 2023 10:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695315753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O1je172e6ImL1he1ih2V9L0uWRhszZDHHcwXl/vfF8w=;
        b=QYnRcVCDn3NiaooPfK3T24sAcKoanxEt+3GlrPVvF3fpO296f+4GhU8zVQqX2papyMjTCN
        9+09/4IG84+CSV0J3ftA42tBUl4LJ/3qaatWw3eYxYkGeSXmkIvZoqDOU6U6R6P+9GVUHe
        K7olvJ/qZ88Dr8MfxI7apLv0cWs0skE=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-k9voYBZfOIqipEaYbZc71A-1; Thu, 21 Sep 2023 02:26:51 -0400
X-MC-Unique: k9voYBZfOIqipEaYbZc71A-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-274da8afe70so492923a91.2
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Sep 2023 23:26:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695277610; x=1695882410;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O1je172e6ImL1he1ih2V9L0uWRhszZDHHcwXl/vfF8w=;
        b=Ndw82BnPVVmRTyGJfO+ogkpBMULQhd8XeJwbmR21t55Q/RFPskcAqYvfGooTJKaZsq
         QsRvUlfGuVTv3T0AxRQTx2Nu4JOZpjpfbAUYKMG3JEJ9T/1i6ZutE82chjx4vMopwpvK
         LVcQ23PyWYAu2U7IE9rkYRdmqFRawwm/jclJ1JqGJOi0ltu/3eLWhRanmX9Y91f1CvYp
         U1B3NunacZI4Abf0FFETtT/KTk6udkje7hDQChk0rDTK1iAToJeTIr0VMxLe+7soKnee
         JkLcF2zHLXiKObsmUrQEJ8Fg1aCHUin6UBD699NINMRvD+D0RHpOxxfuCB7XMa9yN0No
         /KgA==
X-Gm-Message-State: AOJu0Yx/Wkb0FHOca8sMjGza2za9l3jBK7G78QOpDFHl/LpeI6QSm2OT
        mcQYqAZ9wshBz5waUJIgaVZIbs/mynZVL/1M05xEe6UoiL7V9aOLexDfPSHnkZYimq8kXUPdnph
        v52uZjONm/qxC100ALzAAJCo6Hw==
X-Received: by 2002:a17:90b:1e0a:b0:269:85d:2aef with SMTP id pg10-20020a17090b1e0a00b00269085d2aefmr4659690pjb.20.1695277610126;
        Wed, 20 Sep 2023 23:26:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFi8d/fLa8hd13biyPtgXBxtf4y6mRTqhUkU2LMXYSpat6sKfEYbi2jlddFSIDq0TDFYRlfPA==
X-Received: by 2002:a17:90b:1e0a:b0:269:85d:2aef with SMTP id pg10-20020a17090b1e0a00b00269085d2aefmr4659679pjb.20.1695277609713;
        Wed, 20 Sep 2023 23:26:49 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v6-20020a17090a6b0600b00262eb0d141esm570135pjj.28.2023.09.20.23.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 23:26:49 -0700 (PDT)
Date:   Thu, 21 Sep 2023 14:26:45 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] overlay: add test for rename of lower symlink with
 NOATIME attr
Message-ID: <20230921062645.lhryfrod7ggdxfuh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20230920130355.62763-1-amir73il@gmail.com>
 <20230920151403.gsh5gphvlilhp6sv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxhxsg2AwttYPfhSLQQNbFxo2pmyNUMTC8QpxNw6L_afpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhxsg2AwttYPfhSLQQNbFxo2pmyNUMTC8QpxNw6L_afpw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Sep 20, 2023 at 06:34:21PM +0300, Amir Goldstein wrote:
> On Wed, Sep 20, 2023 at 6:14 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Wed, Sep 20, 2023 at 04:03:55PM +0300, Amir Goldstein wrote:
> > > A test for a regression from v5.15 reported by Ruiwen Zhao:
> > > https://lore.kernel.org/linux-unionfs/CAKd=y5Hpg7J2gxrFT02F94o=FM9QvGp=kcH1Grctx8HzFYvpiA@mail.gmail.com/

Could you give one more sentence to tell what kind of regression
does this case test for? Not only a link address.

> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Zorro,
> > >
> > > This is a test for a regression in kernel v5.15.
> > > The fix was merged for 6.6-rc2 and has been picked for
> > > the upcoming LTS releases 5.15, 6.1, 6.5.
> > >
> > > The reproducer only manifests the bug in fs that inherit noatime flag,
> > > namely ext4, btrfs, ... but not xfs.
> > >
> > > The test does _notrun on xfs for that reason.
> > >
> > > Thanks,
> > > Amir.
> > >
> > >  tests/overlay/082     | 68 +++++++++++++++++++++++++++++++++++++++++++
> > >  tests/overlay/082.out |  2 ++
> > >  2 files changed, 70 insertions(+)
> > >  create mode 100755 tests/overlay/082
> > >  create mode 100644 tests/overlay/082.out
> > >
> > > diff --git a/tests/overlay/082 b/tests/overlay/082
> > > new file mode 100755
> > > index 00000000..abea3c2b
> > > --- /dev/null
> > > +++ b/tests/overlay/082
> > > @@ -0,0 +1,68 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> > > +#
> > > +# FS QA Test 082
> > > +#
> > > +# kernel commit 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
> > > +# from v5.15 introduced a regression.

Hi Amir,

Thanks for this new regression test. More detailed (picky:) review points
as below ...

So this commit is the one which introduced a regression. But we generally
say what kind of regression does this case test for, in this comment.

> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick

According the source code of this case, please think about more detailed group
names, likes: "symlink", "copyup" and "atime".

> > > +
> > > +# Import common functions.
> > > +. ./common/filter

I think this case doesn't use any filter helpers, right?

> > > +
> > > +# real QA test starts here
> > > +_supported_fs overlay
> > > +_fixed_by_kernel_commit ab048302026d \
> > > +     "ovl: fix failed copyup of fileattr on a symlink"
> > > +
> > > +_require_scratch
> > > +_require_chattr A
> > > +
> > > +# remove all files from previous runs
> > > +_scratch_mkfs
> > > +
> > > +# prepare lower test dir with NOATIME flag
> > > +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> > > +mkdir -p $lowerdir/testdir
> > > +$CHATTR_PROG +A $lowerdir/testdir >> $seqres.full 2>&1 ||
> > > +     _notrun "base fs $OVL_BASE_FSTYP does not support No_Atime flag"
> > > +
> > > +# The NOATIME is inheritted to children symlink in ext4/fs2fs
> > > +# (and on tmpfs on recent kernels).
> > > +# The overlayfs test will not fail unless base fs is
> > > +# one of those filesystems.
> > > +#
> > > +# The problem with this inheritence is that the NOATIME flag is inheritted
> > > +# to a symlink and the flag does take effect, but there is no way to query
> > > +# the flag (lsattr) or change it (chattr) on a symlink, so overlayfs will
> > > +# fail when trying to copy up NOATIME flag from lower to upper symlink.
> > > +#
> > > +touch $lowerdir/testdir/foo
> > > +ln -sf foo $lowerdir/testdir/lnk
> > > +
> > > +$LSATTR_PROG -l $lowerdir/testdir/foo >> $seqres.full 2>&1
> > > +$LSATTR_PROG -l $lowerdir/testdir/foo | grep -q No_Atime || \
> > > +     _notrun "base fs $OVL_BASE_FSTYP does not inherit No_Atime flag"
> > > +
> > > +before=$(stat -c %x $lowerdir/testdir/lnk)
> > > +echo "symlink atime before readlink: $before" >> $seqres.full 2>&1

I remember some filesystems' timestamp for atime (e.g. exfat) might have more
seconds granularity. So it would be better to `sleep 2s` at here.

Correct me if someone fs need more or less :)

> > > +cat $lowerdir/testdir/lnk
> > > +after=$(stat -c %x $lowerdir/testdir/lnk)
> > > +echo "symlink atime after readlink: $after" >> $seqres.full 2>&1
> > > +
> > > +[ "$before" == "$after" ] || \
> > > +     _notrun "base fs $OVL_BASE_FSTYP does not inherit No_Atime flag on symlink"
> > > +
> > > +# mounting overlay
> > > +_scratch_mount
> > > +
> > > +# moving symlink will try to copy up lower symlink flags
> > > +mv $SCRATCH_MNT/testdir/lnk $SCRATCH_MNT/
> >
> > Lots of above codes are checking if the underlying fs supports No_Atime (and inherit),
> > and _notrun if not support. How about do these checking steps in a require_*
> > function locally or in common/, likes _require_noatime_inheritance(). And we also
> > can let _require_chattr accept one more argument to specify a test directory.
> >
> 
> ok.
> 
> > The "mv ..." command looks like the final testing step. If there's not that bug,
> > nothing happen, but I'm wondering what should happen if there's a bug?
> 
> mv fails with error ENXIO, see linked bug report in commit message.

Thanks, I think we can add "fails with error ENXIO at here, if the bug is reproduced" in
the comment of that "mv ..." command.

Thanks,
Zorro

> 
> Thanks,
> Amir.
> 

