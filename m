Return-Path: <SRS0=bzPr=62=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86723C2D0F6
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 May 2020 16:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71070206B8
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 May 2020 16:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgELQZg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 May 2020 12:25:36 -0400
Received: from out20-26.mail.aliyun.com ([115.124.20.26]:35242 "EHLO
        out20-26.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgELQZg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 May 2020 12:25:36 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07555328|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.37468-0.00325523-0.622065;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03278;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.HXUx9vw_1589300732;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.HXUx9vw_1589300732)
          by smtp.aliyun-inc.com(10.147.40.26);
          Wed, 13 May 2020 00:25:32 +0800
Date:   Wed, 13 May 2020 00:25:32 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     miklos <miklos@szeredi.hu>, amir73il <amir73il@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-unionfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH v4] overlay: test for whiteout inode sharing
Message-ID: <20200512162532.GD9345@desktop>
References: <20200506101528.27359-1-cgxu519@mykernel.net>
 <20200510155037.GB9345@desktop>
 <172015c8691.108177c8110122.924760245390345571@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <172015c8691.108177c8110122.924760245390345571@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, May 11, 2020 at 09:32:20AM +0800, Chengguang Xu wrote:
>  ---- 在 星期日, 2020-05-10 23:50:37 Eryu Guan <guan@eryu.me> 撰写 ----
>  > On Wed, May 06, 2020 at 06:15:28PM +0800, Chengguang Xu wrote:
>  > > This is a test for whiteout inode sharing feature.
>  > > 
>  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>  > > ---
>  > > v1->v2:
>  > > - Address Amir's comments in v1
>  > > 
>  > > v2->v3:
>  > > - Address Amir's comments in v2 
>  > > 
>  > > v3->v4:
>  > > - Fix test case based on latest kernel patch(removed module param)
>  > > https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git/commit/?h=overlayfs-next&id=4e49695244661568130bfefcb6143dd1eaa3d8e7
>  > > 
>  > >  tests/overlay/073     | 106 ++++++++++++++++++++++++++++++++++++++++++
>  > >  tests/overlay/073.out |   2 +
>  > >  tests/overlay/group   |   1 +
>  > >  3 files changed, 109 insertions(+)
>  > >  create mode 100755 tests/overlay/073
>  > >  create mode 100644 tests/overlay/073.out
>  > > 
>  > > diff --git a/tests/overlay/073 b/tests/overlay/073
>  > > new file mode 100755
>  > > index 00000000..fc847092
>  > > --- /dev/null
>  > > +++ b/tests/overlay/073
>  > > @@ -0,0 +1,106 @@
>  > > +#! /bin/bash
>  > > +# SPDX-License-Identifier: GPL-2.0
>  > > +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
>  > > +# All Rights Reserved.
>  > > +#
>  > > +# FS QA Test 073
>  > > +#
>  > > +# Test whiteout inode sharing functionality.
>  > > +#
>  > > +# A "whiteout" is an object that has special meaning in overlayfs.
>  > > +# A whiteout on an upper layer will effectively hide a matching file
>  > > +# in the lower layer, making it appear as if the file didn't exist.
>  > > +#
>  > > +# Whiteout inode sharing means multiple whiteout objects will share
>  > > +# one inode in upper layer, without this feature every whiteout object
>  > > +# will consume one inode in upper layer.
>  > > +
>  > > +seq=`basename $0`
>  > > +seqres=$RESULT_DIR/$seq
>  > > +echo "QA output created by $seq"
>  > > +
>  > > +here=`pwd`
>  > > +tmp=/tmp/$
>  > > +status=1    # failure is the default!
>  > > +trap "_cleanup; exit \$status" 0 1 2 3 15
>  > > +
>  > > +_cleanup()
>  > > +{
>  > > +    cd /
>  > > +    rm -f $tmp.*
>  > > +}
>  > > +
>  > > +# get standard environment, filters and checks
>  > > +. ./common/rc
>  > > +. ./common/filter
>  > > +
>  > > +# remove previous $seqres.full before test
>  > > +rm -f $seqres.full
>  > > +
>  > > +# real QA test starts here
>  > > +_supported_fs overlay
>  > > +_supported_os Linux
>  > > +_require_scratch
>  > 
>  > I see no feature detection logic, so test just fails on old kernels
>  > without this feature? I tried with v5.7-r4 kernel, test fails because
>  > each whiteout file has only one hardlink.
>  
> That's true.

I'd like to see it _notrun on old kernels where the feature is not
available. But that seems hard to do.. Do you have any better ideas?

Thanks,
Eryu
