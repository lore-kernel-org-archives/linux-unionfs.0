Return-Path: <SRS0=6I+O=D2=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F1BC433E7
	for <linux-unionfs@archiver.kernel.org>; Mon, 19 Oct 2020 15:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CA5922363
	for <linux-unionfs@archiver.kernel.org>; Mon, 19 Oct 2020 15:17:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lw2ydiik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgJSPRg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 11:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729816AbgJSPRf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Oct 2020 11:17:35 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6A0C0613CE;
        Mon, 19 Oct 2020 08:17:34 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id n6so13329854ioc.12;
        Mon, 19 Oct 2020 08:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tTOW/BY/c5h4fJJU95wgTAYFCkZrbN7oSpAB8MpRCro=;
        b=Lw2ydiik08z1QeOgWpzwcRrIQdrxRXhx5wBTyil5oW+D/4MgkUuU9vM8gFAZrSVoTK
         okLuVRaQaX3HX6OJK2MGb23wGEyv+D2WPNMNPDzPWb+GGZ9r9JESej6Sv+iU8UtFEMWp
         GmW6ka8WJzI2mAQol15s2wWPMo7w5R2zUfYNGxgzMlJNxE/nZsxhW/SfMLRQSrCcYfvZ
         FPaUFnni1U4gAniHLm9wu18+unGP5YioP4AngkithKxkhWeWQN6/wPQh5n3iLTqYtK6S
         Fr20UbqFgGRE1fl0AWcHGT+H25qG3NNLdrbDcwbzqztH9uT+J08Q7BKSmkaBzlzyWsAo
         +NZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tTOW/BY/c5h4fJJU95wgTAYFCkZrbN7oSpAB8MpRCro=;
        b=X2e1iuLh+ohE6YsHlIxGtOpkvJvWENiignHHq2zMtQkw119iB+7qIZEifHypDR/QSy
         pomnX35YGFGXHJcA+waWmJJvyKfa9yRuH4j7Roi0LQb+TTMWvFgJKJ32aZWF6Xx7gkRQ
         9jwf7EzxJJdtyTIPaGSQXB/oyHFCNW5UlQqGAUuUk+dZv2+EEK0g+kYXCAVXJwMwKRNY
         MY1veC3C3j/JUMp2Zf6tF12+2OTHtHLX3HW69kcaNw+jtWCZh7EwrpwSurhs29F0fcMw
         vax0aXcMpWzFt8ipwZDa2Rr/guAXmCpqDkgCsIKN2MgfB2GDOAJcstlypUeobQmj/kf1
         1a3Q==
X-Gm-Message-State: AOAM530Xwg/YDg975GWQZyPEpnXVbmVpEQdoKBehWAm0PqL5MHLXqZGc
        IysEyoKqcOUPKbDE8gTDTZs645250jpyGIeLpBw=
X-Google-Smtp-Source: ABdhPJzI/iOZnOejzIU3auFe3g2LeOfhgyOF0TMn4gQKuZrRLW0uwEDITz28TKrcNvM3lSPJsWnI9bab3Usn0OWqlqo=
X-Received: by 2002:a6b:780b:: with SMTP id j11mr11126549iom.5.1603120653479;
 Mon, 19 Oct 2020 08:17:33 -0700 (PDT)
MIME-Version: 1.0
References: <20201019115239.2732422-1-salyzyn@android.com> <20201019115239.2732422-4-salyzyn@android.com>
In-Reply-To: <20201019115239.2732422-4-salyzyn@android.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 19 Oct 2020 18:17:21 +0300
Message-ID: <CAOQ4uxgqPbLukWRBmE4Wy8p8KC7Bb7S5aQ11aa2ED1Dy_wJLyg@mail.gmail.com>
Subject: Re: [PATCH v16 3/4] overlayfs: override_creds=off option bypass creator_cred
To:     Mark Salyzyn <salyzyn@android.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Jonathan Corbet <corbet@lwn.net>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        John Stultz <john.stultz@linaro.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Oct 19, 2020 at 2:53 PM Mark Salyzyn <salyzyn@android.com> wrote:
>
> By default, all access to the upper, lower and work directories is the
> recorded mounter's MAC and DAC credentials.  The incoming accesses are
> checked against the caller's credentials.
>
> If the principles of least privilege are applied, the mounter's
> credentials might not overlap the credentials of the caller's when
> accessing the overlayfs filesystem.  For example, a file that a lower
> DAC privileged caller can execute, is MAC denied to the generally
> higher DAC privileged mounter, to prevent an attack vector.
>
> We add the option to turn off override_creds in the mount options; all
> subsequent operations after mount on the filesystem will be only the
> caller's credentials.  The module boolean parameter and mount option
> override_creds is also added as a presence check for this "feature",
> existence of /sys/module/overlay/parameters/override_creds.
>
> It was not always this way.  Circa 4.6 there was no recorded mounter's
> credentials, instead privileged access to upper or work directories
> were temporarily increased to perform the operations.  The MAC
> (selinux) policies were caller's in all cases.  override_creds=off
> partially returns us to this older access model minus the insecure
> temporary credential increases.  This is to permit use in a system
> with non-overlapping security models for each executable including
> the agent that mounts the overlayfs filesystem.  In Android
> this is the case since init, which performs the mount operations,
> has a minimal MAC set of privileges to reduce any attack surface,
> and services that use the content have a different set of MAC
> privileges (eg: read, for vendor labelled configuration, execute for
> vendor libraries and modules).  The caveats are not a problem in
> the Android usage model, however they should be fixed for
> completeness and for general use in time.
>
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> To: linux-fsdevel@vger.kernel.org
> To: linux-unionfs@vger.kernel.org
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: linux-security-module@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kernel-team@android.com
>

