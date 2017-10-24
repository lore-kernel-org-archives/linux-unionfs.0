From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/4] Overlayfs index features
Date: Tue, 24 Oct 2017 18:30:27 +0300
Message-ID: <CAOQ4uxhxOTRYsuOWiAxHEanRcVZHsnSDAj2D7Y78FgDzqEA-pg@mail.gmail.com>
References: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:46424 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932141AbdJXPa2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Oct 2017 11:30:28 -0400
Received: by mail-yw0-f196.google.com with SMTP id t71so15398052ywc.3
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2017 08:30:28 -0700 (PDT)
In-Reply-To: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Oct 24, 2017 at 1:02 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> This series is an attempt not to repeat the mistakes of the past
> w.r.t. overlayfs features.
>
> I have given a lot of though about how to scale up with more
> compat/incompat features instead of an ever growing disclaimer matrix
> in overlafs/Kconfig.
>
> My proposed solution only covers features compatibility among
> sub-features of index or features which rely on index being enabled.
> There is also a best effort attempt to impose features compatibility
> as far as v3.18 using a trick with a dirty work dir.
>
> Although this series is based on the stable fix patch "ovl: do not
> cleanup unsupported index entries", it does NOT rely on the fix being
> applied on v4.13 kernel for correct behavior on downgrade.
>
> The first use case for incompat index features is going to be index=all
> for NFS export - probably rocompat, not sure yet.

Pushed example of that use to:
https://github.com/amir73il/linux/commits/ovl-index-all
(commit "ovl: add support for mount option index=all")

It required some changes to last patch of this series
in order to check not only that feature is "supported" by
kernel, but also that feature is "enabled", i.e. kernel
refuses to let user mount without index=all if index_all
feature has already been enabled by a previous mount.
Pushed changes to:
https://github.com/amir73il/linux/commits/ovl-features

>
> I don't think there is anything is this that should be backported
> to v4.13 or rushed into v4.14.
> What do you think?
>
> Amir.
>
> Amir Goldstein (4):
>   ovl: introduce incompatible index feature
>   ovl: declare index feature backward compatible
>   ovl: cast a shadow of incomapt index into the past
>   ovl: check incompat/rocompat index features
>
>  fs/overlayfs/Kconfig     |  25 ++++++++---
>  fs/overlayfs/dir.c       |  66 +++++++++++++++++++++++++++++
>  fs/overlayfs/overlayfs.h |  20 ++++++++-
>  fs/overlayfs/readdir.c   | 108 +++++++++++++++++++++++++++++++++++++++++++----
>  fs/overlayfs/super.c     |  50 ++++++++++++++++++++--
>  fs/overlayfs/util.c      | 105 +++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 354 insertions(+), 20 deletions(-)
>
> --
> 2.7.4
>
