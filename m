From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix reStructuredText syntax errors in documentation
Date: Thu, 15 Dec 2016 09:58:31 +0200
Message-ID: <CAOQ4uxg8s_1ATqFFD6__2dez9-VYqR2NpFQ5iU8zvCDYLib0Pw@mail.gmail.com>
References: <1481183391-30405-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34552 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755376AbcLOH7C (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 15 Dec 2016 02:59:02 -0500
In-Reply-To: <1481183391-30405-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Dec 8, 2016 at 9:49 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> - Fix broken long line block quote
> - Fix missing newline before bullets list
> - Use correct numbered list syntax
>

Ping.

Neil,
I found these syntax errors when I posted your page on my wiki:
https://github.com/amir73il/overlayfs/wiki/Overlayfs-overview

Not sure if this patch should go through Miklos's tree or John's tree,
but is surely needs the ACK from you.

Thanks,
Amir.

> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  Documentation/filesystems/overlayfs.txt | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
> index fb6f307..634d03e 100644
> --- a/Documentation/filesystems/overlayfs.txt
> +++ b/Documentation/filesystems/overlayfs.txt
> @@ -66,7 +66,7 @@ At mount time, the two directories given as mount options "lowerdir" and
>  "upperdir" are combined into a merged directory:
>
>    mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,\
> -workdir=/work /merged
> +  workdir=/work /merged
>
>  The "workdir" needs to be an empty directory on the same filesystem
>  as upperdir.
> @@ -118,6 +118,7 @@ programs.
>
>  seek offsets are assigned sequentially when the directories are read.
>  Thus if
> +
>    - read part of a directory
>    - remember an offset, and close the directory
>    - re-open the directory some time later
> @@ -137,12 +138,12 @@ When renaming a directory that is on the lower layer or merged (i.e. the
>  directory was not created on the upper layer to start with) overlayfs can
>  handle it in two different ways:
>
> -1) return EXDEV error: this error is returned by rename(2) when trying to
> +1. return EXDEV error: this error is returned by rename(2) when trying to
>     move a file or directory across filesystem boundaries.  Hence
>     applications are usually prepared to hande this error (mv(1) for example
>     recursively copies the directory tree).  This is the default behavior.
>
> -2) If the "redirect_dir" feature is enabled, then the directory will be
> +2. If the "redirect_dir" feature is enabled, then the directory will be
>     copied up (but not the contents).  Then the "trusted.overlay.redirect"
>     extended attribute is set to the path of the original location from the
>     root of the overlay.  Finally the directory is moved to the new
> --
> 2.7.4
>
