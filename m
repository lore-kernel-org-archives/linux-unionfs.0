From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/3] Overlayfs restoring of origin fh
Date: Thu, 9 Nov 2017 11:07:17 +0100
Message-ID: <CAJfpegu__w=VnxxVhm=FtGCUFkNdjLdB56S2tQ6mMTwwEqPV0w@mail.gmail.com>
References: <1510090740-7216-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:50464 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753798AbdKIKHT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 05:07:19 -0500
Received: by mail-wr0-f196.google.com with SMTP id p96so5046347wrb.7
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Nov 2017 02:07:18 -0800 (PST)
In-Reply-To: <1510090740-7216-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Nov 7, 2017 at 10:38 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> This series is complementary to the whiteouts expose patches.
> Patch 2 restores origin xattr on lookup of merge dir (that was copied up
> before v4.12).
> Patch 3 sets a 'null' origin fh on dir if we happen to iterate an 'impure'
> dir and find a whiteout while looking for copy ups. This is expected to
> happen if merge dir was copied up before v4.12, but files inside it were
> copied up after v4.12.

Applied 1/3.

Does the other two patches have any real usecase?   AFAICS this is not
fixing a backward compatibility issue, so I'm sceptical of the value.

Even if there was a real usecase, we could introduce an "fsck.overlay"
utility that would fix up overlays to be able to take advantage of new
features.

Thanks,
Miklos
