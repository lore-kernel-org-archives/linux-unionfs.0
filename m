From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: Cleanup redundant blank lines
Date: Wed, 26 Nov 2014 10:16:59 +0100
Message-ID: <CAJfpegvUorbwcGTtw9m7hcXFv=C0=FFUMgdbRZQ+WKEtEvLZ3Q@mail.gmail.com>
References: <54758C7B.6040402@huawei.com>
	<54759840.3050101@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:63262 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaKZJRA (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 26 Nov 2014 04:17:00 -0500
Received: by mail-qg0-f49.google.com with SMTP id a108so1700726qge.8
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Nov 2014 01:16:59 -0800 (PST)
In-Reply-To: <54759840.3050101@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: linux-unionfs@vger.kernel.org

On Wed, Nov 26, 2014 at 10:07 AM, hujianyang <hujianyang@huawei.com> wrote:
> Hi Miklos,
>
> Will you apply my previous patch "ovl: Use macros to present
> ovl_xattr"? These two patches(previous one and this one) are
> based on branch *overlayfs-current* and conflict with each
> other.
>
> I don't know which branch I should use, overlayfs-current or
> overlayfs-next. How could I join the development?

If it's a bugfix, then do it against -current.  If it's a cleanup
patch, like the one you did, do it against -next.

> By the way, do you think we can make use of "kmem_cache" to
> manage "struct ovl_entry"? I think it will speedup operations
> like *ls*. I saw your work about multi-layer support. The size
> of "struct ovl_entry" will be variable. In addition, some free
> paths of ovl_entry rely on RCU. So maybe it's not easy.

With the multi-layer support in overlayfs-next "struct ovl_entry"
becomes variable sized, so we can't use kmem_cache for it.

Thanks,
Miklos
