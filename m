From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/4] src/open_by_handle: helper to test
 open_by_handle_at() syscall
Date: Wed, 19 Apr 2017 16:53:58 +0800
Message-ID: <20170419085358.GM8951@eguan.usersys.redhat.com>
References: <1492539444-25938-1-git-send-email-amir73il@gmail.com>
 <1492539444-25938-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752167AbdDSIyD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 04:54:03 -0400
Content-Disposition: inline
In-Reply-To: <1492539444-25938-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

On Tue, Apr 18, 2017 at 09:17:21PM +0300, Amir Goldstein wrote:
> This is a clone of src/stale_handle.c test that uses generic
> open_by_handle_at() syscall instead of the xfs specific ioctl.
> 
> No test is using this helper yet.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  src/Makefile         |   2 +-
>  src/open_by_handle.c | 145 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 146 insertions(+), 1 deletion(-)
>  create mode 100644 src/open_by_handle.c
> 
> diff --git a/src/Makefile b/src/Makefile
> index e62d7a9..6b38e77 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -22,7 +22,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
>  	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
>  	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
> -	dio-invalidate-cache stat_test
> +	dio-invalidate-cache stat_test open_by_handle

Need an entry in .gitignore file too.

>  
>  SUBDIRS =
>  
> diff --git a/src/open_by_handle.c b/src/open_by_handle.c
> new file mode 100644
> index 0000000..8f04865
> --- /dev/null
> +++ b/src/open_by_handle.c
> @@ -0,0 +1,145 @@
> +/*
> + * open_by_handle.c - attempt to create a file handle and open it
> + *                    with open_by_handle_at() syscall
> + *
> + * Copyright (C) 2017 CTERA Networks. All Rights Reserved.
> + * Author: Amir Goldstein <amir73il@gmail.com>
> + * 

Trailing whitespace in above line.

> + * from:
> + *  stale_handle.c
> + *
> + *  Copyright (C) 2010 Red Hat, Inc. All Rights reserved.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> + */
> +
> +#define TEST_UTIME

This is not used, remove it? (I think it's not used in the original
stale_handle.c too).

> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <errno.h>
> +#include <linux/limits.h>
> +
> +#define NUMFILES 1024
> +
> +struct handle {
> +	struct file_handle fh;
> +	unsigned char fid[MAX_HANDLE_SZ];
> +} handle[NUMFILES];

>From open_by_handle_at(2):

"These system calls first appeared in Linux 2.6.39.  Library support is
provided in glibc since version 2.14."

I think we should check if the system supports open_by_handle_at(2)
syscalls at build time and _require_test_program "open_by_handle" in
tests in case it's not built.

Currently it fails to build on my RHEL6 host:
Building src
    [CC]    open_by_handle
open_by_handle.c:43: error: field 'fh' has incomplete type
open_by_handle.c:44: error: 'MAX_HANDLE_SZ' undeclared here (not in a function)
open_by_handle.c: In function 'main':
open_by_handle.c:135: warning: implicit declaration of function 'name_to_handle_at'
open_by_handle.c:193: warning: implicit declaration of function 'open_by_handle_at'
gmake[2]: *** [open_by_handle] Error 1
gmake[1]: *** [src] Error 2
make: *** [default] Error 2

Thanks,
Eryu
