From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/4] src/open_by_handle: flexible usage options
Date: Wed, 19 Apr 2017 17:42:02 +0800
Message-ID: <20170419094202.GO8951@eguan.usersys.redhat.com>
References: <1492539444-25938-1-git-send-email-amir73il@gmail.com>
 <1492539444-25938-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42608 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761837AbdDSJmF (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 05:42:05 -0400
Content-Disposition: inline
In-Reply-To: <1492539444-25938-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

On Tue, Apr 18, 2017 at 09:17:22PM +0300, Amir Goldstein wrote:
> More usage options for testing open_by_handle, which are needed
> for testing stable handles across copy up in overlayfs.
> 
> usage: open_by_handle [-c|-l|-u|-d] <test_dir> [num_files]
> 
> Examples:
> 
> 1. Create N test files (nlink=1) under test_dir and exit:
>  $ open_by_handle -c <test_dir> [N]
> 
> 2. Get file handles, drop caches and try to open by handle
>    (expects success):
>  $ open_by_handle <test_dir> [N]
> 
> 3. Get file handles, create hardlinks to test files (nlink=2),
>    drop caches and try to open by handle (expects success):
>  $ open_by_handle -l <test_dir> [N]
> 
> 4. Get file handles, unlink test files w/o the hardlinks (nlink=1),
>    drop caches and try to open by handle (expects success):
>  $ open_by_handle -u <test_dir> [N]
> 
> 5. Get file handles, unlink test files and hardlinks (nlink=0),
>    drop caches and try to open by handle (expects failure):
>  $ open_by_handle -d <test_dir> [N]

"The reason I separated -l (link) and -u (unlink) is because for
overlayfs I need to test linking in lower layer and unlinking from
overlay."

I think it's better to have this in commit log too. (And more
description of the usages of these options? I found that "-c" only
creates test files not hard links, so a subsequent "-u" reports ESTALE,
"-u" is only valid after a "-l". This could confuse testers, I guess.)

> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  src/open_by_handle.c | 93 ++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 80 insertions(+), 13 deletions(-)
> 
> diff --git a/src/open_by_handle.c b/src/open_by_handle.c
> index 8f04865..c33a4aa 100644
> --- a/src/open_by_handle.c
> +++ b/src/open_by_handle.c
> @@ -37,12 +37,12 @@
>  #include <errno.h>
>  #include <linux/limits.h>
>  
> -#define NUMFILES 1024
> +#define MAXFILES 1024
>  
>  struct handle {
>  	struct file_handle fh;
>  	unsigned char fid[MAX_HANDLE_SZ];
> -} handle[NUMFILES];
> +} handle[MAXFILES];
>  
>  int main(int argc, char **argv)
>  {
> @@ -51,18 +51,60 @@ int main(int argc, char **argv)
>  	int	ret;
>  	int	failed = 0;
>  	char	fname[PATH_MAX];
> +	char	fname2[PATH_MAX];
>  	char	*test_dir;
>  	int	mount_fd, mount_id;
> +	int	argi = 1, numfiles = 1;
> +	int	create = 0, delete = 0, nlink = 1;
>  
> -	if (argc != 2) {
> -		fprintf(stderr, "usage: open_by_handle <test_dir>\n");
> +	if (argc < 2 || argc > 4) {
> +usage:
> +		fprintf(stderr, "usage: open_by_handle [-c|-l|-u|-d] <test_dir> [num_files]\n");
> +		fprintf(stderr, "\n");
> +		fprintf(stderr, "open_by_handle -c <test_dir> [N] - create N test files under test_dir, get file handles and exit\n");
> +		fprintf(stderr, "open_by_handle    <test_dir> [N] - get file handles, drop caches and try to open by handle (expects success)\n");
> +		fprintf(stderr, "open_by_handle -l <test_dir> [N] - get file handles, create hardlinks to test files (nlink=2), drop caches and try to open by handle (expects success)\n");
> +		fprintf(stderr, "open_by_handle -u <test_dir> [N] - get file handles, unlink test files w/o hardlinks (nlink=1), drop caches and try to open by handle (expects success)\n");
> +		fprintf(stderr, "open_by_handle -d <test_dir> [N] - get file handles, unlink test files and hardlinks (nlink=0), drop caches and try to open by handle (expects failure)\n");
>  		return EXIT_FAILURE;
>  	}
>  
> -	test_dir = argv[1];
> +	if (argv[1][0] == '-') {

Hmm, why not "getopt"?

> +		if (argv[1][2])
> +			goto usage;
> +		switch (argv[1][1]) {
> +		case 'c':
> +			create = 1;
> +			break;
> +		case 'l':
> +			nlink = 2;
> +			break;
> +		case 'u':
> +			delete = 1;
> +			nlink = 1;
> +			break;
> +		case 'd':
> +			delete = 1;
> +			nlink = 0;
> +			break;
> +		default:
> +			fprintf(stderr, "illegal option '%s'\n", argv[1]);
> +		case 'h':
> +			goto usage;
> +		}
> +		argi++;
> +	}
> +	test_dir = argv[argi++];
> +	if (argc > argi)
> +		numfiles = atoi(argv[argi]);
> +	if (!numfiles || numfiles > MAXFILES) {
> +		fprintf(stderr, "illegal value '%s' for num_files\n", argv[argi]);
> +		goto usage;
> +	}
> +
>  	mount_fd = open(test_dir, O_RDONLY|O_DIRECTORY);
>  	if (mount_fd < 0) {
> -		perror("open test_dir");
> +		perror(test_dir);
>  		return EXIT_FAILURE;
>  	}
>  
> @@ -70,8 +112,9 @@ int main(int argc, char **argv)
>  	 * create a large number of files to force allocation of new inode
>  	 * chunks on disk.
>  	 */
> -	for (i=0; i < NUMFILES; i++) {
> +	for (i=0; create && i < numfiles; i++) {
>  		sprintf(fname, "%s/file%06d", test_dir, i);
> +		sprintf(fname2, "%s/link%06d", test_dir, i);
>  		fd = open(fname, O_RDWR | O_CREAT | O_TRUNC, 0644);
>  		if (fd < 0) {
>  			printf("Warning (%s,%d), open(%s) failed.\n", __FILE__, __LINE__, fname);
> @@ -79,13 +122,14 @@ int main(int argc, char **argv)
>  			return EXIT_FAILURE;
>  		}
>  		close(fd);
> +		ret = unlink(fname2);

So "-c" also implies unlinking the hard links, mind updating the commit
log and the comment above the for block?

But I'm not sure if it's a good idea for the test to depend on this
subtle cleanup behavior, see my comments to patch #4.

>  	}
>  
>  	/* sync to get the new inodes to hit the disk */
>  	sync();
>  
>  	/* create the handles */
> -	for (i=0; i < NUMFILES; i++) {
> +	for (i=0; i < numfiles; i++) {
>  		sprintf(fname, "%s/file%06d", test_dir, i);
>  		handle[i].fh.handle_bytes = MAX_HANDLE_SZ;
>  		ret = name_to_handle_at(AT_FDCWD, fname, &handle[i].fh, &mount_id, 0);
> @@ -95,14 +139,32 @@ int main(int argc, char **argv)
>  		}
>  	}
>  
> +	/* after creating test set only check that fs supports exportfs */
> +	if (create)
> +		return EXIT_SUCCESS;

"-c" means "Create N test files (nlink=1) under test_dir and exit", so
we could move it before name_to_handle_at() calls?

> +
> +	/* hardlink the files */
> +	for (i=0; nlink > 1 && i < numfiles; i++) {
> +		sprintf(fname, "%s/file%06d", test_dir, i);
> +		sprintf(fname2, "%s/link%06d", test_dir, i);
> +		ret = link(fname, fname2);
> +		if (ret < 0) {
> +			perror("link");
> +			return EXIT_FAILURE;
> +		}
> +	}
> +
>  	/* unlink the files */
> -	for (i=0; i < NUMFILES; i++) {
> +	for (i=0; delete && i < numfiles; i++) {
>  		sprintf(fname, "%s/file%06d", test_dir, i);
> +		sprintf(fname2, "%s/link%06d", test_dir, i);
>  		ret = unlink(fname);
>  		if (ret < 0) {
>  			perror("unlink");
>  			return EXIT_FAILURE;
>  		}
> +		if (!nlink)
> +			ret = unlink(fname2);

I noticed that return values of unlink(fname2) are all ignored, is this
intentional?

>  	}
>  
>  	/* sync to get log forced for unlink transactions to hit the disk */
> @@ -126,17 +188,22 @@ int main(int argc, char **argv)
>  	 * now try to open the files by the stored handles. Expecting ENOENT
>  	 * for all of them.

These comments should be updated too.

Thanks,
Eryu

>  	 */
> -	for (i=0; i < NUMFILES; i++) {
> +	for (i=0; i < numfiles; i++) {
>  		errno = 0;
>  		fd = open_by_handle_at(mount_fd, &handle[i].fh, O_RDWR);
> -		if (fd < 0 && (errno == ENOENT || errno == ESTALE)) {
> +		if (nlink && fd >= 0) {
> +			close(fd);
> +			continue;
> +		} else if (!nlink && fd < 0 && (errno == ENOENT || errno == ESTALE)) {
>  			continue;
>  		}
>  		if (fd >= 0) {
>  			printf("open_by_handle(%d) opened an unlinked file!\n", i);
>  			close(fd);
> -		} else
> -			printf("open_by_handle(%d) returned %d incorrectly on an unlinked file!\n", i, errno);
> +		} else {
> +			printf("open_by_handle(%d) returned %d incorrectly on %s file!\n", i, errno,
> +					nlink ? "a linked" : "an unlinked");
> +		}
>  		failed++;
>  	}
>  	if (failed)
> -- 
> 2.7.4
> 
