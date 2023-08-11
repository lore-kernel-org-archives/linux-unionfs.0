Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52266C001DB
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Aug 2023 13:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjHKNVK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 11 Aug 2023 09:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjHKNVK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Aug 2023 09:21:10 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFB2120
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Aug 2023 06:21:09 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2b9aa1d3029so31621751fa.2
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Aug 2023 06:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1691760067; x=1692364867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hgmBum9FpAi7mUXDYSxY+nWwSFPYcuB/zZ6oN18JKgg=;
        b=UwIle2OMCVTI9M0zV9b0EArNDTi6sXliP4WyPk4mqKO6wPVcALlrtnQ1FOk3QT4zJB
         yLSs6ogejFTzoTVOgBDG50B83k8ojoT1n/ykyrQtgnH8mM3tXE6GAKC9Gztb3h9gf5mu
         IWaFuHBcSAgxW9Lax3J1QchbOGU/wgF8mW6vE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691760067; x=1692364867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hgmBum9FpAi7mUXDYSxY+nWwSFPYcuB/zZ6oN18JKgg=;
        b=FLwnQTK0BVWWMyjagQzsmxmThW/t+WeP7sQfgL3i4SiuNFY59ND3WVoCx6JOEk4UIe
         ygDQOkjxeUJnwk5JitUWGMB2yrqYqEKnJv2UROrNqSRzNKW4cI0bVpebIXO7NUiKNhjE
         ZOLq5EeEJaRiJgcZS1Q/AfIfwYmxSilQx6RzS1UiuuS1rP5a4aJ4qYsEH5M+iutFGim3
         wWO2REuKzXq+7rXV9BcOca6Xca0XYadmNdqB46+2oyW7/61qfG4GbeKSBWlHKKrM0CGT
         0KECVNe+I0M6FpBdYOq292NQJiRhTLTS/ojItJy2uFuT6gckVhVeWkzEGGo9tLH1uHxC
         koaQ==
X-Gm-Message-State: AOJu0YwnXpeJueVjm4k2W6bR1F/5GPgZ68DMrERv5fX3Z7jlv7P568bR
        siYcSSkDJ+iXalQpz/lbe9mCs1+Witq5j/dZ8Odczg==
X-Google-Smtp-Source: AGHT+IHlKa3aUwDZltEJ6ZEkbEDLXYFHEm3s9uB36C5XYcPXQc9C3Xufu0yBvFIw3VyhSAJATx6Sb+VA+JqkOTNQFx0=
X-Received: by 2002:a2e:9b4c:0:b0:2b9:dd96:5346 with SMTP id
 o12-20020a2e9b4c000000b002b9dd965346mr1632942ljj.50.1691760067085; Fri, 11
 Aug 2023 06:21:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230713120344.1422468-1-amir73il@gmail.com> <CAOQ4uxibDU2Lko2WCFofJ+eQZV8YVBx_w-sm4H1cqO0fefP6Kw@mail.gmail.com>
In-Reply-To: <CAOQ4uxibDU2Lko2WCFofJ+eQZV8YVBx_w-sm4H1cqO0fefP6Kw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 11 Aug 2023 15:20:55 +0200
Message-ID: <CAJfpegvPQpx_x3omGK=nOtiN=dFvwuZPGbjv6s8pEsFzaks9yQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Report overlayfs file ids with fanotify
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 11 Aug 2023 at 11:44, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Jul 13, 2023 at 3:03=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > Miklos,
> >
> > This is the second part of the work to support fanotify reporting of
> > events with file ids on overlayfs.  The fanotify_event_info_fid struct
> > reported with fanotify events has an object file handle and an fsid,
> > so fanotify requires that filesystems can encode file handles and have
> > a non-zero f_fsid.
> >
> > The first part [1] that was merged to v6.5-rc1, relaxed the fanotify
> > requirements for filesystems to support reporting events with fid to
> > require only the ->encode_fh() export operation.
> >
> > Patch 1 changes overlayfs export_operations to meet the new requirement=
s
> > with the default overlay configurations (i.e. no need for nfs_export=3D=
on),
> > thus, allowing an fanotify watch with FAN_REPORT_FID on overlayfs.
> > There are LTS tests [2] for fanotify(FAN_REPORT_FID) + overlayfs.
> >
> > Patches 2-4 are not strcitly needed to support reporting fanotify event=
s
> > with fid, because overlayfs already reports a non-zero f_fsid, it's jus=
t
> > not a unique fsid.  So before allowing to report events with overlayfs
> > fids, I wanted to fix overlayfs fsid to be more unique.
> >
> > I wanted to implement a persistent and unique fsid for overlayfs.
> > I wanted it to be the default behavior, but needed to avoid breaking
> > applications that rely on an existing overlayfs fsid to persist.
> > I came up with a solution that is described in patch 4 (uuid=3Dauto) th=
at
> > meets all the requirement above.
> > There is an xfstest to test the persistent-unique fsid feature [3].
> >
> > This patch set has been in overlayfs-next for soaking since v6.5-rc1.
> > If you have any reservations that we will not be able to resolve in tim=
e
> > for 6.6, especially regarding the on-disk format and backward compat,
> > we could also merge only patch 1 and leave the fsid patches for later.
> >
>
> Hi Miklos,
>
> Any comments on this series (which is currently on overlayfs-next)?

No issues from me on the design.   Will review the patches.

> Please let me know if you want me to take care of the 6.6 PR or
> if you intend to prepare it yourself.

I'd be very thankful If you could take care of the 6.6 PR.
>
> Other candidates for 6.6 include:
> - ovl lock re-ordering
> https://lore.kernel.org/linux-unionfs/20230720153731.420290-1-amir73il@gm=
ail.com/
> - CONFIG_OVERLAY_FS_DEBUG
> https://lore.kernel.org/linux-unionfs/20230521082813.17025-1-andrea.righi=
@canonical.com/

Yep, those look good, with the exception of the lockdep silencing.
If it's a false positive, then we should teach lockdep about why.  If
it's a real deadlock, then let's try to fix it properly (only holding
sb_writers over operations that need it).

Thanks,
Miklos
