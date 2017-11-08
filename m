From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v8 0/9] Overlayfs: constant st_ino/d_ino for non-samefs
Date: Wed, 8 Nov 2017 11:53:15 +0100
Message-ID: <CAJfpegvBEXgi=P8Sciv+U6VqcjsLJChR1OdwZyZA_PoL3MNTNA@mail.gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:56758 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdKHKxR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Nov 2017 05:53:17 -0500
Received: by mail-wm0-f43.google.com with SMTP id z3so9806744wme.5
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Nov 2017 02:53:17 -0800 (PST)
In-Reply-To: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Nov 7, 2017 at 5:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> This version provides a solution for some interesting non-samefs cases:
> - All the ext* family
> - Many other fs with default encode_fh
> - xfs that is not huge with overlay 'xino' mount option
> - tmpfs that is not on a machine with jurassic uptime with 'xino'
>
> I tested this with Chandan's upstream overlay/041 xfstest for
> consistent d_ino in non-samefs setup. Results are:
> - Test passes for ext4
> - Test fails for xfs
> - Test fails for xfs with OVERLAY_MOUNT_OPTIONS=-oxino,
>   but this is because of a test bug
> - With the test bug fix available at [2] test passes
>   with xfs and OVERLAY_MOUNT_OPTIONS=-oxino
>
> All the exportfs tests also pass with these changes and
> either ext4 or xfs with OVERLAY_MOUNT_OPTIONS=-oxino.
>
> Changes since v7:
> - Drop patches for building impure cache for non-samefs subdirs
> - Dropped patch "update cache version of impure parent on rename"
>   because it is not relevant to this series
> - Remap lower inode numbers for 32bit inode file systems
> - Add mount option 'xino' for opting-in to use high inode bits

I the meantime I went and committed v7 (with the noted changes) and
based my cleanup for ovl_fill_super() on top of that.  So that's now
pushed out to overlayfs-next, hopefully not invalidating too much of
your work.

The -oxino patches are interesting, but maybe we should leave them
brewing for another cycle.  Do you agree?

I'll try and look at the other series posted by you and Vivek to see
what else would fit in to 4.15.

Thanks,
Miklos
