Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1360E743DB
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 Sep 2023 03:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjI2DRD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 23:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjI2DRC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Sep 2023 23:17:02 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1976199;
        Thu, 28 Sep 2023 20:17:00 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id a1e0cc1a2514c-7abe4fa15ceso158476241.1;
        Thu, 28 Sep 2023 20:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695957420; x=1696562220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DkdkomWUtTXARHMgZ0EQBfQou7x4oicQEPVEloUMgRk=;
        b=DxYrw1OOrPugFJdfR9OcSRv/QwT+dQcRKbwKUJrK8ych5dW0TfHnbMEB9/1g2VgIaf
         yXozEzNDGcj3yufL6GLa0cStdys0MF71NncSQq2OWwIldYbd4IqFW2tPyWaofmQYwcvt
         +1/7XHPYjr0fyPCj1Yptln0PZGKQkwSkoaSz3hRxBOml1WX4dRrzJT5U4bEbT+OoruA2
         Fsrrrkan7S/RmT7HlXFJMkDxwFTY7wa111baAlFYIY3iZdZlS4pW11NFr/XlQsFRhCFb
         +3dPJX5cSXw+99Q+KBO/VsllHXScp/Su2n7ux4BI4vXifu1BBhYyu2xcChDZD9sUvbkH
         oagw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695957420; x=1696562220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DkdkomWUtTXARHMgZ0EQBfQou7x4oicQEPVEloUMgRk=;
        b=N3MfjoqBDaq1H/uQQWgGHvNiKOQrPygAEd9Wu3ymFSseYMSl1wlFDecsJj1Gz5MSVN
         x1AaMZ1YsxrMUj06+HylWgUA4GNQ9TYE+cu8v2EiYMzZ5Z2ejVNlaQ+PSdU0kJS1rqIl
         +ju8B74wAiX3CTX0JlstYfL/iPmsFXfTK1gU6wEguPrZOTqogzHjsKaJJ3ufJypl2QCs
         0WvYLbUz1ovBHr5KAHEM8NdpjdRUtQd7vLpKKsNsK/4MK1G65q8AxhmTt5ydvKxIKp5i
         qRQbIhNqrYtz/8dJrcCTm/4XuSCqG102XSCU3LH94YRkc2yV1T002XxP2SAdlUwiavYk
         MuYA==
X-Gm-Message-State: AOJu0YzFb7aVkJRElPLfZQ6ibrw6L7R6jciETmxstr1vI5kTlrPBO5wV
        nFnZdRlMovSIogFKe4/m1RZwXDHTTBNyLoTNp5M=
X-Google-Smtp-Source: AGHT+IF6DQiLz/3VVd2aTeNkUJdZZfNJtiysKP56EzIgbZ2E97uoqIxWXMAn7o7Tpc4bhjP4H33mYjt4kDHWOPeGLBA=
X-Received: by 2002:a05:6102:5486:b0:452:61fa:1e04 with SMTP id
 bk6-20020a056102548600b0045261fa1e04mr1689939vsb.9.1695957419809; Thu, 28 Sep
 2023 20:16:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230928202834.47640-1-uvv.mail@gmail.com>
In-Reply-To: <20230928202834.47640-1-uvv.mail@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 29 Sep 2023 06:16:48 +0300
Message-ID: <CAOQ4uxhx59ZnMbhLTL85M1VQta6AZ2oqe9gMQJcN1qiAzOu6tQ@mail.gmail.com>
Subject: Re: [PATCH] README: Update overlayfs URL
To:     Vyacheslav Yurkov <uvv.mail@gmail.com>
Cc:     fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 28, 2023 at 11:30=E2=80=AFPM Vyacheslav Yurkov <uvv.mail@gmail.=
com> wrote:
>
> Overlayfs-tools and overlayfs-progs projects have been merged together.
>

Nice :)

Do you also have any plans to improve the tools?

> Signed-off-by: Vyacheslav Yurkov <uvv.mail@gmail.com>
> ---
>  README | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/README b/README
> index d9db9675..e558efc9 100644
> --- a/README
> +++ b/README
> @@ -19,7 +19,7 @@ Ubuntu or Debian
>          xfslibs-dev
>
>     For OverlayFS install:

While you are fixing the README:

1. Above should read 'build and install' like the rest of the sections
2. Please refrain from the use of letter case OverlayFS - it is
    inconsistent with the rest of fstests
3. This reads as if installing overlayfs-tools is a prerequisite for
    testing overlayfs, which is not true. In fact, in most likelihood,
    there are very few people that run fstests with fsck.overlay,
    so it would be more accurate to say:

     For fsck.overlay [optional], build and install:

4. Because fsck.overlay is not mandatory and because it is
    not distro specific, I think this instruction should be moved
    to README.overlay.
    Note that the instructions to install unionmount testsuite
    are in README.overlay and while they are also not mandatory
    fo testing overlayfs, they likely add much more test coverage then
    fsck.overlay does, so no reason to promote installing fsck.overlay
    more than installing unionmount

Thanks,
Amir.

> -    - see https://github.com/hisilicon/overlayfs-progs
> +    - see https://github.com/kmxz/overlayfs-tools
>
>  Fedora
>  ------
> @@ -37,7 +37,7 @@ Fedora
>          xfsprogs-devel
>
>     For OverlayFS build and install:
> -    - see https://github.com/hisilicon/overlayfs-progs
> +    - see https://github.com/kmxz/overlayfs-tools
>
>  RHEL or CentOS
>  --------------
> @@ -75,7 +75,7 @@ RHEL or CentOS
>       - see https://github.com/markfasheh/ocfs2-tools
>
>      For OverlayFS build and install:
> -     - see https://github.com/hisilicon/overlayfs-progs
> +     - see https://github.com/kmxz/overlayfs-tools
>
>  SUSE Linux Enterprise or openSUSE
>  ---------------------------------
> @@ -95,7 +95,7 @@ SUSE Linux Enterprise or openSUSE
>       $ sudo zypper install xfsdump xfsprogs-devel
>
>      For OverlayFS build and install:
> -     - see https://github.com/hisilicon/overlayfs-progs
> +     - see https://github.com/kmxz/overlayfs-tools
>
>  Build and install test, libs and utils
>  --------------------------------------
> --
> 2.35.1
>
