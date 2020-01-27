From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] fs/overlayfs: add splice file read write helper
Date: Mon, 27 Jan 2020 12:04:52 +0100
Message-ID: <CAJfpegvn+eOQVoAKiv1mSuZcFacdDVKPHo4gtkt-=d5+9_mDJA@mail.gmail.com>
References: <20200117124929.6nhgpd7mgcbwae5z@xzhoux.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38767 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729764AbgA0Lcw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Jan 2020 06:32:52 -0500
Received: by mail-qk1-f194.google.com with SMTP id k6so9214276qki.5
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Jan 2020 03:32:51 -0800 (PST)
In-Reply-To: <20200117124929.6nhgpd7mgcbwae5z@xzhoux.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Murphy Zhou <jencce.kernel@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jan 17, 2020 at 1:49 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> Now overlayfs falls back to use default file splice read
> and write, which is not compatiple with overlayfs, returning
> EFAULT. xfstests generic/591 can reproduce part of this.
>
> Tested this patch with xfstests auto group tests.

Thanks, applied.

Miklos
