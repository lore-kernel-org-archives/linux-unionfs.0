Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC8FCDB482
	for <linux-unionfs@archiver.kernel.org>; Sun, 15 Oct 2023 06:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjJOG6z (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 15 Oct 2023 02:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjJOG6y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 15 Oct 2023 02:58:54 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E23C5
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 23:58:51 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-66d17bdabe1so21225156d6.0
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 23:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697353130; x=1697957930; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0dlApiLmJIRSSsjDDc9mYT8roWLaIpENqmBGlIP8v4=;
        b=hE4W1P/WOPoozDlNKzXhdp9GevV0t8q56HHjPhGpKNhA/koM/Wa+PlbUt9r1K4kmGf
         ljpvM1tgNosbCiAuNr2q3n5+612jygIqV+/gg6w0ZzerAMnuXD0xgHsgq5p2VoFIRlCb
         xsT24mVaK4jCKePgvjdHPmA6LZMj0a+/kuGw8x37uSCozMx7U9LL4ZxvHSKgXTETdQ4t
         XrvtL8RArc2oheq7tukmKuXYlfSQrQpu6prQOa2c01bNg6HZfwfhEzELGgAMWHRbU7hW
         SXtEAAgEJpWHbdc32nwje8eJto59UOBH/KDOgPG8coD6FeD2fz2mh6iGO/eNzzvvZUG1
         BxOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697353130; x=1697957930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D0dlApiLmJIRSSsjDDc9mYT8roWLaIpENqmBGlIP8v4=;
        b=V219Sh+w4rx9lNgPC7+7ozx90FL0uJEbCLrjhgRj89aIsZVE77DgVveeZd7Vj6CCdD
         //637/wYqYYsloveF6xxjWeEK42LwdXCr4RybygpLg57W82iJvEiCo7hm+Eb6zE0V9FR
         8vI8V7OOEl/M0bsFh+KWhYoKqViipZQcStQDbfMyy8xP6YKuo8nhatY/sjQislk7VvyD
         McASRn+qEuViJiV8F0UwsoDRtWnBwYMjkS8RlCyDCg0sOgLgSCUfry7ICUePb1r8+OMh
         qqo0ApU5RN9YPrKEbJZiEH5M3ifjBYu/dqRI6afbX1OHWpR8UhKtaDwJ0iCPPbkxLAhj
         65/g==
X-Gm-Message-State: AOJu0Yz6BJZh9mRVX1CuWemK97MIDfF3YABxXn/VYj/ahJMFSy37VmDz
        +hBIGzWQXi3WdQCzUzmj3eEGMXjBxKTwr4DqWkTYrAVdtZk=
X-Google-Smtp-Source: AGHT+IGso7G8gj7B2FoM7Gj8apbOWFReOFN5Hxwm3/ye+0PAQm6ciqz3n/HA597SWTNN3ZYjJYs7ckYlx9Sv70v3ODY=
X-Received: by 2002:a05:6214:2603:b0:66d:1318:e786 with SMTP id
 gu3-20020a056214260300b0066d1318e786mr14229194qvb.59.1697353130270; Sat, 14
 Oct 2023 23:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20231011164613.1766616-1-amir73il@gmail.com> <CAJfpegvgePB-==T=yTU1R+JVxKYsU_Bm18vWdW5hXWLGw=47PQ@mail.gmail.com>
 <CAOQ4uxiE89q62JHnxwm14FBShPORmX_h0EyDCBN-VKv6aTf5BQ@mail.gmail.com>
 <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
 <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com>
 <CAJfpegt5COamxm-ZN+A9ub_Te-CPM0xMd-Rrzwv7OHBkvHS3yg@mail.gmail.com>
 <CAOQ4uxic3NDtEt9EiP+RYKGEB=6b_PCaudQA=cXK6mWY4Cmeqg@mail.gmail.com>
 <CAJfpegsr3A4YgF2YBevWa6n3=AcP7hNndG6EPMu3ncvV-AM71A@mail.gmail.com> <CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com>
In-Reply-To: <CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 15 Oct 2023 09:58:38 +0300
Message-ID: <CAOQ4uxhg+0_S1tQv9vUpv7Yu-VRLv7U7cnxLmxig+9LmS_qW+A@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Oct 14, 2023 at 9:20=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Sat, 14 Oct 2023 at 19:31, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > If you can code this up quickly, that's good.  I can have a go at it
> > on Monday, but my PoC patch needs splitting up and so it's not ready
> > for 6.6.
>
> Attaching my current patch (against your 3 patches).
>

> +static char *escape_colons(char *s, char *p)
> +{
> +       char *ret =3D s;
> +
> +       for (;;) {
> +               char c =3D *p++;
> +               if (c !=3D ':') {
> +                       *s++ =3D c;
> +                       if (!c)
> +                               return ret;
> +               } else if (s + 2 > p) {
> +                       return ERR_PTR(-ENAMETOOLONG);
> +               } else {
> +                       *s++ =3D '\\';
> +                       *s++ =3D c;
> +               }
> +       }
> +}

I think it is a bad idea going down this rabbit hole.
This escaping is incorrect for an already escaped input
(e.g. "lowerdir=3D/a\:b") - it would escape the \ instead of :
I think that playing more escaping games is the opposite of what
the explicit path params want to achieve.

Suggesting instead:

--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -933,23 +933,27 @@ int ovl_show_options(struct seq_file *m, struct
dentry *dentry)
 {
        struct super_block *sb =3D dentry->d_sb;
        struct ovl_fs *ofs =3D OVL_FS(sb);
-       size_t nr, nr_merged_lower =3D ofs->numlayer - ofs->numdatalayer;
+       size_t nr, nr_merged_lower, nr_added_lower =3D 0;
+       const char **lowerdirs =3D ofs->config.lowerdirs;

        /*
-        * lowerdirs[] starts from offset 1, then
-        * >=3D 0 regular lower layers prefixed with : and
-        * >=3D 0 data-only lower layers prefixed with ::
-        *
-        * we need to escase comma and space like seq_show_option() does an=
d
-        * we also need to escape the colon separator from lowerdir paths.
+        * lowerdirs[0] holds the colon separated list if user provided
+        * it with legacy lowerdir=3D mount option.  Otherwise, we use the
+        * options lowerdir+ and datadir+ to show the separated lowerdirs
+        * that are stored in lowerdirs[1..numlayer].
         */
-       seq_puts(m, ",lowerdir=3D");
-       for (nr =3D 1; nr < ofs->numlayer; nr++) {
-               if (nr > 1)
-                       seq_putc(m, ':');
-               if (nr >=3D nr_merged_lower)
-                       seq_putc(m, ':');
-               seq_escape(m, ofs->config.lowerdirs[nr], ":, \t\n\\");
+       if (lowerdirs[0]) {
+               seq_show_option(m, "lowerdir", lowerdirs[0]);
+       } else {
+               nr_added_lower =3D ofs->numlayer - 1;
+               nr_merged_lower =3D nr_added_lower - ofs->numdatalayer;
+               lowerdirs++;
+       }
+       for (nr =3D 0; nr < nr_added_lower; nr++, lowerdirs++) {
+               if (nr < nr_merged_lower)
+                       seq_show_option(m, "lowerdir+", *lowerdirs);
+               else
+                       seq_show_option(m, "datadir+", *lowerdirs);
        }
        if (ofs->config.upperdir) {
                seq_show_option(m, "upperdir", ofs->config.upperdir);
---

This implies that we do not allow mixing legacy lowerdir=3D with
new lowerdir+/datadir+.
I don't see why mixing would be needed.

Thanks,
Amir.
