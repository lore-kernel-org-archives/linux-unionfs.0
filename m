From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V5] overlay: Test constant d_ino feature
Date: Sun, 3 Sep 2017 16:28:35 +0300
Message-ID: <CAOQ4uxjneo5G19aktaWLsEBHEyns_Fk29zbjupTMEzgunLFw4A@mail.gmail.com>
References: <20170903131309.17699-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36155 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbdICN2g (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 3 Sep 2017 09:28:36 -0400
In-Reply-To: <20170903131309.17699-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Sun, Sep 3, 2017 at 4:13 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> This commit adds a test to verify constant d_ino feature. The following
> scenarios are checked,
> - Parent's (i.e. "..") d_ino must always be calculated because a pure
>   dir can be residing inside a merged dir.
> - d_ino for "." must always be calculated because the present directory
>   can have a copy-up origin.
> - Verify d_ino of '.' and '..' before and after dir becomes
>   impure. While at it also verify if trusted.overlay.impure xattr is
>   set/reset appropriately and invalidation of readdir cache.
> - Verify copied up file's (inside a impure dir) d_ino.
> - Verify d_ino values corresponding to "." and ".." entries of a pure
>   lower dir.
> - Verify d_ino of ".." entry of a merged dir.
> - Verify pure lower residing in dir which has another lower layer
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>
> Changelog:
> v4->v5:
> 1. Include common/attr & _require_attrs.
> 2. Check for success condition when checking for existance of
>    'trusted.overlay.impure' xattr on a pure directory.
>

Look good.
Thanks
