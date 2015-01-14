From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Allow non-workdir mount in overlayfs?
Date: Wed, 14 Jan 2015 10:55:03 +0100
Message-ID: <CAJfpegsCdRkw6unNM5txd8ZJvvw-X=v_LEw=iMVUvDPox1O_EA@mail.gmail.com>
References: <54B5D862.3010600@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:52582 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbbANJzE (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 14 Jan 2015 04:55:04 -0500
Received: by mail-qg0-f42.google.com with SMTP id q108so6185536qgd.1
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jan 2015 01:55:03 -0800 (PST)
In-Reply-To: <54B5D862.3010600@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: Seunghun Lee <waydi1@gmail.com>, linux-unionfs@vger.kernel.org

On Wed, Jan 14, 2015 at 3:45 AM, hujianyang <hujianyang@huawei.com> wrote:
> Hi Miklos,
>
> I was considering the "FIXME: workdir is not needed for a R/O mount"
> you left in ovl_fill_super() these days.
>
> Actually Seunghun (Seunghun Lee <waydi1@gmail.com>) has sent a patch
> about these problem. But I have some different ideas. I think there are
> two ways to fix this problem. One, just remove this *FIXME*. Another,
> Allow non-workdir mount.
>
> 1) Remove *FIXME*; Further, use workdir in R/W case only
>
> As multi-layer mount are allowed in ovl, users could initialize a R/O
> mount by setting multi lower directories. Workdir should only be used
> in R/W case with upperdir exist. So this *FIXME* can be removed.
>
> We should add some information in the code and document about this.

I'd vote for this.

If there's no workdir, just use multiple lowedirs.

If there is a workdir, then specify it (and overlay can still be
mounted R/O, possibly remounted R/W)

Thanks,
Miklos
