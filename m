From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH xfstests 2/2] overlay: test chattr lower file in overlay
Date: Thu, 14 Sep 2017 16:07:25 +0300
Message-ID: <CAOQ4uxhqzXQ9uE-OyDpzZybjPp2odKGMtQJVQk-a66wi9gsrpg@mail.gmail.com>
References: <1505390643-6981-1-git-send-email-yi.zhang@huawei.com> <1505390643-6981-2-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:46853 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdINNH3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Sep 2017 09:07:29 -0400
In-Reply-To: <1505390643-6981-2-git-send-email-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On Thu, Sep 14, 2017 at 3:04 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> chattr with [iap..] attributes open file for read-only and
> invoke ioctl(). If we chattr a lower file in overlay, it
> will get the lower file but not trigger copy-up, so ioctl()
> lead to modification of that lower file incorrectly. Add this
> test for this case.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---

Looks good.
Thanks
