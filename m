Return-Path: <SRS0=BYJY=6D=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B22C38A30
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 16:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35113214D8
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 16:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgDSQFc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 19 Apr 2020 12:05:32 -0400
Received: from out20-63.mail.aliyun.com ([115.124.20.63]:59130 "EHLO
        out20-63.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgDSQFb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Apr 2020 12:05:31 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07493297|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.31701-0.00379837-0.679192;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03267;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.HJtJTds_1587312327;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.HJtJTds_1587312327)
          by smtp.aliyun-inc.com(10.147.44.118);
          Mon, 20 Apr 2020 00:05:27 +0800
Date:   Mon, 20 Apr 2020 00:06:35 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] overlay/029: fix test failure with index feature enabled
Message-ID: <20200419160635.GI388005@desktop>
References: <20200409112900.15341-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200409112900.15341-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 09, 2020 at 02:29:00PM +0300, Amir Goldstein wrote:
> When overlayfs index feature is enabled by default in either kernel
> config or module parameters, this test fails:
> 
>     mount: /tmp/8751/mnt: mount(2) system call failed: Stale file handle.
>     cat: /tmp/8751/mnt/bar: No such file or directory
> 
> The reason is that with index feature enabled, an upper/work dirs cannot
> be reused for mounting with a different lower layer.

I re-built my test kernel with CONFIG_OVERLAY_FS_INDEX=y, and confirmed
/sys/module/overlay/parameters/index is 'Y', but test still passes for
me. And I do notice the following info in dmesg:

[  598.663923] overlayfs: fs on '/mnt/scratch/ovl-mnt/up' does not support file handles, falling back to index=off,nfs_export=off.
[  598.674299] overlayfs: fs on '/mnt/scratch/ovl-mnt/low' does not support file handles, falling back to index=off,nfs_export=off.
[  598.684594] overlayfs: fs on '/mnt/scratch/ovl-mnt/' does not support file handles, falling back to index=off,nfs_export=off.

Seems it has something to do with nfs_export feature? I have it disabled
by default.

 # CONFIG_OVERLAY_FS_NFS_EXPORT is not set

Could you please help confirm?

Thanks,
Eryu

> 
> Reported-by: Chengguang Xu <cgxu519@mykernel.net>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/029 | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tests/overlay/029 b/tests/overlay/029
> index 1d2d2092..17f58de7 100755
> --- a/tests/overlay/029
> +++ b/tests/overlay/029
> @@ -68,12 +68,18 @@ _overlay_mount_dirs $SCRATCH_MNT/up $tmp/{upper,work} \
>  cat $tmp/mnt/foo
>  $UMOUNT_PROG $tmp/mnt
>  
> +# re-create upper/work to avoid ovl_verify_origin() mount failure
> +# when index is enabled
> +rm -rf $tmp/{upper,work}
> +mkdir -p $tmp/{upper,work}
>  # mount overlay again using lower dir from SCRATCH_MNT dir
>  _overlay_mount_dirs $SCRATCH_MNT/low $tmp/{upper,work} \
>    overlay $tmp/mnt
>  cat $tmp/mnt/bar
>  $UMOUNT_PROG $tmp/mnt
>  
> +rm -rf $tmp/{upper,work}
> +mkdir -p $tmp/{upper,work}
>  # mount overlay again using SCRATCH_MNT dir
>  _overlay_mount_dirs $SCRATCH_MNT/ $tmp/{upper,work} \
>    overlay $tmp/mnt
> -- 
> 2.17.1
> 
