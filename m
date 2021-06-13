Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276C0C48BE8
	for <linux-unionfs@archiver.kernel.org>; Sun, 13 Jun 2021 15:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 084E261358
	for <linux-unionfs@archiver.kernel.org>; Sun, 13 Jun 2021 15:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhFMPmw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 11:42:52 -0400
Received: from out20-15.mail.aliyun.com ([115.124.20.15]:37518 "EHLO
        out20-15.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbhFMPmv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 13 Jun 2021 11:42:51 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.0946574|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.741023-0.000891746-0.258085;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047213;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.KRnd8Pf_1623598847;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KRnd8Pf_1623598847)
          by smtp.aliyun-inc.com(10.147.40.7);
          Sun, 13 Jun 2021 23:40:47 +0800
Date:   Sun, 13 Jun 2021 23:40:46 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Chao Yu <yuchao0@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] generic/507: support more filesystems
Message-ID: <YMYm/tEuFr7LE8Kh@desktop>
References: <20210611131029.679307-1-amir73il@gmail.com>
 <CAOQ4uxgdZqBv6ju+6HLXSPh1N5X+pzBXTB+0uhZw2dFhTs1ESA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgdZqBv6ju+6HLXSPh1N5X+pzBXTB+0uhZw2dFhTs1ESA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jun 13, 2021 at 09:34:11AM +0300, Amir Goldstein wrote:
> On Fri, Jun 11, 2021 at 4:10 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > The commit message introducing the test says:
> > "We only check below attribute modification which most filesystem
> >  supports:
> >     - no atime updates (A)
> >     - secure deletion (s)
> >     - synchronous updates (S)
> >     - undeletable (u)
> > "
> > But in fact, very few filesystems support the (s) and (u) flags.
> > xfs and btrfs do not support them for example.
> >
> > The test doesn't need to check those specific flags, so replace those
> > flags with immutable (i) and append-only (a), which most filesystems
> > really do support.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Eryu,
> >
> > This would be a good test to cover the recent fileattr vfs changes
> > by Miklos that changed the implementation of SETFLAGS ioctl in all the
> > filesystem, only the test does not run on most of the filesystems...
> >
> > Thanks,
> > Amir.
> >
> >  tests/generic/507 | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/tests/generic/507 b/tests/generic/507
> > index b654883a..cc61b3cb 100755
> > --- a/tests/generic/507
> > +++ b/tests/generic/507
> > @@ -9,7 +9,7 @@
> >  # i_flags can be recovered after sudden power-cuts.
> >  # 1. touch testfile;
> >  # 1.1 sync (optional)
> > -# 2. chattr +[AsSu] testfile
> > +# 2. chattr +[ASai] testfile
> 
> I missed the same fix that's needed in line 8. below...

Fixed on commit, thanks for the heads-up!

Eryu

> 
> >  # 3. xfs_io -f testfile -c "fsync";
> >  # 4. godown;
> >  # 5. umount;
> > @@ -34,6 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
> >  _cleanup()
> >  {
> >         cd /
> > +       $CHATTR_PROG -ai $testfile &> /dev/null
> >         rm -f $tmp.*
> >  }
> >
> > @@ -49,7 +50,7 @@ _supported_fs generic
> >
> >  _require_command "$LSATTR_PROG" lasttr
> >  _require_command "$CHATTR_PROG" chattr
> > -_require_chattr AsSu
> > +_require_chattr ASai
> >
> >  _require_scratch
> >  _require_scratch_shutdown
> > @@ -79,7 +80,7 @@ do_check()
> >
> >         before=`$LSATTR_PROG $testfile`
> >
> > -       $XFS_IO_PROG -f $testfile -c "fsync" | _filter_xfs_io
> > +       $XFS_IO_PROG -r -f $testfile -c "fsync" | _filter_xfs_io
> >
> >         _scratch_shutdown | tee -a $seqres.full
> >         _scratch_cycle_mount
> > @@ -101,7 +102,7 @@ do_check()
> >
> >         before=`$LSATTR_PROG $testfile`
> >
> > -       $XFS_IO_PROG -f $testfile -c "fsync" | _filter_xfs_io
> > +       $XFS_IO_PROG -r -f $testfile -c "fsync" | _filter_xfs_io
> >
> >         _scratch_shutdown | tee -a $seqres.full
> >         _scratch_cycle_mount
> > @@ -122,7 +123,7 @@ do_check()
> >
> >  echo "Silence is golden"
> >
> > -opts="A s S u"
> > +opts="A S a i"
> >  for i in $opts; do
> >         do_check $i
> >         do_check $i sync
> > --
> > 2.31.1
> >
