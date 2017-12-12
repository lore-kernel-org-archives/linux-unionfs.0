From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 1/3] common/rc: add scratch shutdown support for overlayfs
Date: Tue, 12 Dec 2017 07:58:03 +0200
Message-ID: <CAOQ4uxhPBNPONsMVNh-nDrZWPAdsofbGEyBgFPNPym3wt=dn7A@mail.gmail.com>
References: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:37106 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdLLF6F (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Dec 2017 00:58:05 -0500
In-Reply-To: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Dec 12, 2017 at 5:09 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
> OverlayFS overrides SCRATCH_MNT variable to it's own,
> so adjust target to underlying filesystem(OVL_BASE_SCRATCH_MNT)
> when running shutdown on overlayfs.
>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---

Maybe "check -overlay overrides SCRATCH_MNT...

Otherwise, looks good.

Amir.
