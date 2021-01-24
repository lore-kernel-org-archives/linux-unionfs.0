Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3909C433DB
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 Jan 2021 15:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EFCA22EBE
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 Jan 2021 15:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbhAXPdI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 10:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbhAXPdH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 24 Jan 2021 10:33:07 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDEDC061573;
        Sun, 24 Jan 2021 07:32:26 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id e22so21436741iog.6;
        Sun, 24 Jan 2021 07:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Rh8vL7J1f/dGyUh/I4+p7AF7xriBNlPdf7IHKRqzag=;
        b=Pwz+nkoYPk2rM5yzDfDTw0Ia+Va/r+rEFMSsGjSiYlxws7KCkUYNMmVRAL5kCS3ebu
         rnuVLPsDiFVkgs4Wlwk6amED5FPC/jJfkNIeJcGsbc/SmVXA4afL/N5Lq/widMr5y2on
         Ob4uWMU2QbqdtXG0kz+6B0rtry1N3IUd3AfdtPokHj1T6P/XO1tdGa3ETClQ7XCVp2Ux
         o/nX/cIevT3iXSkV/x3qAXRmM6StzfTxbslqU0ZouZCp3lRsSiKnNWmW66KPTHG4zjJI
         x/gJgAxLgwENhJ5q7UN1m8vMve7QixfYoK6JIqS8JGhm83ztg78gzEtvpmQ81VDIloho
         6hWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Rh8vL7J1f/dGyUh/I4+p7AF7xriBNlPdf7IHKRqzag=;
        b=tNBLT8isiBcWyJeYSdftOQSsBFvwOKFuLOQQhtWKIJk4VsGmHAJ6k7uBRaeaSVPXbH
         R2LRAOkGkBTr+8HmaRMDfLWtRfEuZIiQXvnbOQCP//gDwOF4DRWmlbWwsJCiPiJrowxt
         ypfmtWKapD6+EUYBQLVNXUqVVLBOKr0dRhqMHrsW6AbcekQm1zn9P9Eihe2rrliMlO5+
         h3k+4eYtlk/kb5b0+T1lvbOlElvFLBpVDsCDpxt1Z8cPcSWhX8pnQQO1kM1jF8pwyhPS
         WM/VancFGSbuA1z3C8hMcuMfGkheT4F8BnkbQvGodlYSJuFBq8vqQHI2hVdj+BcGCKSA
         EGNA==
X-Gm-Message-State: AOAM531MKHv0EXsBcoh/GJZqyrlWzGclDso4DaLP0XmK8r7SlEbctr63
        Rfn/6sMNlzBPH5251eYSVhNQYbl9VPeM2nbl0RY=
X-Google-Smtp-Source: ABdhPJytS8Kag9+7V4Q5cr9eQvTw+5d1yi/fxx4145AFsYBQFzjVx4Nqme9b61oGUEN1DjULCcooV59HeYrFzbSDq9Y=
X-Received: by 2002:a05:6e02:14ce:: with SMTP id o14mr7551ilk.9.1611502346116;
 Sun, 24 Jan 2021 07:32:26 -0800 (PST)
MIME-Version: 1.0
References: <20210116165619.494265-1-amir73il@gmail.com> <20210116165619.494265-4-amir73il@gmail.com>
 <20210124151411.GC2350@desktop>
