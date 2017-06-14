From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3 00/23] Overlayfs inodes index
Date: Wed, 14 Jun 2017 09:30:56 +0200
Message-ID: <CAJfpegsjdep+s8WsL30M0rQU7=in_JyX1Bka2=3ELxgk=S3rZA@mail.gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34608 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdFNHa5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:30:57 -0400
Received: by mail-oi0-f65.google.com with SMTP id d99so13327777oic.1
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2017 00:30:57 -0700 (PDT)
In-Reply-To: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Wed, Jun 14, 2017 at 9:26 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> I've made all the changes we discussed on v2 review and now all
> upper/lower hardlinks are consistent. Note that I chose to invalidate
> lower indexed dentries instead of updating all aliases on first copy up
> (patch 21). That seemed simpler to me. Please let me know if you see any
> culprit with that approach.

If the alias is open, it won't receive the st_ino updates through
fstat(2) since it will still have the ref to the old dentry/old inode.
So it's more correct to update the aliases, but I guess it's also more
complex.


> I also re-introduced ovl_update_type()
> (patch 8) for easier and more compact storing of the INDEX type flag.
>
> The remaining work on persistent nlink accounting and orphan index
> cleanup is left for a differnt posting. Without that complementary work,
> the index entries will remain forever. I am not aware of any other
> culprit or correctness issues that may arrise from lack of index cleanup.
>
> This work introduces the inodes index opt-in feature, which provides:
> - Hardlinks are not broken on copy up
> - Infrastructure for overlayfs NFS export
>
> The work is available on my ovl-hardlinks branch [1].
> For the curious, documentation about how overlay NFS export would work
> with the inodes index is available in the linked commit [2].
>
> The most significant change w.r.t. vfs is that with inodes index,
> overlay inodes are hashed and unique throughout the lifecycle of an
> overlay object (i.e. across copy up). This is required for not breaking
> hardlinks on copy up.
>
> Hardlink copy up tests including coverage for concurrent copy up of
> lower hardlinks and lower/upper hardlinks consistency are available on
> my xfstests dev branch [3].
>
> This work also fixes constant st_ino for samefs case for lower hardlinks,
> so the few constant st_ino tests that fail on v4.12-rc1 due to copy up of
> lower hardlinks now pass [3][4].

Thanks, will have a look though.

Miklos
