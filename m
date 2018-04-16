Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:38129 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753022AbeDPP1v (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Apr 2018 11:27:51 -0400
MIME-Version: 1.0
In-Reply-To: <20180416104141.17134-2-mszeredi@redhat.com>
References: <20180416104141.17134-1-mszeredi@redhat.com> <20180416104141.17134-2-mszeredi@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Apr 2018 18:27:49 +0300
Message-ID: <CAOQ4uxhz4ON6HbTuv+0jdMLRtEAeDgB15bBwMLGkdSkE9Sxb1g@mail.gmail.com>
Subject: Re: [PATCH 2/2] overlay/013: do not expect failure
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Apr 16, 2018 at 1:41 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> Current test expects test_lower to fail with:
>
>   truncate(test_lower) should have failed
>
> While it is sort of okay to fail like that (the above expectation basically
> acknowledges this weirdness in the overlayfs implementation), it is by no
> means the only correct behavior: it is also correct for the test to
> succeed (i.e. truncation fails with ETXTBSY).
>
> So add an option to t_truncate_self.c that allows both success and failure,
> but obviously not SIGSEGV, which is what a we'd get in a real failure mode.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

Looks good.

Thanks,
Amir.
