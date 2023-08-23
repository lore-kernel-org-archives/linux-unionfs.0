Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFBFEE49A0
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Aug 2023 15:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbjHWPuU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 11:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236827AbjHWPuU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Aug 2023 11:50:20 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B079CD1
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 08:50:18 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id 71dfb90a1353d-48d05fdb8bfso1506992e0c.3
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 08:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692805817; x=1693410617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XP4jIvzHPCDM6ha2aH5+6/uf7nrUnrGlhgyW0UfS3NQ=;
        b=d40KtYXOEoFzMF6TCGvVNaTEsSe/QhstuBAewpPUw0GsYWGLolHhAQJmyiIzM0eXEP
         xQj2UKp5tUb4RF3xyhCUwWwxeCUSGgwvFO/ey4hYQGMkhejaypo34chr60xZxeQ+refb
         Uz5J4yOri9cjWGs7/8lgNfWWzk1LyaKe6xmqUE+ZYTnHyeoM/IPRpZvQ3wdD72GF2qQp
         bTHd28zyBJHVmgdeBmmEw6WH/pxd1UUFQ+cRpfwW0w3e/gogSyH5arW8kTsjNVQWjctE
         sGLiVg7fjqX3cLPImYuwUoxr2SzWti+5mcaikH9d7vMC9YUFA3dToXvsenBbxipXXSH4
         +Jog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692805817; x=1693410617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XP4jIvzHPCDM6ha2aH5+6/uf7nrUnrGlhgyW0UfS3NQ=;
        b=EOceo0BdE4gm3VG0UPiR2AUy5nFAtaEzSD+Vs7owqpH9heCffGmSgpDzd10KQiDHU7
         +ZL/Zpd8mObHrpM1u7oWa86vRfsi5jh9ThU0AoWQZUgMH/mptcIjKRnp8pzmvgRviEhf
         UqPAePSmFLFjjU8fgbxXujfz/eHj8evkqMRRP169dsa3OPcw4LIOTRa2nXMJvblaLvud
         TUrY7hf+hkfV2XD1g4qKOhLKVrqbX6RyPiO4+BuLGBT9d1lIccH/7xUE4cXPLSD3qgRZ
         f0XiYQdWyn3qOEwYhMs5Jyy1TSFwNkJthL43/7oH0BDu66+qPyP07pfOPjfB4lNNwsUk
         /aXA==
X-Gm-Message-State: AOJu0YxPxxwxmLzNxRhTU1daPcn/TvqIjoVaGUqcce07gIoozuFbVdbo
        e64EFh8fu7AK93AgKdAlrMVrjj9jt9RUuS3pcB4=
X-Google-Smtp-Source: AGHT+IGAv9VQ3th4LDcLx4BKv6QfsSfps+Ux0oQ3K+adO14i5VoyH4ItkuoYoo0thOMiiIAeehlRbaU7/d8j9nfm6PE=
X-Received: by 2002:a05:6102:34f9:b0:447:6f5a:5123 with SMTP id
 bi25-20020a05610234f900b004476f5a5123mr9971004vsb.30.1692805817205; Wed, 23
 Aug 2023 08:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
 <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com>
 <CAL7ro1GS9ieN=ZuDLE9mreiiYH4KUK6xWxp40hS-7ZTzf+r6Gg@mail.gmail.com>
 <CAOQ4uxhYH1SH5TbYfARDkep5p+xspUX2gq1HgMyLnv7J4=1emg@mail.gmail.com> <CAJfpegsv3fHwutkEq7S8PV9fYWC07BRUE8GMEpsnK1XkE2hb5w@mail.gmail.com>
In-Reply-To: <CAJfpegsv3fHwutkEq7S8PV9fYWC07BRUE8GMEpsnK1XkE2hb5w@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 23 Aug 2023 18:50:05 +0300
Message-ID: <CAOQ4uxhZySm0rNamtv3GNu8TFOZ66TdSzPVwwda16MQfWNKAQQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Aug 23, 2023 at 5:52=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Wed, 23 Aug 2023 at 16:43, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > If we do this, then both overlay.whiteout and overlay.xattr_whiteouts
> > xattrs will be xattrs that the overlayfs driver never sets.
> > It's a precedent, but as long as it is properly documented and encoded
> > in fstests, I will be fine with it. Not sure about Miklos.
>
> Firstly I need to properly understand the proposal.  At this point I'm
> not sure what overlay.whiteout is supposed to mean.   Does it mean the
> same as a whiteout (chrdev(0,0))?  Or does it mean that overlayfs
> should not treat it as a whiteout, but instead transform that into a
> chrdev(0,0) for the top overlay to interpret as a whiteout?  Or
> something else?
>

My proposal does not involve any transformation.
It is "just" to support another format for a whiteout.
Transforming a REG or FIFO real object to CHR ovl object
will be a pain IMO and I don't see why it is needed.

Let me try again from the top:
1. ovl_path_is_whiteout() checks if either ovl_is_whiteout() (chardev(0,0))
    or regular file with "overlay.whiteout" xattr, so ovl_lookup()
will result in
    a negative dentry if either whiteout format is found at topmost layer
2. To optimize unneeded getxattr, "overlay.whiteout" xattr could be checked
    only in case the parent dir has xattr "overlay.xattr_whiteouts"
3. mkfs.composefs is responsible of creating the non-chardev whiteouts
    as well as the marking the dirs that contains them with
    "overlay.xattr_whiteouts" - overlayfs itself never does that
4. ovl_calc_d_ino() (from readdir on a merge dir) returns true if the
    the iterated dir has "overlay.xattr_whiteouts" xattr
5. That will cause ovl_cache_update_ino() to lookup the
    *overlay dentry* that will be negative (as per rule 1 above)
    if either whiteout format is found at topmost layer and that
    will cause the readdir dirent to be marked is_whiteout and
    filtered out of readdir results

* The trick for readdir is that the the per dirent DT_CHR optimization
  is traded off for a per parent dir optimization, but even the worst case
  where all directories have xattr_whiteouts, readdir is not more
  expensive than readdir with xino enabled, which is the default for
  several Linux distros

Hope this is more clear?

Thanks,
Amir.
