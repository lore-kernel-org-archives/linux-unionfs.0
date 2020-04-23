Return-Path: <SRS0=+0RS=6H=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E02DAC2BA19
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Apr 2020 07:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB954208E4
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Apr 2020 07:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgDWHGf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 03:06:35 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:50770 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbgDWHGf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 23 Apr 2020 03:06:35 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TwPK2fc_1587625558;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0TwPK2fc_1587625558)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Apr 2020 15:06:18 +0800
Subject: Re: [PATCH] overlayfs: set MS_NOSEC flag for overlayfs
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        amir73il@gmail.com
Cc:     joseph.qi@linux.alibaba.com
References: <1587625038-55484-1-git-send-email-jefflexu@linux.alibaba.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <4898364f-e6e9-72e2-9b28-9a3a8f297ad4@linux.alibaba.com>
Date:   Thu, 23 Apr 2020 15:03:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1587625038-55484-1-git-send-email-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

It seems that MS_NOSEC flag would be problematic for network filesystems.


@Amir, would you please give some suggestions on if this would break the

permission control down when 'NFS export' feature enabled ?


On 4/23/20 2:57 PM, Jeffle Xu wrote:
> Since the stacking of regular file operations [1], the overlayfs
> edition of write_iter() is called when writing regular files.
>
> Since then, xattr lookup is needed on every write since file_remove_privs()
> is called from ovl_write_iter(), which would become the performance
> bottleneck when writing small chunks of data. In my test case,
> file_remove_privs() would consume ~15% CPU when running fstime of
> unixbench (the workload is repeadly writing 1 KB to the same file) [2].
>
> Set the MS_NOSEC flag for overlayfs superblock. Since then xattr lookup
> would be done only once on the first write. Unixbench fstime gets a ~20%
> performance gain with this patch.
>
> [1] https://lore.kernel.org/lkml/20180606150905.GC9426@magnolia/T/
> [2] https://www.spinics.net/lists/linux-unionfs/msg07153.html
>
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>   fs/overlayfs/super.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 732ad54..0b047ce 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1817,7 +1817,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>   	sb->s_magic = OVERLAYFS_SUPER_MAGIC;
>   	sb->s_xattr = ovl_xattr_handlers;
>   	sb->s_fs_info = ofs;
> -	sb->s_flags |= SB_POSIXACL;
> +	sb->s_flags |= (SB_POSIXACL | SB_NOSEC);
>   
>   	err = -ENOMEM;
>   	root_dentry = ovl_get_root(sb, upperpath.dentry, oe);
