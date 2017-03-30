From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Question about ovl_dentry_weird
Date: Thu, 30 Mar 2017 14:48:45 +0800
Message-ID: <f3a67b6a-b8fb-78ab-fadd-504fa5d76a10@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:4813 "EHLO
        dggrg01-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S932228AbdC3Gs7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Mar 2017 02:48:59 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miaoxie@huawei.com, laiyuanyuan.lai@huawei.com, miklos@szeredi.hu

Hi:
Current overlayfs does not support underlying filesystem which have "weird" d_flags (like DCACHE_OP_HASH£¬
DCACHE_OP_COMPARE, DCACHE_OP_REVALIDATE, etc). So we cannot support fs have it's own d_hash, d_compare and
d_revalidate functions.

Do you have a TODO plan to support it in a future version ?

Thanks,
ZhangYi.
