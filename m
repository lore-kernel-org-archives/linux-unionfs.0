From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 08/20] ovl: lookup index entry for non-dir
Date: Thu, 8 Jun 2017 14:11:57 +0200
Message-ID: <CAJfpegsDv__Er79=m824pioYXnVeFP3ZCnDEvz0Ync5KnUSpwQ@mail.gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com> <1496821884-5178-9-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:36569 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdFHMMF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Jun 2017 08:12:05 -0400
Received: by mail-ot0-f181.google.com with SMTP id i31so22143415ota.3
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Jun 2017 05:12:04 -0700 (PDT)
In-Reply-To: <1496821884-5178-9-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Wed, Jun 7, 2017 at 9:51 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> When inodes index feature is enabled, lookup in indexdir for the index
> entry of lower real inode or copy up origin inode. The index entry name
> is the hex representation of the lower inode file handle.
>
> If the index dentry in negative, then either no lower aliases have been
> copied up yet, or aliases have been copied up in older kernels and are
> not indexed.
>
> If the index dentry for a copy up origin inode is positive, but points
> to an inode different than the upper inode, then either the upper inode
> has been copied up and not indexed or it was indexed, but since then
> index dir was cleared. Either way, that index cannot be used to indentify
> the overlay inode.
>
> If a negative index dentry is found or a positive dentry that matches the
> upper inode, store it in the overlay dentry to be used later. A non-upper
> overlay dentry may still have a positive index from copy up of another
> lower hardlink. This situation can be tested with the path type macros
> OVL_TYPE_INDEX(type) && !OVL_TYPE_UPPER(type).
>
> This is going to be used to prevent breaking hardlinks on copy up.

Why is a negative index (or any index, for that matter) stored in the
overlay dentry?  This seems a big waste, since the index dentry will
be allocated for all lower files, yet never used unless copied up.

Index is used:

  - at lookup need to find any copied up alias
  - at copyup need to set up new index

In both cases we can just do a fresh lookup in the index dir with
locks held (which is a good idea anyway).

Something related: should upperdentry of aliases be hardlinked to the
index on lookup and copy-up?  Or should the "hardlink-up" be deferred
until rename?  I think updating as soon as possible is the simpler of
the two.

Thanks,
Miklos
