From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v7 10/14] ovl: Fix ovl_getattr() to get number of blocks
 from lower
Date: Fri, 17 Nov 2017 11:17:54 +0200
Message-ID: <CAOQ4uxgEPkYffDicbqJ3Nvdd59VvJq4wABwo4Vdi5sUvjNmX+A@mail.gmail.com>
References: <20171116220335.13448-1-vgoyal@redhat.com> <20171116220335.13448-11-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:36521 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdKQJRz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2017 04:17:55 -0500
Received: by mail-yb0-f178.google.com with SMTP id g184so473444ybg.3
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2017 01:17:55 -0800 (PST)
In-Reply-To: <20171116220335.13448-11-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 17, 2017 at 12:03 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If an inode has been copied up metadata only, then we need to query the
> number of blocks from lower and fill up the stat->st_blocks.
>
> We need to be careful about races where we are doing stat on one cpu and
> data copy up is taking place on other cpu. We want to return stat->st_blocks
> either from lower or stable upper and not something in between. Hence,
> ovl_has_upperdata() is called first to figure out whether block reporting
> will take place from lower or upper.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
