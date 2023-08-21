Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD58FEE4993
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Aug 2023 12:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbjHUM4d (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Aug 2023 08:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233504AbjHUM4c (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Aug 2023 08:56:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CDEE6
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Aug 2023 05:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692622545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YsomDQfaMzegGFtqr+Jc9uGnG7ZeZRN0Jko1QqNPG1s=;
        b=ipBjl6A6sI3nGKA7a1f8vUU61pPZyfTkilo2kiadRdhUf88aBn2Bk7Dzc7AhUrzgY0PSHl
        enz+KzjpKEThX7rsQw0loDAE2J5KdyzGPgaDSoUw6sTKJGA8WQ+S6OgE0qkmEoA7h027ym
        tSfO2QwmjT7netBBRILm0Ka4j5ayZ2A=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-blgYtFlxNzCb3HomJ7kAiw-1; Mon, 21 Aug 2023 08:55:42 -0400
X-MC-Unique: blgYtFlxNzCb3HomJ7kAiw-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-34cb23a8a26so3161945ab.0
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Aug 2023 05:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692622542; x=1693227342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YsomDQfaMzegGFtqr+Jc9uGnG7ZeZRN0Jko1QqNPG1s=;
        b=QyqzZNkSgyJcwrpegLOJR38o9EAyNJQ1h36x5XvlhVZHXo3XgNxzl9XHx1g92KWIQk
         tU3y5DwzEoIsD4xjwqXxF+FU9qFJT9EzLjU9+YRjgeD+iA5MOair+dsmpokrvkl73k5v
         6z1L8FDpstWoHX4Dwk3I51A7H8wWD3wAX8SJzuqIUljuh86y6ARIsfnz5al+va74VkYo
         hfh9iUZhc+LpMxqDaB4wN9Dz/Vc4GhuqoZzv2Pzmw82lueQ/9fM2m56PMJrO62vJG2YJ
         EnvxrAe0/C0lSQIQ9t6Nis6EikPWHaKXcUg7Wh8QEp1YS7QVd5e6KHL/fazkHeMuPD1z
         M5wA==
X-Gm-Message-State: AOJu0Yy31Dzzqucdl+20LCyv2ZSWzJrRvQG6pkMX8ZaISa/fOu0BuaS4
        ewK5FAp+NVykD/GwFmyXfeF6TmGqz0HT9qiZAC67UutP8MsqebBDxe5xE5aHX5cnQl6HX+Lv8Gg
        yQjyDNiGgL0LMnprpRCD+5pMl9akVoXzZjtIJnrZFqQ==
X-Received: by 2002:a05:6e02:1281:b0:34a:9191:62a with SMTP id y1-20020a056e02128100b0034a9191062amr7080548ilq.22.1692622541987;
        Mon, 21 Aug 2023 05:55:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECW6abekbREtCYTeoS+Hck5ljqEyHvjLJWKkqrbgCAZEOORTKR7+7NkEk3kdHOdgHZBziMFVxuqN/A0Wiot1A=
X-Received: by 2002:a05:6e02:1281:b0:34a:9191:62a with SMTP id
 y1-20020a056e02128100b0034a9191062amr7080546ilq.22.1692622541767; Mon, 21 Aug
 2023 05:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
In-Reply-To: <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 21 Aug 2023 14:55:30 +0200
Message-ID: <CAL7ro1G1uDUhOS0yJdaSKAz-8BkxS++gd29=K7Jr27zZU1wbPQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 21, 2023 at 1:00=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 17 Aug 2023 at 13:05, Alexander Larsson <alexl@redhat.com> wrote:
> >
> > This is needed to properly stack overlay filesystems, I.E, being able
> > to create a whiteout file on an overlay mount and then use that as
> > part of the lowerdir in another overlay mount.
> >
> > The way this works is that we create a regular whiteout, but set the
> > `overlay.nowhiteout` xattr on it. Whenever we check if a file is a
> > whiteout we check this xattr and don't treat it as a whiteout if it is
> > set. The xattr itself is then stripped and when viewed as part of the
> > overlayfs mount it looks like a regular whiteout.
> >
>
> I understand the motivation, but don't have good feelings about the
> implementation.  Like the xattr escaping this should also have the
> property that when fed to an old kernel version, it shouldn't
> interpret this object as a whiteout.  Whether it remains hidden like
> the escaped xattrs or if it shows up as something else is
> uninteresting.
>
> It could just be a zero sized regular file with "overlay.whiteout".
>
> But we are also getting to the stage where the number of getxattr
> queries on lookup could be a performance problem.  Or maybe not.  It
> would be good to look at this aspect as well when adding xattr queries
> to lookup.

Wanting to avoid (as much as possible) the reading of more xattrs
which would affect performance of every regular file was the reason
for this particular implementation. I will do some more thinking and
see if I can come up with an alternative approach.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

