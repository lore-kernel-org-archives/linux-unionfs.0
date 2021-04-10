Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CCEC433B4
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 19:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33B10610A3
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 19:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhDJTms (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 10 Apr 2021 15:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbhDJTmr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Apr 2021 15:42:47 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DA3C06138B
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 12:42:31 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id s7so8773383wru.6
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 12:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t+nSiV4nFDD9oLhxq/bQZ6llneYtoYYbGIfcIFRjqUs=;
        b=fbL3epQ4nbWJKZeDwCUpFdY12Ps/nldsEa5D+a+7aYO+kVyOUxpjpWUf4DCFAO2JCa
         J8F5bZh8Wz/YNL43ExRWRa61FiIEhNI82xTultuGxWkiwQhmrITz1OC7XH9EFmMc7Lxd
         ihbGb3iWDYiRpKZDZuLs6gGtd0vW3Q4z7wv+fSCP7dXwq7wZT0ZWdMDrE67VavtvfLQW
         sfIymvTaxOqmvC/hFpyKQL6pXpWYS/XipzcpZqyVjtgqr2clr0SYr7Cu223pzkj9Zq9F
         lgF8BqBOjQ1SAZhZoIdwVmdRmX7gR8o/sb5tXg7I86b6ubOvkNfSqkQk7tHky+Zm/Kbx
         k5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t+nSiV4nFDD9oLhxq/bQZ6llneYtoYYbGIfcIFRjqUs=;
        b=WxW2Zj5caRTuSNEUC0Tv2kFkfhhcHnERaXi6XKsTI1tuGntGvFBL7QCeJ7Sd6s8lcy
         iueU6FrmGrrzMpxbjKV9k9cH+r+JDZvcGOAMzAU3smhfKa/KzyZiW+0fPXzcdNxvlkas
         6Awk0f7ttu5pooBTarpGP+PHHD2n4mUhhaQX0YDdFSaLDe7xl337ewlvQ2i5flMSEDlg
         I9KSvkWXmH7HER47lE1LDEKZKxDGaS8SwrW+n4iXmNt9UB3uqeR3F3Zvnk3TcIhMndwU
         7hdKbyqUV1bzYz7wnbdFTwHqyo76ZI/Avu5ju9WVuYIRH1aGHnJtEPnKJljkmA337wCF
         qA/Q==
X-Gm-Message-State: AOAM531M2ruFsRbEXIY3jSe7MHs3ZTQDfRkWoMybvGStuGCpT9ga7tDx
        YINVlAGDTeKAUtFyYOOwZm1ZGQtRIVWen5qdzpablA==
X-Google-Smtp-Source: ABdhPJyunLGHawJjOH77NIpSztXKMscYL+goNlYMbZ1wo/wu2fJgLrEC6qCedchxlggzH04NFhgJ3ruOdWVr7CuZpgM=
X-Received: by 2002:adf:dd0c:: with SMTP id a12mr23640830wrm.274.1618083749321;
 Sat, 10 Apr 2021 12:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtTp0aXBssEr4ZXGX=DS_+RyGghmoANCKDdxG59QWu8LVA@mail.gmail.com>
 <CAOQ4uxht70nODhNHNwGFMSqDyOKLXOKrY0H6g849os4BQ7cokA@mail.gmail.com>
 <CAJCQCtRGdBzyskifrYLbBGAAm0g7VeC6GeD7xBN-hRqE3GAWYA@mail.gmail.com>
 <CAOQ4uxhU2KX=jKKL5EZ102z_+6KyVKAOoAzSp2K8i0PMGJUg4A@mail.gmail.com> <CAJCQCtTHepsUHjCUAwawC6r6txAZ=XypE5rJOizqxMx9zuR4AA@mail.gmail.com>
In-Reply-To: <CAJCQCtTHepsUHjCUAwawC6r6txAZ=XypE5rJOizqxMx9zuR4AA@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 10 Apr 2021 13:42:13 -0600
Message-ID: <CAJCQCtQshgFBvUF2+DLm0=iHhiONu-QCRnB1uNv2dLigT+WfZg@mail.gmail.com>
Subject: Re: btrfs+overlayfs: upper fs does not support xattr, falling back to
 index=off and metacopy=off.
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Apr 10, 2021 at 1:36 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> $ sudo mount -o remount,userxattr /home
> mount: /home: mount point not mounted or bad option.
>
> [   92.573364] BTRFS error (device sda6): unrecognized mount option 'userxattr'
>

[   63.320831] BTRFS error (device sda6): unrecognized mount option 'user_xattr'

And if I try it with rootflags at boot, boot fails due to mount
failure due to unrecognized mount option.


-- 
Chris Murphy
