From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH 2/2] overlay/031: fix test with inodes index enabled
Date: Tue, 19 Sep 2017 21:02:04 +0800
Message-ID: <5365403d-e8df-5520-48d9-5d57851d1692@huawei.com>
References: <1505821184-3913-1-git-send-email-amir73il@gmail.com>
 <1505821184-3913-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:6494 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdISNCQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Sep 2017 09:02:16 -0400
In-Reply-To: <1505821184-3913-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On 2017/9/19 19:39, Amir Goldstein Wrote:
> When overlayfs is configured with CONFIG_OVERLAY_FS_INDEX=y,
> workdir from previous overlay mount cannot be reused in a new
> overlay mount that uses a different upper dir.
> 
> Fix the test to use a different workdir when mounting with a
> different upper dir.
> 
> This change has no effect on older kernels and overlay
> configured without CONFIG_OVERLAY_FS_INDEX.
> 
> Cc: zhangyi (F) <yi.zhang@huawei.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/031 | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 

Looks good.

Thanks,
Yi.
