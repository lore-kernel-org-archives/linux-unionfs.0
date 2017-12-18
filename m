From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix overlay: warning prefix
Date: Mon, 18 Dec 2017 14:19:52 +0200
Message-ID: <CAOQ4uxi9SMM6YY1SYKOns3S4jEa0cuHDt+DiHo8ThSSMWCTgFw@mail.gmail.com>
References: <1511375254-15206-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f182.google.com ([209.85.213.182]:38257 "EHLO
        mail-yb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757998AbdLRMTx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Dec 2017 07:19:53 -0500
In-Reply-To: <1511375254-15206-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, stable <stable@vger.kernel.org>

On Wed, Nov 22, 2017 at 8:27 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Conform two stray warning messages to the standard overlayfs: prefix.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Greg,

Upstream commit ("da2e6b7eeda8 ovl: fix overlay: warning prefix")
was not marked for stable, because it is not a bug fix per-se.
Nevertheless, it may be useful to apply it to stable kernels to keep
overlayfs bug reports/analysis consistent.

The first hunk fixes (#v4.10):
a6c606551141 ovl: redirect on rename-dir

The second hunk fixes (#v4.14):
b5efccbe0a12 ovl: constant d_ino across copy up

For your consideration.
If you wish, I can send a patch for v4.10 with just the first hunk.

Thanks,
Amir.
