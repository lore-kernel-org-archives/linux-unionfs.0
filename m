From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 01/17] ovl: document NFS export
Date: Thu, 11 Jan 2018 17:06:22 +0100
Message-ID: <CAJfpegtJBS1PFZGoiBeGL_LhT4b1=w5fHw462wzUNcVekzLB+g@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com> <1515086449-26563-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:46882 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934235AbeAKQGX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 Jan 2018 11:06:23 -0500
Received: by mail-qt0-f193.google.com with SMTP id r39so2388941qtr.13
        for <linux-unionfs@vger.kernel.org>; Thu, 11 Jan 2018 08:06:23 -0800 (PST)
In-Reply-To: <1515086449-26563-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Thu, Jan 4, 2018 at 6:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  Documentation/filesystems/overlayfs.txt | 59 +++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
>
> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
> index 00e0595f3d7e..9e21c14c914c 100644
> --- a/Documentation/filesystems/overlayfs.txt
> +++ b/Documentation/filesystems/overlayfs.txt
> @@ -315,6 +315,65 @@ origin file handle that was stored at copy_up time.  If a found lower
>  directory does not match the stored origin, that directory will not be
>  merged with the upper directory.
>
> +
> +NFS export
> +----------
> +
> +When the underlying filesystems supports NFS export and the "verify"
> +feature is enabled, an overlay filesystem may be exported to NFS.
> +
> +With the "verify" feature, on copy_up of any lower object, an index
> +entry is created under the index directory.  The index entry name is the
> +hexadecimal representation of the copy up origin file handle.  For a
> +non-directory object, the index entry is a hard link to the upper inode.
> +For a directory object, the index entry has an extended attribute
> +"trusted.overlay.origin" with an encoded file handle of the upper
> +directory inode.
> +
> +When encoding a file handle from an overlay filesystem object, the
> +following rules apply:
> +
> +1. For a non-upper object, encode a lower file handle from lower inode
> +2. For an indexed object, encode a lower file handle from copy_up origin
> +3. For a pure-upper object and for an existing non-indexed upper object,
> +   encode an upper file handle from upper inode
> +
> +Encoding of a non-upper directory object is not supported when overlay
> +filesystem has multiple lower layers.  In this case, the directory will
> +be copied up first, and then encoded as an upper file handle.

Why?

What's the difference from encoding the uppermost lower layer directory?

> +
> +The encoded overlay file handle includes:
> + - Header including path type information (e.g. lower/upper)
> + - UUID of the underlying filesystem
> + - Underlying filesystem encoding of underlying inode
> +
> +This encoding is identical to the encoding of copy_up origin stored in
> +"trusted.overlay.origin".
> +
> +When decoding an overlay file handle, the following steps are followed:
> +
> +1. Find underlying layer by UUID and path type information.
> +2. Decode the underlying filesystem file handle to underlying dentry.
> +3. For a lower file handle, lookup the handle in index directory by name.
> +4. If a whiteout is found in index, return ESTALE. This represents an
> +   overlay object that was deleted after its file handle was encoded.
> +5. For a non-directory, instantiate a disconnected overlay dentry from the
> +   decoded underlying dentry, the path type and index inode, if found.
> +6. For a directory, use the connected underlying decoded dentry, path type
> +   and index, to lookup a connected overlay dentry.
> +
> +The "verify" feature ensures, that a decoded overlay directory object will
> +be equivalent to the object that was used to encode the file handle.
> +

What's equivalent?  What are the guarantees needed by NFS server?  It
doesn't verify object version, so modification is OK.

Does swapping out lower dirs count as modification or does it count as
new object?

Thanks,
Miklos
