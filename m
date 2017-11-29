From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Issues with OvelayFS + 9P FS
Date: Wed, 29 Nov 2017 06:19:27 +0200
Message-ID: <CAOQ4uxhEXCDAc8aCQpdgi-PPtw+X8pyBV-HUted+R6ifqaCVUw@mail.gmail.com>
References: <20171129003254.GA3570@miguelinux-clr.zpn.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:34606 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751501AbdK2ET2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 23:19:28 -0500
In-Reply-To: <20171129003254.GA3570@miguelinux-clr.zpn.intel.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Miklos Szeredi <mszeredi@redhat.com>

On Wed, Nov 29, 2017 at 2:32 AM, Miguel Bernal Marin
<miguel.bernal.marin@linux.intel.com> wrote:
> Hi Miklos,
>
> I've seen issues when I try to use a Qemu/KVM + 9P and a Overlay FS.
>
> The issue started to show from v4.14 and I bisected the guilty commit to
>
> 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
>
> The issue is showed when ovl_iterate_real(file, ctx) is called, if I
> commented out that *if* block to just load iterate_dir(od->realfile, ctx),
> everything works fine.
>
> To reproduce the issue just create a OverlayFS and use the merged
> directory as a 9P share directory to the VM.
> You will see that the upper ONLY files/directories are seen good, but
> when you try to list the lower and merged files the process couldn't
> finish and ends with a "ls: Memory exhausted"
>
> I've tried to fix it but my knowledge is not enough on FS.
> I've done small script to reproduce the issue, they are at
> https://github.com/miguelinux/overlay-9p-issue
>

Hi Miguel,

Please try this patch:

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 7fc142d183e8..a4f8d75568ab 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -663,7 +663,10 @@ static int ovl_iterate_real(struct file *file,
struct dir_context *ctx)
                        return PTR_ERR(rdt.cache);
        }

-       return iterate_dir(od->realfile, &rdt.ctx);
+       err = iterate_dir(od->realfile, &rdt.ctx);
+       ctx->pos = rdt.ctx.pos;
+
+       return err;
 }

Thanks,
Amir.
