Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:47093 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751183AbeDPP1U (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Apr 2018 11:27:20 -0400
MIME-Version: 1.0
In-Reply-To: <20180416104141.17134-1-mszeredi@redhat.com>
References: <20180416104141.17134-1-mszeredi@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Apr 2018 18:27:19 +0300
Message-ID: <CAOQ4uxjtcKFvKq2orqTKQtW0VMb5hJKc8-7AATOY=GP5XGvZfg@mail.gmail.com>
Subject: Re: [PATCH 1/2] overlay/40: clean up properly after setting immutable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Apr 16, 2018 at 1:41 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> Test program expects only immutable on lower layer (test failure), but does
> not expect the immutable file to be on the upper layer.  The later case is
> actually what *should* happen, except overlayfs didn't properly implement
> this case yet (but is now in the works).
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

Looks good.

Thanks,
Amir.
