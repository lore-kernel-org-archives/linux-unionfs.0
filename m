From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 17/23] ovl: whiteout index when union nlink drops to zero
Date: Tue, 9 Jan 2018 17:28:23 +0100
Message-ID: <CAJfpegth4_NaeWLskFnd1uWrwXtJFkr72ps7LLDnngmvjPXP4A@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com> <1515084018-25134-18-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:44746 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758807AbeAIQ2Z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 11:28:25 -0500
Received: by mail-qk0-f172.google.com with SMTP id u76so422054qku.11
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 08:28:24 -0800 (PST)
In-Reply-To: <1515084018-25134-18-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> With the 'verify' feature enabled, when overlay inode nlink drops to
> zero, instead of removing the index entry, replace it with a whiteout
> index entry.
>
> This is needed for NFS export in order to prevent future open by handle
> from opening the lower file directly.

Just thinking out loud: how could we get rid of index whiteouts in the
"rm -rf" case?  Only way is if encoding parent as well, and we
recursively check for a whiteout in the ancestors.   Probably not
worth bothering with in the first version, but later maybe?

Thanks,
Miklos
