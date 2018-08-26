Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:42213 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbeHZSee (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 26 Aug 2018 14:34:34 -0400
MIME-Version: 1.0
References: <1513324055-77618-1-git-send-email-cgxu519@icloud.com> <1513324055-77618-3-git-send-email-cgxu519@icloud.com>
In-Reply-To: <1513324055-77618-3-git-send-email-cgxu519@icloud.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 26 Aug 2018 17:53:33 +0300
Message-ID: <CAOQ4uxgf=btK-MKed7-8_nmpfO-UnPyVJ4RyTtK1hMQuU8Y=-g@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] generic/471: add syncfs test
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Dec 15, 2017 at 9:48 AM Chengguang Xu <cgxu519@icloud.com> wrote:
>
> Inspired by syncfs bug of overlayfs which does not sync dirtyinodes in
> underlying filesystem.
> Run syncfs and shutdown filesystem(or underlying filesystem of overlayfs)
> to check syncfs result.
>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---

Hi Chengguang,

I just noticed that this test (now generic/474) is skipped for overlay over ext4
for a strange looking reason - it seems that in the overlay_mount() call from
_scratch_cycle_mount() the function hits
_notrun "upper fs needs to support d_type".

This doesn't happen on my test system with overlay over xfs.
Did you happen to test this with overlay over ext4 at the time?
Will you have time to look into this?

Thanks,
Amir.
