From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: avoid setting uninitialized creds
Date: Mon, 19 Sep 2016 16:53:14 +0200
Message-ID: <CAJfpegtpmP+tZ4cQHEO7tOpA0aLBfc1x-mrrpO5m4+pzaAc+Jw@mail.gmail.com>
References: <20160919123859.1335236-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36177 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbcISOxQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Sep 2016 10:53:16 -0400
Received: by mail-oi0-f65.google.com with SMTP id i193so3501948oib.3
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Sep 2016 07:53:15 -0700 (PDT)
In-Reply-To: <20160919123859.1335236-1-arnd@arndb.de>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andreas Gruenbacher <agruenba@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org

On Mon, Sep 19, 2016 at 2:38 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> If the call to ovl_copy_up() fails, we now call revert_creds on
> an uninitialized structure after a recent patch, as found
> by "gcc -Wmayby-uninitialized":
>
> fs/overlayfs/inode.c: In function 'ovl_open_maybe_copy_up':
> fs/overlayfs/inode.c:39:2: error: 'old_cred' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> fs/overlayfs/inode.c:22:21: note: 'old_cred' was declared here
>
> This changes the code back to not call revert_creds unless
> we have already called ovl_override_creds().

Thanks.   Slightly reworked fix folded into original patch and pushed out.

Thanks,
Miklos