Please CC <linux-unionfs@vger.kernel.org> for overlayfs patches

> v16
> - Rebase, cover a few more new ovl_revert_creds callpoints.
>
> v15
> - Rebase
>
> v14:
> - fix an issue in ovl_create_or_link which leaks credentials.
>
> v12 + v13
> - Rebase
>
> v11:
> - add sb argument to ovl_revert_creds to match future work in progress
>   in other commiter's hands.
>
> v10:
> - Rebase (and expand because of increased revert_cred usage)
>
> v9:
> - Add to the caveats
>
> v8:
> - drop pr_warn message after straw poll to remove it.
> - added a use case in the commit message
>
> v7:
> - change name of internal parameter to ovl_override_creds_def
> - report override_creds only if different than default
>
> v6:
> - Drop CONFIG_OVERLAY_FS_OVERRIDE_CREDS.
> - Do better with the documentation.
> - pr_warn message adjusted to report consequences.
>
> v5:
> - beefed up the caveats in the Documentation
> - Is dependent on
>   "overlayfs: check CAP_DAC_READ_SEARCH before issuing exportfs_decode_fh"
>   "overlayfs: check CAP_MKNOD before issuing vfs_whiteout"
> - Added prwarn when override_creds=off
>
> v4:
> - spelling and grammar errors in text
>
> v3:
> - Change name from caller_credentials / creator_credentials to the
>   boolean override_creds.
> - Changed from creator to mounter credentials.
> - Updated and fortified the documentation.
> - Added CONFIG_OVERLAY_FS_OVERRIDE_CREDS
>
> v2:
> - Forward port changed attr to stat, resulting in a build error.
> - altered commit message.
> ---
>  Documentation/filesystems/overlayfs.rst | 23 +++++++++++++++++++++++
>  fs/overlayfs/copy_up.c                  |  2 +-
>  fs/overlayfs/dir.c                      | 17 ++++++++++-------
>  fs/overlayfs/file.c                     | 24 ++++++++++++------------
>  fs/overlayfs/inode.c                    | 18 +++++++++---------
>  fs/overlayfs/namei.c                    |  6 +++---
>  fs/overlayfs/overlayfs.h                |  1 +
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/readdir.c                  |  8 ++++----
>  fs/overlayfs/super.c                    | 22 +++++++++++++++++++++-
>  fs/overlayfs/util.c                     | 13 +++++++++++--
>  11 files changed, 96 insertions(+), 39 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index 580ab9a0fe31..18ac7d35c145 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -137,6 +137,29 @@ Only the lists of names from directories are merged.  Other content
>  such as metadata and extended attributes are reported for the upper
>  directory only.  These attributes of the lower directory are hidden.
>
> +credentials
> +-----------
> +
> +By default, all access to the upper, lower and work directories is the
> +recorded mounter's MAC and DAC credentials.  The incoming accesses are
> +checked against the caller's credentials.
> +
> +In the case where caller MAC or DAC credentials do not overlap, a
> +use case available in older versions of the driver, the
> +override_creds mount flag can be turned off and help when the use
> +pattern has caller with legitimate credentials where the mounter
> +does not.  Several unintended side effects will occur though.  The
> +caller without certain key capabilities or lower privilege will not
> +always be able to delete files or directories, create nodes, or
> +search some restricted directories.  The ability to search and read
> +a directory entry is spotty as a result of the cache mechanism not
> +retesting the credentials because of the assumption, a privileged
> +caller can fill cache, then a lower privilege can read the directory
> +cache.  The uneven security model where cache, upperdir and workdir
> +are opened at privilege, but accessed without creating a form of
> +privilege escalation, should only be used with strict understanding
> +of the side effects and of the security policies.
> +

Since your earlier versions, overlayfs.rst grew the section 'Permission model'.
Please work your documentation into that section or at least add it near the
new section and make sure that the content of the two sections do not
contradicts each other.

Thanks,
Amir.
