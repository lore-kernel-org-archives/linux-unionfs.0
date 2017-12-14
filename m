From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 1/3] common/rc: add scratch shutdown support for overlayfs
Date: Thu, 14 Dec 2017 16:46:21 +0200
Message-ID: <CAOQ4uxi3BD8-RA9AU-VUa_yumXq=e=7a5o8843F3mcMaD-Vk2g@mail.gmail.com>
References: <1513261145-127502-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:42316 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbdLNOqW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 09:46:22 -0500
In-Reply-To: <1513261145-127502-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Dec 14, 2017 at 4:19 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
> check -overlay overrides SCRATCH_MNT variable to it's own,
> so adjust target to underlying filesystem(OVL_BASE_SCRATCH_MNT)
> when running shutdown on overlayfs.
>
> Introduce a helper _scratch_shutdown to mainly handle scratch
> shutdown and convert godown to _scratch_shutdown to support
> overlayfs running on below cases.

You should do this in 2 patches:
1. replace all open coded godown calls with _scratch_shutdown helper
2. Add overlay support to _scratch_shutdown helper.

>
> generic/043
> generic/044
> generic/045
> generic/046
> generic/047
> generic/048
> generic/051
> generic/052
> generic/054
> generic/055
> generic/392
> generic/417
> generic/461
> generic/468

Really no need to specify these in change log. They already appear in diffstat.

>
> In order to avoid overlayfs running on improper shutdown
> cases, add _require_local_device $SCRATCH_DEV to below cases.

I don't understand.
In all these tests, there is already _require_scratch_shutdown.
Shouldn't that prevent overlay running improper shutdown?

Amir.
