From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 09/23] ovl: lookup index for directories
Date: Tue, 9 Jan 2018 15:49:42 +0100
Message-ID: <CAJfpegshDhTByqBWY1-CAs6pO1mi7RWZDoEJMUacxzwD25_rGA@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com> <1515084018-25134-10-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:40227 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758711AbeAIOto (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 09:49:44 -0500
Received: by mail-qk0-f169.google.com with SMTP id d18so8405433qke.7
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 06:49:43 -0800 (PST)
In-Reply-To: <1515084018-25134-10-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> A directory index is a directory type entry in index dir with a
> "trusted.overlay.origin" xattr containing an encoded ovl_fh of the merge
> directory upper dir inode.

While it's convenient to call this ".origin", it's not really that,
since now we are pointing to the latest incarnation of the file, which
is the opposite of origin.

Could we call it something more appropriate?

Thanks,
Miklos