In-Reply-To: <20210124151411.GC2350@desktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 24 Jan 2021 17:32:15 +0200
Message-ID: <CAOQ4uxj8xx7izTV8Sp3FH_Pgv_S0gvCKZtCmfRnDGfo318d86Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] src/t_immutable: Allow setting flags on existing files
To:     Eryu Guan <guan@eryu.me>
Cc:     Eryu Guan <guaneryu@gmail.com>, Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jan 24, 2021 at 5:14 PM Eryu Guan <guan@eryu.me> wrote:
>
> On Sat, Jan 16, 2021 at 06:56:18PM +0200, Amir Goldstein wrote:
> > For overlayfs tests we need to be able to setflags on existing
> > (lower) files.
> >
> > t_immutable -C test_dir
> >
> > Creates the test area and sets flags, but it also allows setting flags
> > on an existing test area.
> >
> > t_immutable -R test_dir
> >
> > Removes the flags from existing test area, but does not remove the files
> > in the test area.
> >
> > To setup a test area with file without flags, need to run the -C and -R
> > commands.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  src/t_immutable.c | 30 ++++++++++++++++++++++++------
> >  1 file changed, 24 insertions(+), 6 deletions(-)
> >
> > diff --git a/src/t_immutable.c b/src/t_immutable.c
> > index b6a76af0..a2e6796d 100644
> > --- a/src/t_immutable.c
> > +++ b/src/t_immutable.c
> > @@ -1898,6 +1898,8 @@ static int check_test_area(const char *dir)
> >       return 0;
> >  }
> >
> > +static int allow_existing;
> > +
> >  static int create_dir(char **ppath, const char *fmt, const char *dir)
> >  {
> >       const char *path;
> > @@ -1908,6 +1910,9 @@ static int create_dir(char **ppath, const char *fmt, const char *dir)
> >       }
> >       path = *ppath;
> >       if (stat(path, &st) == 0) {
> > +       if (allow_existing && S_ISDIR(st.st_mode)) {
> > +            return 0;
> > +       }
> >         fprintf(stderr, "%s: Test area directory %s must not exist for test area creation.\n",
> >                 __progname, path);
> >         return 1;
> > @@ -1921,6 +1926,7 @@ static int create_dir(char **ppath, const char *fmt, const char *dir)
> >
> >  static int create_file(char **ppath, const char *fmt, const char *dir)
> >  {
> > +     int flags = O_WRONLY|O_CREAT | (allow_existing ? 0 : O_EXCL);
> >       const char *path;
> >       int fd;
> >
> > @@ -1928,7 +1934,7 @@ static int create_file(char **ppath, const char *fmt, const char *dir)
> >         return -1;
> >       }
> >       path = *ppath;
> > -     if ((fd = open(path, O_WRONLY|O_CREAT|O_EXCL, 0666)) == -1) {
> > +     if ((fd = open(path, flags, 0666)) == -1) {
> >         fprintf(stderr, "%s: error creating file %s: %s\n", __progname, path, strerror(errno));
> >            return -1;
> >       }
> > @@ -1937,13 +1943,15 @@ static int create_file(char **ppath, const char *fmt, const char *dir)
> >
> >  static int create_xattrs(int fd)
> >  {
> > -     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> > +     int flags = allow_existing ? 0 : XATTR_CREATE;
> > +
> > +     if (fsetxattr(fd, "trusted.test", "readonly", strlen("readonly"), flags) != 0) {
> >         if (errno != EOPNOTSUPP) {
> >              perror("setxattr");
> >              return 1;
> >         }
> >       }
> > -     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), XATTR_CREATE) != 0) {
> > +     if (fsetxattr(fd, "user.test", "readonly", strlen("readonly"), flags) != 0) {
> >         if (errno != EOPNOTSUPP) {
> >              perror("setxattr");
> >              return 1;
> > @@ -2214,6 +2222,10 @@ static int remove_test_area(const char *dir)
> >         return 1;
> >       }
> >
> > +     if (allow_existing) {
> > +          return 0;
> > +     }
> > +
> >       pid = fork();
> >       if (!pid) {
> >         execl("/bin/rm", "rm", "-rf", dir, NULL);
> > @@ -2236,7 +2248,7 @@ int main(int argc, char **argv)
> >  /* this arg parsing is gross, but who cares, its a test program */
> >
> >       if (argc < 2) {
> > -       fprintf(stderr, "usage: t_immutable [-C|-c|-r] test_area_dir\n");
> > +       fprintf(stderr, "usage: t_immutable [-C|-c|-R|-r] test_area_dir\n");
> >         return 1;
> >       }
> >
> > @@ -2246,18 +2258,24 @@ int main(int argc, char **argv)
> >         /* Prepare test area without running tests */
> >         create = 1;
> >         runtest = 0;
> > +       /* With existing test area, only setflags */
> > +       allow_existing = 1;
> >       } else if (!strcmp(argv[1], "-r")) {
> >         remove = 1;
> > +     } else if (!strcmp(argv[1], "-R")) {
> > +       /* Cleanup flags on test area but leave the files */
> > +       remove = 1;
> > +       allow_existing = 1;
> >       }
> >
> >       if (argc != 2 + (create | remove)) {
> > -       fprintf(stderr, "usage: t_immutable [-C|-c|-r] test_area_dir\n");
> > +       fprintf(stderr, "usage: t_immutable [-C|-c|-R|-r] test_area_dir\n");
> >         return 1;
> >       }
> >
> >       if (create) {
> >         ret = create_test_area(argv[argc-1]);
> > -       if (ret || !runtest) {
> > +       if (ret || allow_existing) {
>
> With this change, compiler warns about 'runtest' is set but not used,
> and 'allow_existing' now indicates '!runtest' implicitly, which seems
> subtle. I think it's better to keep 'runtest' as the indicator to
> actually run the test?
>

Sure, I removed it by mistake.

Thanks,
Amir.
