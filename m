From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstest PATCH v2] overlay: test whiteout check in origin dir
Date: Wed, 28 Jun 2017 16:45:59 +0800
Message-ID: <20170628084559.GG23360@eguan.usersys.redhat.com>
References: <1498637045-19185-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751261AbdF1IqC (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 28 Jun 2017 04:46:02 -0400
Content-Disposition: inline
In-Reply-To: <1498637045-19185-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com

On Wed, Jun 28, 2017 at 04:04:05PM +0800, zhangyi (F) wrote:
> The unmerged and origined directories may contain invalid
> whiteouts when we umount && modify dir(e.g. clean up dir) and
> remount overlay. This may lead to whiteouts exposure and rmdir
> failure.
> 
> This case test origin dir's whiteouts check in ovl_iterate() and
> ovl_remove_xxx().
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
> v2:
>  - add test of lower origin dir have whiteouts
>  - add test of both upper and lower origin dirs have whiteouts
>    (although this case is pass now, still add this to cover all
>    three kinds of situations)
>  - add to whiteout group

Thanks for the updated patch! But I've already pushed your v1 patch out
to upstream, could you please send another patch to update the existing
overlay/031 test?

Thanks,
Eryu
