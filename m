Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB1DC433E6
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 Jan 2021 15:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF1F022B48
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 Jan 2021 15:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbhAXPMO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 10:12:14 -0500
Received: from out20-27.mail.aliyun.com ([115.124.20.27]:36639 "EHLO
        out20-27.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbhAXPL6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 24 Jan 2021 10:11:58 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436282|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0542434-0.000973266-0.944783;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=guan@eryu.me;NM=1;PH=DS;RN=8;RT=8;SR=0;TI=SMTPD_---.JPVjHG3_1611500958;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.JPVjHG3_1611500958)
          by smtp.aliyun-inc.com(10.147.42.22);
          Sun, 24 Jan 2021 23:09:18 +0800
Date:   Sun, 24 Jan 2021 23:09:18 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] src/t_immutable: factor out some helpers
Message-ID: <20210124150918.GB2350@desktop>
References: <20210116165619.494265-1-amir73il@gmail.com>
 <20210116165619.494265-3-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116165619.494265-3-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jan 16, 2021 at 06:56:17PM +0200, Amir Goldstein wrote:
> Reduce boilerplate code.
> define _GNU_SOURCE needed for asprintf.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  src/t_immutable.c | 221 ++++++++++++++++++++++------------------------
>  1 file changed, 104 insertions(+), 117 deletions(-)
> 
> diff --git a/src/t_immutable.c b/src/t_immutable.c
> index 86c567ed..b6a76af0 100644
> --- a/src/t_immutable.c
> +++ b/src/t_immutable.c
> @@ -8,6 +8,9 @@
>  
>  #define TEST_UTIME
>  
> +#ifndef _GNU_SOURCE
> +#define _GNU_SOURCE
> +#endif
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> @@ -1895,13 +1898,66 @@ static int check_test_area(const char *dir)
>       return 0;
>  }
>  
> +static int create_dir(char **ppath, const char *fmt, const char *dir)
> +{
> +     const char *path;
> +     struct stat st;
> +
> +     if (asprintf(ppath, fmt, dir) == -1) {
> +	  return -1;
> +     }
> +     path = *ppath;
> +     if (stat(path, &st) == 0) {
> +	  fprintf(stderr, "%s: Test area directory %s must not exist for test area creation.\n",
> +		  __progname, path);
> +	  return 1;

Other places return -1 but 1 is returned here, should be -1 as well?

Thanks,
Eryu

> +     }
> +     if (mkdir(path, 0777) != 0) {
> +	  fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
> +	  return -1;
> +     }
> +     return 0;
> +}
> +
> +static int create_file(char **ppath, const char *fmt, const char *dir)
> +{
> +     const char *path;
> +     int fd;
> +
> +     if (asprintf(ppath, fmt, dir) == -1) {
> +	  return -1;
> +     }
> +     path = *ppath;
> +     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
> +	  fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
> +          return -1;
> +     }
> +     return fd;
> +}
> +
> +static int create_xattrs(int fd)
> +{
> +     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> +	  if (errno != EOPNOTSUPP) {
> +	       perror("setxattr");
> +	       return 1;
> +	  }
> +     }
> +     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> +	  if (errno != EOPNOTSUPP) {
> +	       perror("setxattr");
> +	       return 1;
> +	  }
> +     }
> +     return 0;
> +}
> +
>  static int create_test_area(const char *dir)
>  {
>       int fd;
>       char *path;
>       static const char *acl_u_text = "u::rw-,g::rw-,o::rw-,u:nobody:rw-,m::rw-";
>       static const char *acl_u_text_d = "u::rwx,g::rwx,o::rwx,u:nobody:rwx,m::rwx";
> -     struct stat st;
>       static const char *immutable = "This is an immutable file.\nIts contents cannot be altered.\n";
>       static const char *append_only = "This is an append-only file.\nIts contents cannot be altered.\n"
>  	  "Data can only be appended.\n---\n";
> @@ -1911,79 +1967,45 @@ static int create_test_area(const char *dir)
>  	  return 1;
>       }
>  
> -     if (stat(dir, &st) == 0) {
> -	  fprintf(stderr, "%s: Test area directory %s must not exist for test area creation.\n",
> -		  __progname, dir);
> -	  return 1;
> -     }
> -
>       umask(0000);
> -     if (mkdir(dir, 0777) != 0) {
> -	  fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, dir, strerror(errno));
> +     if (create_dir(&path, "%s", dir)) {
>  	  return 1;
>       }
> -
> -     asprintf(&path, "%s/immutable.d", dir);
> -     if (mkdir(path, 0777) != 0) {
> -          fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
> -          return 1;
> -     }
>       free(path);
>  
> -     asprintf(&path, "%s/empty-immutable.d", dir);
> -     if (mkdir(path, 0777) != 0) {
> -          fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
> -          return 1;
> +     if (create_dir(&path, "%s/append-only.d", dir)) {
> +	  return 1;
>       }
>       free(path);
>  
> -     asprintf(&path, "%s/append-only.d", dir);
> -     if (mkdir(path, 0777) != 0) {
> -          fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
> -          return 1;
> +     if (create_dir(&path, "%s/append-only.d/dir", dir)) {
> +	  return 1;
>       }
>       free(path);
>  
> -     asprintf(&path, "%s/empty-append-only.d", dir);
> -     if (mkdir(path, 0777) != 0) {
> -          fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
> +     if ((fd = create_file(&path, "%s/append-only.d/file", dir)) == -1) {
>            return 1;
>       }
> +     close(fd);
>       free(path);
>  
> -     asprintf(&path, "%s/immutable.d/dir", dir);
> -     if (mkdir(path, 0777) != 0) {
> -          fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
> -          return 1;
> +     if (create_dir(&path, "%s/immutable.d", dir)) {
> +	  return 1;
>       }
>       free(path);
>  
> -     asprintf(&path, "%s/append-only.d/dir", dir);
> -     if (mkdir(path, 0777) != 0) {
> -          fprintf(stderr, "%s: error creating directory %s: %s\n", __progname, path, strerror(errno));
> -          return 1;
> +     if (create_dir(&path, "%s/immutable.d/dir", dir)) {
> +	  return 1;
>       }
>       free(path);
>  
> -     asprintf(&path, "%s/append-only.d/file", dir);
> -     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
> -	  fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
> +     if ((fd = create_file(&path, "%s/immutable.d/file", dir)) == -1) {
>            return 1;
>       }
>       close(fd);
>       free(path);
>  
> -     asprintf(&path, "%s/immutable.d/file", dir);
> -     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
> -          fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
> -          return 1;
> -     }
> -     close(fd);
> -     free(path);
> -
> -     asprintf(&path, "%s/immutable.f", dir);
> -     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
> -          fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
> +     if ((fd = create_file(&path, "%s/immutable.f", dir)) == -1) {
>            return 1;
>       }
>       if (write(fd, immutable, strlen(immutable)) != strlen(immutable)) {
> @@ -1994,17 +2016,8 @@ static int create_test_area(const char *dir)
>  	  perror("acl");
>  	  return 1;
>       }
> -     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> -	  if (errno != EOPNOTSUPP) {
> -	       perror("setxattr");
> -	       return 1;
> -	  }
> -     }
> -     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> -	  if (errno != EOPNOTSUPP) {
> -	       perror("setxattr");
> -	       return 1;
> -	  }
> +     if (create_xattrs(fd)) {
> +	  return 1;
>       }
>       if (fsetflag(path, fd, 1, 1)) {
>            perror("fsetflag");
> @@ -2014,8 +2027,7 @@ static int create_test_area(const char *dir)
>       close(fd);
>       free(path);
>  
> -     asprintf(&path, "%s/append-only.f", dir);
> -     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
> +     if ((fd = create_file(&path, "%s/append-only.f", dir)) == -1) {
>            fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
>            return 1;
>       }
> @@ -2027,17 +2039,8 @@ static int create_test_area(const char *dir)
>            perror("acl");
>            return 1;
>       }
> -     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> -	  if (errno != EOPNOTSUPP) {
> -	       perror("setxattr");
> -	       return 1;
> -	  }
> -     }
> -     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> -	  if (errno != EOPNOTSUPP) {
> -	       perror("setxattr");
> -	       return 1;
> -	  }
> +     if (create_xattrs(fd)) {
> +	  return 1;
>       }
>       if (fsetflag(path, fd, 1, 0)) {
>            perror("fsetflag");
> @@ -2056,17 +2059,8 @@ static int create_test_area(const char *dir)
>            perror("acl");
>            return 1;
>       }
> -     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> -	  if (errno != EOPNOTSUPP) {
> -	       perror("setxattr");
> -	       return 1;
> -	  }
> -     }
> -     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> -	  if (errno != EOPNOTSUPP) {
> -	       perror("setxattr");
> -	       return 1;
> -	  }
> +     if (create_xattrs(fd)) {
> +	  return 1;
>       }
>       if (fsetflag(path, fd, 1, 1)) {
>            perror("fsetflag");
> @@ -2076,7 +2070,9 @@ static int create_test_area(const char *dir)
>       close(fd);
>       free(path);
>  
> -     asprintf(&path, "%s/empty-immutable.d", dir);
> +     if (create_dir(&path, "%s/empty-immutable.d", dir)) {
> +	  return 1;
> +     }
>       if ((fd = open(path, O_RDONLY)) == -1) {
>            fprintf(stderr, "%s: error opening %s: %s\n", __progname, path, strerror(errno));
>            return 1;
> @@ -2098,17 +2094,8 @@ static int create_test_area(const char *dir)
>            perror("acl");
>            return 1;
>       }
> -     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> -	  if (errno != EOPNOTSUPP) {
> -	       perror("setxattr");
> -	       return 1;
> -	  }
> -     }
> -     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> -	  if (errno != EOPNOTSUPP) {
> -	       perror("setxattr");
> -	       return 1;
> -	  }
> +     if (create_xattrs(fd)) {
> +	  return 1;
>       }
>       if (fsetflag(path, fd, 1, 0)) {
>            perror("fsetflag");
> @@ -2118,7 +2105,9 @@ static int create_test_area(const char *dir)
>       close(fd);
>       free(path);
>  
> -     asprintf(&path, "%s/empty-append-only.d", dir);
> +     if (create_dir(&path, "%s/empty-append-only.d", dir)) {
> +	  return 1;
> +     }
>       if ((fd = open(path, O_RDONLY)) == -1) {
>            fprintf(stderr, "%s: error opening %s: %s\n", __progname, path, strerror(errno));
>            return 1;
> @@ -2242,6 +2231,7 @@ int main(int argc, char **argv)
>  {
>       int ret;
>       int failed = 0;
> +     int runtest = 1, create = 0, remove = 0;
>  
>  /* this arg parsing is gross, but who cares, its a test program */
>  
> @@ -2251,32 +2241,29 @@ int main(int argc, char **argv)
>       }
>  
>       if (!strcmp(argv[1], "-c")) {
> -	  if (argc == 3) {
> -	       if ((ret = create_test_area(argv[argc-1])))
> -		    return ret;
> -	  } else {
> -	       fprintf(stderr, "usage: t_immutable -c test_area_dir\n");
> -	       return 1;
> -	  }
> +	  create = 1;
>       } else if (!strcmp(argv[1], "-C")) {
> -          if (argc == 3) {
> -               return create_test_area(argv[argc-1]);
> -          } else {
> -               fprintf(stderr, "usage: t_immutable -C test_area_dir\n");
> -               return 1;
> -          }
> +	  /* Prepare test area without running tests */
> +	  create = 1;
> +	  runtest = 0;
>       } else if (!strcmp(argv[1], "-r")) {
> -	  if (argc == 3)
> -	       return remove_test_area(argv[argc-1]);
> -	  else {
> -	       fprintf(stderr, "usage: t_immutable -r test_area_dir\n");
> -	       return 1;
> -	  }
> -     } else if (argc != 2) {
> -	  fprintf(stderr, "usage: t_immutable [-c|-r] test_area_dir\n");
> +	  remove = 1;
> +     }
> +
> +     if (argc != 2 + (create | remove)) {
> +	  fprintf(stderr, "usage: t_immutable [-C|-c|-r] test_area_dir\n");
>  	  return 1;
>       }
>  
> +     if (create) {
> +	  ret = create_test_area(argv[argc-1]);
> +	  if (ret || !runtest) {
> +               return ret;
> +	  }
> +     } else if (remove) {
> +	  return remove_test_area(argv[argc-1]);
> +     }
> +
>       umask(0000);
>  
>       if (check_test_area(argv[argc-1]))
> -- 
> 2.25.1
