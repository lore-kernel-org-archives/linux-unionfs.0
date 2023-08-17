Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0A8C2FC04
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 13:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351622AbjHQNcK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351514AbjHQNbi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 09:31:38 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45164211E
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 06:31:37 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id a1e0cc1a2514c-79aa1f24ba2so2064702241.2
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 06:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692279096; x=1692883896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jo+h709QalmjPtGKToiGd8oD4q/j/vWHG31UrMgkAko=;
        b=H/YrzPWCl2Pgm2pI7NtQIDQ9d36sA3p0X19zQw6e78twjBRs2eFXejxQqnh37ZOi9a
         3mybxFFCu+m3LBaOkTYe0BY3OIgeb4jxtXyDMDoSCcKJ0r8/8exJ4/yqjPMQZN5n8rP2
         /lh+1hkw5InY2Ny0FAz9N9cH1l3fp9Xs8mpJ95p47IZdFrAxOLDSaQpR5nyGes2FPwNx
         Z6Z8joOAgNI+kCVm9begMg00c3CVn51wiJkUVemGvlY3i4L/TZEWXyIWM0i3e2OCTt7F
         JuW8eL8mmkGY5O7wXejyvaYi0lb0+5glL2G6YkxELkRfktjYkMSdnAf0GAonWzwWDule
         rHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692279096; x=1692883896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jo+h709QalmjPtGKToiGd8oD4q/j/vWHG31UrMgkAko=;
        b=fjJVY1zW27uWSrT/J9dxRPHIkNZPwVAZ7giWCaTTSbIgMfZJMe52Gmk43Q9Tq9L4xz
         zQ/Wh7JUXPFBHl0fuHEvfDvUDVa31XkG4+LjQZuPeyAHpngsQwCL+WNwNQv7qJs9joaK
         XQndPlHulhbjIDwUKBjDDLZtP0zzTzVB5xK2QOH2CH9TH9FgJPLu6vKEUL7QBE3IAXOc
         4tDKe1PGQ9Q1etxiCAdQKhy1XtEJ5U1RTRI35cB16hwhb+yRMA+qDdvzzti+Lqz3B9Wr
         vj2tWzSiiT8YnsHvjj2ncg81WPSoRoQXMsEPI6/y8Xp4pgEmNi835n7gh9I5iLjxmXed
         k70A==
X-Gm-Message-State: AOJu0YxV3jZQ3Zi1+uY0ES8x0oxJdZ4asDKwj+4deCRHBRntQThxla6Q
        LU13yOrJHoftKazIvb5+al9TzFXqH7Rlfj57/1PDlIUbzwM=
X-Google-Smtp-Source: AGHT+IHAnURNlgPnCFwRHITmUmHRdsMxBEckexA/Udo4k5Yh3n7ED1ZJiE9pZwgB6fw/xSITCQMeplHx9C9LQDs0HHo=
X-Received: by 2002:a67:fa5a:0:b0:447:7dc0:e15 with SMTP id
 j26-20020a67fa5a000000b004477dc00e15mr4060809vsq.28.1692279096312; Thu, 17
 Aug 2023 06:31:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <6c4b8bd0bf0c234f630242034208eebfe2eff3a1.1692270188.git.alexl@redhat.com>
In-Reply-To: <6c4b8bd0bf0c234f630242034208eebfe2eff3a1.1692270188.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 17 Aug 2023 16:31:25 +0300
Message-ID: <CAOQ4uxgy8tm3ZsST0saTxNFJqb-Jk44BWaX6UfCBhMgbGht8BA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] ovl: Add documentation on nesting of overlayfs mounts
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 17, 2023 at 2:05=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> ---
>  Documentation/filesystems/overlayfs.rst | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 35853906accb..e38b2f5fadaf 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -492,6 +492,28 @@ directory tree on the same or different underlying f=
ilesystem, and even
>  to a different machine.  With the "inodes index" feature, trying to moun=
t
>  the copied layers will fail the verification of the lower root file hand=
le.
>
> +Nesting overlayfs mounts
> +------------------------
> +
> +It is possible to use a lower directory that is stored on an overlayfs
> +mount. For regular files this does not need any special care. However, f=
iles
> +that have overlayfs attributes, such as whiteouts or `overlay.*` xattrs =
will
> +be interpreted by the underlying overlayfs mount and stripped out. In or=
der to
> +allow the second overlayfs mount to see the attributes they must be esca=
ped.
> +
> +Overlayfs specific xattrs are escaped by using a special prefix of
> +`overlay.overlay.`. So, a file with a `trusted.overlay.overlay.metacopy`=
 xattr
> +in the lower dir will be exposed as a regular file with a
> +`trusted.overlay.metacopy` xattr in the overlayfs mount. This can be nes=
ted
> +by repeating the prefix multiple time, as each instance only removes one
> +prefix.
> +
> +Whiteouts files marked with a `overlay.nowhiteout` xattr will cause over=
layfs
> +not to treat them as a whiteout. Since this xattr is then stripped out, =
the
> +next layer will instead apply the whiteout.
> +
> +Files created via overlayfs will automatically be created with the right
> +escapes in the upper directory.
>

I was wondering why you used `` around xattr names.
Is that intentional? I am not an expert in rst format, but
other places in this doc use "" around xattr names and it
does not look like the formatting of `` is handled well by github at least:
https://github.com/alexlarsson/linux/blob/ovl-nesting/Documentation/filesys=
tems/overlayfs.rst

Thanks,
Amir.
