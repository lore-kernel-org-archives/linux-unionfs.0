From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH xfstests 1/2] overlay: test relatime for directories
Date: Thu, 14 Sep 2017 16:07:57 +0300
Message-ID: <CAOQ4uxjWqLD2J4ReYTihjeA03VOTDpeoBC7c4u4cnzSOZR2k1w@mail.gmail.com>
References: <1505390643-6981-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:56070 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdINNH6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Sep 2017 09:07:58 -0400
In-Reply-To: <1505390643-6981-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On Thu, Sep 14, 2017 at 3:04 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Add test access time update issue for directories in upper layer.
>
> Upstream commit cd91304e7190 ("ovl: fix relatime for directories")
> fixed this issue.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Looks good.
Thanks
