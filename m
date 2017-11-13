From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] src/t_dir_type.c: Use strtoul() instead of atoll()
Date: Mon, 13 Nov 2017 16:57:08 +0200
Message-ID: <CAOQ4uxjjtkTyqXWX-mRQeeWLY1KrGJn330uBAZX7f_hLs=pY-Q@mail.gmail.com>
References: <20171113144527.1034-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:48556 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752884AbdKMO5J (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Nov 2017 09:57:09 -0500
In-Reply-To: <20171113144527.1034-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Mon, Nov 13, 2017 at 4:45 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> An overlayfs filesystem instance with one lowerdir filesystem and with
> "xino" mount option enabled can have the layer index encoded in the 63rd
> bit of the inode number. A signed 64 bit integer won't suffice to store
> this inode number. Hence this commit uses strtoul() to convert the inode
> number in string form to unsigned integer form.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Looks good, especially since I had to fix the same problem myself ;)
https://github.com/amir73il/xfstests/commits/overlayfs-devel

My patch also changes:

        int type = -1; /* -1 means all types */
-       uint64_t ino = 0;
+       unsigned long ino = 0;
        int ret = 1;

But I am not sure that is the right thing to do here or what difference it makes

Amir.

> ---
>  src/t_dir_type.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/src/t_dir_type.c b/src/t_dir_type.c
> index 76aaa9b..7bba304 100644
> --- a/src/t_dir_type.c
> +++ b/src/t_dir_type.c
> @@ -85,7 +85,7 @@ main(int argc, char *argv[])
>                                 break;
>                 /* no match ends up with type = -1 */
>                 if (type < 0)
> -                       ino = atoll(argv[2]);
> +                       ino = strtoul(argv[2], NULL, 10);
>         }
>
>         for ( ; ; ) {
> --
> 2.9.5
>
