Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5972FC433E6
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 Jan 2021 15:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D2B522DD6
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 Jan 2021 15:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbhAXPPR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 10:15:17 -0500
Received: from out20-62.mail.aliyun.com ([115.124.20.62]:43982 "EHLO
        out20-62.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbhAXPPL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 24 Jan 2021 10:15:11 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436282|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.144308-0.00222605-0.853466;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047188;MF=guan@eryu.me;NM=1;PH=DS;RN=8;RT=8;SR=0;TI=SMTPD_---.JPW27lU_1611501251;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.JPW27lU_1611501251)
          by smtp.aliyun-inc.com(10.147.42.241);
          Sun, 24 Jan 2021 23:14:11 +0800
Date:   Sun, 24 Jan 2021 23:14:11 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] src/t_immutable: Allow setting flags on existing
 files
Message-ID: <20210124151411.GC2350@desktop>
References: <20210116165619.494265-1-amir73il@gmail.com>
 <20210116165619.494265-4-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116165619.494265-4-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jan 16, 2021 at 06:56:18PM +0200, Amir Goldstein wrote:
> For overlayfs tests we need to be able to setflags on existing
> (lower) files.
> 
> t_immutable -C test_dir
> 
> Creates the test area and sets flags, but it also allows setting flags
> on an existing test area.
> 
> t_immutable -R test_dir
> 
> Removes the flags from existing test area, but does not remove the files
> in the test area.
> 
> To setup a test area with file without flags, need to run the -C and -R
> commands.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  src/t_immutable.c | 30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/src/t_immutable.c b/src/t_immutable.c
> index b6a76af0..a2e6796d 100644
> --- a/src/t_immutable.c
> +++ b/src/t_immutable.c
> @@ -1898,6 +1898,8 @@ static int check_test_area(const char *dir)
>       return 0;
>  }
>  
> +static int allow_existing;
> +
>  static int create_dir(char **ppath, const char *fmt, const char *dir)
>  {
>       const char *path;
> @@ -1908,6 +1910,9 @@ static int create_dir(char **ppath, const char *fmt, const char *dir)
>       }
>       path = *ppath;
>       if (stat(path, &st) == 0) {
> +	  if (allow_existing && S_ISDIR(st.st_mode)) {
> +	       return 0;
> +	  }
>  	  fprintf(stderr, "%s: Test area directory %s must not exist for test area creation.\n",
>  		  __progname, path);
>  	  return 1;
> @@ -1921,6 +1926,7 @@ static int create_dir(char **ppath, const char *fmt, const char *dir)
>  
>  static int create_file(char **ppath, const char *fmt, const char *dir)
>  {
> +     int flags = O_WRONLY|O_CREAT | (allow_existing ? 0 : O_EXCL);
>       const char *path;
>       int fd;
>  
> @@ -1928,7 +1934,7 @@ static int create_file(char **ppath, const char *fmt, const char *dir)
>  	  return -1;
>       }
>       path = *ppath;
> -     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
> +     if ((fd = open(path, flags, 0666)) == -1) {
>  	  fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
>            return -1;
>       }
> @@ -1937,13 +1943,15 @@ static int create_file(char **ppath, const char *fmt, const char *dir)
>  
>  static int create_xattrs(int fd)
>  {
> -     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> +     int flags = allow_existing ? 0 : XATTR_CREATE;
> +
> +     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), flags) != 0) {
>  	  if (errno != EOPNOTSUPP) {
>  	       perror("setxattr");
>  	       return 1;
>  	  }
>       }
> -     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> +     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), flags) != 0) {
>  	  if (errno != EOPNOTSUPP) {
>  	       perror("setxattr");
>  	       return 1;
> @@ -2214,6 +2222,10 @@ static int remove_test_area(const char *dir)
>  	  return 1;
>       }
>  
> +     if (allow_existing) {
> +	     return 0;
> +     }
> +
>       pid = fork();
>       if (!pid) {
>  	  execl("/bin/rm", "rm", "-rf", dir, NULL);
> @@ -2236,7 +2248,7 @@ int main(int argc, char **argv)
>  /* this arg parsing is gross, but who cares, its a test program */
>  
>       if (argc < 2) {
> -	  fprintf(stderr, "usage: t_immutable [-C|-c|-r] test_area_dir\n");
> +	  fprintf(stderr, "usage: t_immutable [-C|-c|-R|-r] test_area_dir\n");
>  	  return 1;
>       }
>  
> @@ -2246,18 +2258,24 @@ int main(int argc, char **argv)
>  	  /* Prepare test area without running tests */
>  	  create = 1;
>  	  runtest = 0;
> +	  /* With existing test area, only setflags */
> +	  allow_existing = 1;
>       } else if (!strcmp(argv[1], "-r")) {
>  	  remove = 1;
> +     } else if (!strcmp(argv[1], "-R")) {
> +	  /* Cleanup flags on test area but leave the files */
> +	  remove = 1;
> +	  allow_existing = 1;
>       }
>  
>       if (argc != 2 + (create | remove)) {
> -	  fprintf(stderr, "usage: t_immutable [-C|-c|-r] test_area_dir\n");
> +	  fprintf(stderr, "usage: t_immutable [-C|-c|-R|-r] test_area_dir\n");
>  	  return 1;
>       }
>  
>       if (create) {
>  	  ret = create_test_area(argv[argc-1]);
> -	  if (ret || !runtest) {
> +	  if (ret || allow_existing) {

With this change, compiler warns about 'runtest' is set but not used,
and 'allow_existing' now indicates '!runtest' implicitly, which seems
subtle. I think it's better to keep 'runtest' as the indicator to
actually run the test?

Thanks,
Eryu

>                 return ret;
>  	  }
>       } else if (remove) {
> -- 
> 2.25.1
