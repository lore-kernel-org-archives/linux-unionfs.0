From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v6 0/9] Overlayfs: constant st_ino/d_ino for non-samefs
Date: Thu, 2 Nov 2017 17:33:26 +0100
Message-ID: <CAJfpegsoj7HhL-_O0Y3EcrCNxDfmzwPa56hr1Uoza_NivLzU5A@mail.gmail.com>
References: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:53639 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdKBQd2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 12:33:28 -0400
Received: by mail-wm0-f45.google.com with SMTP id r196so160974wmf.2
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Nov 2017 09:33:27 -0700 (PDT)
In-Reply-To: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Nov 1, 2017 at 9:22 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> My trigger for fixing up the non-samefs patches is that I found out
> while testing NFS export that reconnecting a dir dentry doesn't work
> for non-samefs case.
> I tracked the problem down to the default implementation of get_name()
> in expfs.c that looks up a child inode in parent dir by d_ino.

That may be a good fix, but.. we shouldn't have to rely on correct
d_ino to get the name.

In fact we can just recursively call exportfs_get_name() on underlying
fs, since we have the parent and the child handle in both the dir and
non-dir cases.

Am I missing something?

Thanks,
Miklos
