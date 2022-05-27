Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E00C433EF
	for <linux-unionfs@archiver.kernel.org>; Fri, 27 May 2022 20:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350365AbiE0UFo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 27 May 2022 16:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238967AbiE0UFl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 May 2022 16:05:41 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5984616B
        for <linux-unionfs@vger.kernel.org>; Fri, 27 May 2022 13:05:39 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id c9-20020a7bc009000000b0039750ec5774so3313312wmb.5
        for <linux-unionfs@vger.kernel.org>; Fri, 27 May 2022 13:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3hDs5pMehEzS9JtBcciO3du/140ZEedg4Xg+u6dsQZw=;
        b=oihAaWbcG7Yr9p0y5ULTKT7tU46NohvPTW+4VGetJ03GHSZRqq4LU+CPKg0Z2PrH5R
         b7AoPxPSIySEEsBuGcjzbeg273gPzUDiuDgPQe8t+O97X7MaFFmZxPWkqR1LY9W4beoO
         n00RsO520VB1zU12ITOAw5pKWroS+wVFZbCpC2euQgZwg2TwOVdcJe/hm29p06XZbpk9
         Sux3vMrXw4iwBHlCbOLNQjWoRtlyXEU5R6srtHjt5qRoh4UhA0D6F4jCnsUI6KqRNPOo
         yBXjUTB2xOyeoHGBTQdQEu/248CfGEyYoUye03xA0p2HIRWz4ulUElW6T5at8G4x+QOH
         iljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3hDs5pMehEzS9JtBcciO3du/140ZEedg4Xg+u6dsQZw=;
        b=jIkHTcLaQygZsXT9w5RKqZRkaZaRzQEFHIHmpeQoEIQZLgLd9SHLgp2haUz5KcMgty
         oPiHQxXFJ5YDQP9y/MMg/6rLfOfx+PXixNkHJrBnfc00aoNRdz17NZjUvzVBF/5x6DIu
         mKWj/T+KvcEvv6kRvCHdRpiw90oxidYVx5ChFwJwUJl1iubTCOp8LYg3VVFWbC6Am66m
         hQ6eOu0sADKUuFynOG1LC8naC2wPn9lMT6ou1I8I/GsXZXKnWRO43hMeH9HEgHWvGuUi
         XGw+BolcCjN2d37OiPJPGeWIb5WgQK1zvICE4JHNgXLMr4cFMsCkmnXHIsmV1hFETYab
         qs1g==
X-Gm-Message-State: AOAM5312R7Be8XBqY4PlbBbWpbDOuWrxNg3QI8q031fmh0bCrvmZ04E1
        C+L55hByEVZB1z/pKDoDn1x+sW3Y5tzQpUSvKlmL
X-Google-Smtp-Source: ABdhPJzSQiwbwdo8FqZ111McYTLFv4bwIxxTTbHCjxtpHRnG+P00gPgVzRWa/5Bdb55lusFwlbu3a5oOnOFQ3+tgAU8=
X-Received: by 2002:a05:600c:3b05:b0:397:54ce:896 with SMTP id
 m5-20020a05600c3b0500b0039754ce0896mr8458182wms.3.1653681937794; Fri, 27 May
 2022 13:05:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220525183703.466936-1-fred@cloudflare.com>
In-Reply-To: <20220525183703.466936-1-fred@cloudflare.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 27 May 2022 16:05:26 -0400
Message-ID: <CAHC9VhS=_RvB66J9D5AZ+XnyDKupvTQpFzni2uvz348REPUT5A@mail.gmail.com>
Subject: Re: [PATCH v2] cred: Propagate security_prepare_creds() error code
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, selinux@vger.kernel.org,
        serge@hallyn.com, amir73il@gmail.com, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 25, 2022 at 2:37 PM Frederick Lawler <fred@cloudflare.com> wrote:
>
> While experimenting with the security_prepare_creds() LSM hook, we
> noticed that our EPERM error code was not propagated up the callstack.
> Instead ENOMEM is always returned.  As a result, some tools may send a
> confusing error message to the user:
>
> $ unshare -rU
> unshare: unshare failed: Cannot allocate memory
>
> A user would think that the system didn't have enough memory, when
> instead the action was denied.
>
> This problem occurs because prepare_creds() and prepare_kernel_cred()
> return NULL when security_prepare_creds() returns an error code. Later,
> functions calling prepare_creds() and prepare_kernel_cred() return
> ENOMEM because they assume that a NULL meant there was no memory
> allocated.
>
> Fix this by propagating an error code from security_prepare_creds() up
> the callstack.
>
> Signed-off-by: Frederick Lawler <fred@cloudflare.com>
>
> ---
> Changes since v1:
> - Revert style churn in ovl_create_or_link() noted by Amir
> - Revert style churn in prepare_nsset() noted by Serge
> - Update documentation for prepare_creds()
> - Set ofs->creator_cred in ovl_fill_super() and req->creds in aio_fsync()
>   to NULL on error noted by Amir
> ---
>  Documentation/security/credentials.rst |  6 +++---
>  fs/aio.c                               |  9 +++++++--
>  fs/cachefiles/security.c               |  8 ++++----
>  fs/cifs/cifs_spnego.c                  |  4 ++--
>  fs/cifs/cifsacl.c                      |  4 ++--
>  fs/coredump.c                          |  2 +-
>  fs/exec.c                              | 14 ++++++++-----
>  fs/ksmbd/smb_common.c                  |  4 ++--
>  fs/nfs/flexfilelayout/flexfilelayout.c |  7 +++++--
>  fs/nfs/nfs4idmap.c                     |  4 ++--
>  fs/nfsd/auth.c                         |  4 ++--
>  fs/nfsd/nfs4callback.c                 | 10 ++++-----
>  fs/nfsd/nfs4recover.c                  |  4 ++--
>  fs/nfsd/nfsfh.c                        |  4 ++--
>  fs/open.c                              |  8 ++++----
>  fs/overlayfs/dir.c                     |  6 ++++--
>  fs/overlayfs/super.c                   |  6 ++++--
>  kernel/capability.c                    |  4 ++--
>  kernel/cred.c                          | 28 +++++++++++++++-----------
>  kernel/groups.c                        |  4 ++--
>  kernel/nsproxy.c                       |  9 ++++++++-
>  kernel/sys.c                           | 28 +++++++++++++-------------
>  kernel/trace/trace_events_user.c       |  4 ++--
>  kernel/umh.c                           |  5 +++--
>  kernel/user_namespace.c                |  6 ++++--
>  net/dns_resolver/dns_key.c             |  4 ++--
>  security/apparmor/task.c               | 12 +++++------
>  security/commoncap.c                   | 20 +++++++++---------
>  security/keys/keyctl.c                 |  8 ++++----
>  security/keys/process_keys.c           | 16 +++++++--------
>  security/landlock/syscalls.c           |  4 ++--
>  security/selinux/hooks.c               |  8 ++++----
>  security/smack/smack_lsm.c             |  8 ++++----
>  security/smack/smackfs.c               |  4 ++--
>  34 files changed, 153 insertions(+), 123 deletions(-)

The SELinux bits look fine to me.

Acked-by: Paul Moore <paul@paul-moore.com> (SELinux)

-- 
paul-moore.com
