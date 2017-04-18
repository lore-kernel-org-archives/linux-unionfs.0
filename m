From: "J . Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 1/4] src/open_by_handle: helper to test
 open_by_handle_at() syscall
Date: Tue, 18 Apr 2017 14:55:26 -0400
Message-ID: <20170418185526.GI6208@fieldses.org>
References: <1492539444-25938-1-git-send-email-amir73il@gmail.com>
 <1492539444-25938-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:35928 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750710AbdDRSz1 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2017 14:55:27 -0400
Content-Disposition: inline
In-Reply-To: <1492539444-25938-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

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
> +
> +int main(int argc, char **argv)
> +{
> +	int	i;
> +	int	fd;
> +	int	ret;
> +	int	failed = 0;
> +	char	fname[PATH_MAX];
> +	char	*test_dir;
> +	int	mount_fd, mount_id;
> +
> +	if (argc != 2) {
> +		fprintf(stderr, "usage: open_by_handle <test_dir>\n");
> +		return EXIT_FAILURE;
> +	}
> +
> +	test_dir = argv[1];
> +	mount_fd = open(test_dir, O_RDONLY|O_DIRECTORY);
> +	if (mount_fd < 0) {
> +		perror("open test_dir");
> +		return EXIT_FAILURE;
> +	}
> +
> +	/*
> +	 * create a large number of files to force allocation of new inode
> +	 * chunks on disk.
> +	 */
> +	for (i=0; i < NUMFILES; i++) {
> +		sprintf(fname, "%s/file%06d", test_dir, i);
> +		fd = open(fname, O_RDWR | O_CREAT | O_TRUNC, 0644);
> +		if (fd < 0) {
> +			printf("Warning (%s,%d), open(%s) failed.\n", __FILE__, __LINE__, fname);
> +			perror(fname);
> +			return EXIT_FAILURE;
> +		}
> +		close(fd);
> +	}
> +
> +	/* sync to get the new inodes to hit the disk */
> +	sync();
> +
> +	/* create the handles */
> +	for (i=0; i < NUMFILES; i++) {
> +		sprintf(fname, "%s/file%06d", test_dir, i);
> +		handle[i].fh.handle_bytes = MAX_HANDLE_SZ;
> +		ret = name_to_handle_at(AT_FDCWD, fname, &handle[i].fh, &mount_id, 0);
> +		if (ret < 0) {
> +			perror("name_to_handle");
> +			return EXIT_FAILURE;
> +		}
> +	}
> +
> +	/* unlink the files */
> +	for (i=0; i < NUMFILES; i++) {
> +		sprintf(fname, "%s/file%06d", test_dir, i);
> +		ret = unlink(fname);
> +		if (ret < 0) {
> +			perror("unlink");
> +			return EXIT_FAILURE;
> +		}
> +	}
> +
> +	/* sync to get log forced for unlink transactions to hit the disk */
> +	sync();
> +
> +	/* sync once more FTW */
> +	sync();
> +
> +	/*
> +	 * now drop the caches so that unlinked inodes are reclaimed and
> +	 * buftarg page cache is emptied so that the inode cluster has to be
> +	 * fetched from disk again for the open_by_handle() call.
> +	 */
> +	ret = system("echo 3 > /proc/sys/vm/drop_caches");
> +	if (ret < 0) {
> +		perror("drop_caches");
> +		return EXIT_FAILURE;

By the way, I noticed some time ago in kernel commit 75a6f82a0d10 that
Al uses a remount for this instead of drop_caches; I wonder if that has
any advantages or if it just amounts to the same thing?

--b.

> +	}
> +
> +	/*
> +	 * now try to open the files by the stored handles. Expecting ENOENT
> +	 * for all of them.
> +	 */
> +	for (i=0; i < NUMFILES; i++) {
> +		errno = 0;
> +		fd = open_by_handle_at(mount_fd, &handle[i].fh, O_RDWR);
> +		if (fd < 0 && (errno == ENOENT || errno == ESTALE)) {
> +			continue;
> +		}
> +		if (fd >= 0) {
> +			printf("open_by_handle(%d) opened an unlinked file!\n", i);
> +			close(fd);
> +		} else
> +			printf("open_by_handle(%d) returned %d incorrectly on an unlinked file!\n", i, errno);
> +		failed++;
> +	}
> +	if (failed)
> +		return EXIT_FAILURE;
> +	return EXIT_SUCCESS;
> +}
> -- 
> 2.7.4
