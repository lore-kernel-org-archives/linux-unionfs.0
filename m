Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E63BC001DB
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Aug 2023 09:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjHKJot (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbjHKJos (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Aug 2023 05:44:48 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1C0272D
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Aug 2023 02:44:48 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id ada2fe7eead31-447abb2f228so710887137.0
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Aug 2023 02:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691747087; x=1692351887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VOZnaYXhHxwjsurcJFdC8a0QqamD+NEzEyeOqdkA0ZY=;
        b=liFrZnpaJ2MPTClq0m9vx+u8QHtorbrNFfqhuSd7SRrAsNOYwqAKv7XF2Rlit3RCVf
         GfPlxnkeOaIoUpNhQHhP54q5mUS6tQcvpzXJL1y4T6nEG9VToN0tynsDlZWEqBBueSsR
         HiKjl0FUwTRrK3JlIDTmEqmQVbcQ3P2TGwdmtLwH8upW5zLN7YAQFPopEghxH9dlUaZd
         gY8VW8uNgPWbhWdQG818+Ad4CMlTuQJ17bFXgklvytBw/fQ6al6uUpUk5H8seDuVlhTN
         BBKeg9JNOAJ1HKyOc+i3WeuYTjaYkyUuY2WtJTVggSARRCUufN/C0k0AQhbQ44dhJFAP
         Jjyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691747087; x=1692351887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VOZnaYXhHxwjsurcJFdC8a0QqamD+NEzEyeOqdkA0ZY=;
        b=At9n05FdA+hQbuqI6qHJ/5n4K7psNDbW2EKFutjFNb7QIxOWkUwyWvKyJ/rHjQ3mAV
         q2b5pMacMbobyfNtGSozr7yZsrfsMabame7CGnkeiozBn6ZbM2nDSlB7QnQlF/c3YBTT
         eBpY/ThVuMrytQBAqJlIB4/UX9U1XYwS5aAwd4jTa98y6N3po6Pa6SP/kX0T6lXq0Br6
         +EOFNcgnjsiTzScAv4B5SlDsYV0iI0uk4jbpvtj519W5tCriJ4cZ/8tYRUo9t2zcO11o
         5KbegVOjsweOVsP3e/uZn9JLjZSJsmafOarNNjKUSd5Hk32AqwUG8Vwg+1szLhJrcmJo
         XZcg==
X-Gm-Message-State: AOJu0YzQjkqv5ABYJiMctaPg6ioMadB6V/5035LrQcSPqNH/EgQHNI/+
        84daR0Qi3NYeC7vZH0+fJiP3ReRI3Hr+oWNq1OAygjLc2uA=
X-Google-Smtp-Source: AGHT+IErWxwHRX8tnpCitlPKFu8DR47xSmiaDo0mx8u78KrIBM2FeMt27C5IzM08P7Q/Ml9mXTKSfJSChPPZdbQe2Rg=
X-Received: by 2002:a67:fc94:0:b0:445:872:67ea with SMTP id
 x20-20020a67fc94000000b00445087267eamr1029990vsp.34.1691747087168; Fri, 11
 Aug 2023 02:44:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230713120344.1422468-1-amir73il@gmail.com>
In-Reply-To: <20230713120344.1422468-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 11 Aug 2023 12:44:35 +0300
Message-ID: <CAOQ4uxibDU2Lko2WCFofJ+eQZV8YVBx_w-sm4H1cqO0fefP6Kw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Report overlayfs file ids with fanotify
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 13, 2023 at 3:03=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> Miklos,
>
> This is the second part of the work to support fanotify reporting of
> events with file ids on overlayfs.  The fanotify_event_info_fid struct
> reported with fanotify events has an object file handle and an fsid,
> so fanotify requires that filesystems can encode file handles and have
> a non-zero f_fsid.
>
> The first part [1] that was merged to v6.5-rc1, relaxed the fanotify
> requirements for filesystems to support reporting events with fid to
> require only the ->encode_fh() export operation.
>
> Patch 1 changes overlayfs export_operations to meet the new requirements
> with the default overlay configurations (i.e. no need for nfs_export=3Don=
),
> thus, allowing an fanotify watch with FAN_REPORT_FID on overlayfs.
> There are LTS tests [2] for fanotify(FAN_REPORT_FID) + overlayfs.
>
> Patches 2-4 are not strcitly needed to support reporting fanotify events
> with fid, because overlayfs already reports a non-zero f_fsid, it's just
> not a unique fsid.  So before allowing to report events with overlayfs
> fids, I wanted to fix overlayfs fsid to be more unique.
>
> I wanted to implement a persistent and unique fsid for overlayfs.
> I wanted it to be the default behavior, but needed to avoid breaking
> applications that rely on an existing overlayfs fsid to persist.
> I came up with a solution that is described in patch 4 (uuid=3Dauto) that
> meets all the requirement above.
> There is an xfstest to test the persistent-unique fsid feature [3].
>
> This patch set has been in overlayfs-next for soaking since v6.5-rc1.
> If you have any reservations that we will not be able to resolve in time
> for 6.6, especially regarding the on-disk format and backward compat,
> we could also merge only patch 1 and leave the fsid patches for later.
>

Hi Miklos,

Any comments on this series (which is currently on overlayfs-next)?

Please let me know if you want me to take care of the 6.6 PR or
if you intend to prepare it yourself.

Other candidates for 6.6 include:
- ovl lock re-ordering
https://lore.kernel.org/linux-unionfs/20230720153731.420290-1-amir73il@gmai=
l.com/
- CONFIG_OVERLAY_FS_DEBUG
https://lore.kernel.org/linux-unionfs/20230521082813.17025-1-andrea.righi@c=
anonical.com/

Thanks,
Amir.

>
> [1] https://lore.kernel.org/linux-fsdevel/20230425130105.2606684-1-amir73=
il@gmail.com/
> [2] https://github.com/amir73il/ltp/commits/ovl_encode_fid
> [3] https://github.com/amir73il/xfstests/commits/ovl_fsid
>
>
> Amir Goldstein (4):
>   ovl: support encoding non-decodable file handles
>   ovl: add support for unique fsid per instance
>   ovl: store persistent uuid/fsid with uuid=3Don
>   ovl: auto generate uuid for new overlay filesystems
>
>  Documentation/filesystems/overlayfs.rst | 25 ++++++++++
>  fs/overlayfs/copy_up.c                  |  2 +-
>  fs/overlayfs/export.c                   | 26 ++++++++---
>  fs/overlayfs/inode.c                    |  2 +-
>  fs/overlayfs/namei.c                    |  5 +-
>  fs/overlayfs/overlayfs.h                | 22 +++++++++
>  fs/overlayfs/ovl_entry.h                |  3 +-
>  fs/overlayfs/params.c                   | 31 +++++++++++--
>  fs/overlayfs/super.c                    | 29 ++++++++++--
>  fs/overlayfs/util.c                     | 61 +++++++++++++++++++++++++
>  10 files changed, 186 insertions(+), 20 deletions(-)
>
> --
> 2.34.1
>
