Return-Path: <SRS0=BYJY=6D=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A596EC38A30
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 17:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 792A221473
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 17:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgDSRA0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 19 Apr 2020 13:00:26 -0400
Received: from out20-39.mail.aliyun.com ([115.124.20.39]:40966 "EHLO
        out20-39.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgDSRA0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Apr 2020 13:00:26 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07464258|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.020105-0.00152028-0.978375;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03299;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.HJuN84d_1587315611;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.HJuN84d_1587315611)
          by smtp.aliyun-inc.com(10.147.41.121);
          Mon, 20 Apr 2020 01:00:12 +0800
Date:   Mon, 20 Apr 2020 01:01:19 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] overlay/029: fix test failure with index feature enabled
Message-ID: <20200419170119.GJ388005@desktop>
References: <20200409112900.15341-1-amir73il@gmail.com>
 <20200419160635.GI388005@desktop>
 <CAOQ4uxg15=Yv3rCiKXxZqsF+5+y__foRbW_D6kfbRWhZ-gEAwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg15=Yv3rCiKXxZqsF+5+y__foRbW_D6kfbRWhZ-gEAwA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Apr 19, 2020 at 07:12:33PM +0300, Amir Goldstein wrote:
> On Sun, Apr 19, 2020 at 7:05 PM Eryu Guan <guan@eryu.me> wrote:
> >
> > On Thu, Apr 09, 2020 at 02:29:00PM +0300, Amir Goldstein wrote:
> > > When overlayfs index feature is enabled by default in either kernel
> > > config or module parameters, this test fails:
> > >
> > >     mount: /tmp/8751/mnt: mount(2) system call failed: Stale file handle.
> > >     cat: /tmp/8751/mnt/bar: No such file or directory
> > >
> > > The reason is that with index feature enabled, an upper/work dirs cannot
> > > be reused for mounting with a different lower layer.
> >
> > I re-built my test kernel with CONFIG_OVERLAY_FS_INDEX=y, and confirmed
> > /sys/module/overlay/parameters/index is 'Y', but test still passes for
> > me. And I do notice the following info in dmesg:
> >
> > [  598.663923] overlayfs: fs on '/mnt/scratch/ovl-mnt/up' does not support file handles, falling back to index=off,nfs_export=off.
> > [  598.674299] overlayfs: fs on '/mnt/scratch/ovl-mnt/low' does not support file handles, falling back to index=off,nfs_export=off.
> > [  598.684594] overlayfs: fs on '/mnt/scratch/ovl-mnt/' does not support file handles, falling back to index=off,nfs_export=off.
> >
> > Seems it has something to do with nfs_export feature? I have it disabled
> > by default.
> >
> >  # CONFIG_OVERLAY_FS_NFS_EXPORT is not set
> >
> > Could you please help confirm?
> >
> 
> I confirm. enabling index on nested overlay requires that
> the lower overlay has nfs_export enabled.

Thanks!

> 
> Missed that, but in the bug report, CONFIG_OVERLAY_FS_NFS_EXPORT
> was indeed set.

Would you please update the commit log accordingly as well?

> 
> You do not need to rebuild the kernel.
> You can reproduce the failure by setting overlay module parameter before
> running the tests.
> 
> echo Y > /sys/module/overlay/parameters/index
> echo Y > /sys/module/overlay/parameters/nfs_export

Ah, forgot about that.. it's easier now :)

Thanks,
Eryu
