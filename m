From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH v6 0/3] Overlayfs fixes for exposed whiteouts
Date: Wed, 1 Nov 2017 11:12:50 +0800
Message-ID: <0b81aec4-beb5-6c01-3093-a439c37df462@huawei.com>
References: <1509486350-21362-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [45.249.212.32] ([45.249.212.32]:48108 "EHLO huawei.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752771AbdKADNf (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Oct 2017 23:13:35 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 37454D261B0CC
        for <linux-unionfs@vger.kernel.org>; Wed,  1 Nov 2017 11:13:22 +0800 (CST)
In-Reply-To: <1509486350-21362-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On 2017/11/1 5:45, Amir Goldstein Wrote:
> Miklos,
> 
> Let's call my previous version v5 (Zhangyi's last post was v4).
> 
> Changes since v5:
> - Split ovl_check_empty_and_clear() changes from bug fix patch
> - Cache "origin" xattr of non-merge dir in inode flag OVL_WHITEOUTS
>   (OVL_ORIGIN would have been too confusing)
> - Replace layer idx with is_upper boolean
> 
> I tested these changes with upstream xfstest overlay/031 by Zhangyi.
> Pushed to ovl-whiteouts branch [1] and rebased the non-samefs patches
> on top of it [2].
> 

All these three patches looks good to me, and I tested these too.

Thanks,
Yi.

> Thanks,
> Amir.
> 
> [1] https://github.com/amir73il/linux/commits/ovl-whiteouts
> [1] https://github.com/amir73il/linux/commits/overlayfs-devel
> 
> Amir Goldstein (3):
>   ovl: no direct iteration for dir with origin xattr
>   ovl: simplify ovl_check_empty_and_clear()
>   ovl: fix rmdir problem on non-merge dir with origin xattr
> 
>  fs/overlayfs/dir.c       | 18 ++++++++++------
>  fs/overlayfs/inode.c     |  5 +++++
>  fs/overlayfs/overlayfs.h |  4 ++++
>  fs/overlayfs/readdir.c   | 56 ++++++++++++++++++++++++++++++++++++++----------
>  fs/overlayfs/util.c      | 13 +++++++++++
>  5 files changed, 79 insertions(+), 17 deletions(-)
> 
