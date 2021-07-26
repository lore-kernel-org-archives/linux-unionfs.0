Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9499C4338F
	for <linux-unionfs@archiver.kernel.org>; Mon, 26 Jul 2021 03:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A72060698
	for <linux-unionfs@archiver.kernel.org>; Mon, 26 Jul 2021 03:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhGZCcf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 25 Jul 2021 22:32:35 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:52721 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230272AbhGZCce (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Jul 2021 22:32:34 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=eguan@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UgvrbTc_1627269182;
Received: from localhost(mailfrom:eguan@linux.alibaba.com fp:SMTPD_---0UgvrbTc_1627269182)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 26 Jul 2021 11:13:02 +0800
Date:   Mon, 26 Jul 2021 11:13:02 +0800
From:   Eryu Guan <eguan@linux.alibaba.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guan@eryu.me>, Eryu Guan <guaneryu@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] overlay: add test for copy up of lower file attributes
Message-ID: <20210726031302.GL60846@e18g06458.et15sqa>
References: <20210722164634.394499-1-amir73il@gmail.com>
 <YP2Q+xTjGICXfOwl@desktop>
 <CAOQ4uxihqmRPms8Cedam7wT5dPAMFYA96DrFBJwUfLh+J9MJLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxihqmRPms8Cedam7wT5dPAMFYA96DrFBJwUfLh+J9MJLg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jul 25, 2021 at 09:21:03PM +0300, Amir Goldstein wrote:
> On Sun, Jul 25, 2021 at 7:27 PM Eryu Guan <guan@eryu.me> wrote:
> >
> > On Thu, Jul 22, 2021 at 07:46:34PM +0300, Amir Goldstein wrote:
> > > Overlayfs copies up a subset of lower file attributes since kernel
> > > commits:
> > > 173ff5c9ec37 ("ovl: consistent behavior for immutable/append-only inodes")
> > > 2e3f6e87c2b0 ("ovl: copy up sync/noatime fileattr flags")
> > >
> > > This test verifies this functionality works correctly and that it
> > > survives power failure and/or mount cycle.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >
> > Looks good to me overall, just one minor question below.
> >
> > > ---
> > >
> > > Eryu,
> > >
> > > This test is failing on master and passes on overlayfs-next.
> > >
> > > Thanks,
> > > Amir.
> > >
> > >  tests/overlay/078     | 145 ++++++++++++++++++++++++++++++++++++++++++
> > >  tests/overlay/078.out |   2 +
> > >  2 files changed, 147 insertions(+)
> > >  create mode 100755 tests/overlay/078
> > >  create mode 100644 tests/overlay/078.out
> > >
> > > diff --git a/tests/overlay/078 b/tests/overlay/078
> > > new file mode 100755
> > > index 00000000..b43449d1
> > > --- /dev/null
> > > +++ b/tests/overlay/078
> > > @@ -0,0 +1,145 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2018 Huawei.  All Rights Reserved.
> > > +# Copyright (C) 2021 CTERA Networks. All Rights Reserved.
> > > +#
> > > +# FS QA Test 078
> > > +#
> > > +# Test copy up of lower file attributes.
> > > +#
> > > +# Overlayfs copies up a subset of lower file attributes since kernel commits:
> > > +# 173ff5c9ec37 ("ovl: consistent behavior for immutable/append-only inodes")
> > > +# 2e3f6e87c2b0 ("ovl: copy up sync/noatime fileattr flags")
> > > +#
> > > +# This test is similar and was derived from generic/507, but instead
> > > +# of creating new files which are created in upper layer, prepare
> > > +# the file with attributes in lower layer and verify that attributes
> > > +# are not lost during copy up, (optional) shutdown and mount cycle.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick perms shutdown
> >
> > I noticed that generic/507 has the same groups defined, but I'm
> > wondering if 'perms' is right group, 'attr' seems a better fit to me.
> 
> The term "attr" is now very much overloaded in filesystems.
> It may refer to info of stat() (i.e. getattr())
> it my refer to xattr and it may refer to lsattr/chattr,
> which is referred to as fileattr in latest vfs API.
> 
> In fstests, most of the tests in the 'attr' group include
> ./common/attr which refers to ACL xattrs in particular...
> so it is not a good fit IMO.
> 
> The group 'perm' is already used for overlayfs tests that deal with
> immutable files and generic tests that deal with immutable files
> don't really have a common group AFAICT.

Makes sense to me. Then I'll take 'perm' for now.

> 
> I have no objection for creating a new group for this
> purpose but that would involve marking all related tests and worse...
> ...finding a name for that group ;-)

Yeah, naming is always a problem :)

> 
> > And we could add 'copyup' group as well.
> >
> 
> Sure.
> 
> > > +
> > > +# Override the default cleanup function.
> > > +_cleanup()
> > > +{
> > > +     cd /
> > > +     $CHATTR_PROG -ai $lowertestfile &> /dev/null
> > > +     rm -f $tmp.*
> > > +}
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +
> > > +# real QA test starts here
> > > +_supported_fs generic
> >
> > s/generic/overlay/
> 
> Oops. I assume you would be fix this typo on commit.

Sure, I'll pick it up in next week's update and fix supported fs and add
copyup group.

Thanks,
Eryu
