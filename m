Return-Path: <SRS0=+0RS=6H=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A69C55186
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Apr 2020 08:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA85021582
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Apr 2020 08:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lKfIng+X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgDWI2M (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 04:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgDWI2M (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 23 Apr 2020 04:28:12 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115B6C03C1AB
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Apr 2020 01:28:12 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id e9so5505769iok.9
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Apr 2020 01:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2PgMSRsAJ6xkN3ryZPO9djCwLE1cKvEG9jpt6WG0Hao=;
        b=lKfIng+Xr99VF2jWY8uP/a3L6bL61e5uejidpGvERq3flEhFxMBbdp0A5XNpLm8IqF
         sn84Lah5v/7yWOyQUbAxWcWhXeQdbJs+wEOpwEYKSGL/LSY5WSRoq3P8Xo+8Q+YAMPvD
         Qlupzn/CpK7ZnTQR7KEgNEaXqKPC/GnhJDxk/u3I39u4bKd6jhFpXhEfa4EHkCz2Lxd3
         YHgMf4m1sZO15nrfRVbFH82CfeFNoq39XoMQcHJwGt68oxMDC0zCmVNAIqXXeaCPd/xi
         sD8wv9M5PFhzodijAIB00CpB2nP2uuI/KB4cowYSQ5INqasVhNRrD3ikrSWA6szrf+/1
         4xVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2PgMSRsAJ6xkN3ryZPO9djCwLE1cKvEG9jpt6WG0Hao=;
        b=hIOYtaoH6hDbvX06d6P2JCRZrbN4jw1CmIt3UMlfgNgc7UJ4e1oGHRRNytXt9Z/Xy0
         wPUw5m6Wsux8L7yVgc5z0i4hO6v4oMmVIf59eYqeoRmbR21hnetN5xlKZJbVu0omIchv
         hvy2dn+BV5SX1gYlcl+Wl/oVgheNPRqCKUEnpee0KoaLi9hd0KRRX4yGSq+JxccAm3Zj
         27g2BK7sVgF8GoFrDmqEwkgI/kGK+wUZ3BtDMBNFZx65bTED8as63HMk+Qjy7g3+WrRB
         JGuYig8tIvfyNDit9+XlMytsGTEDPz7JWdfrT1CT3yeOm6f8GwCGl1PBxA8CSN/iz8vG
         XMLA==
X-Gm-Message-State: AGi0PuYeKxvbxO/Sdperj2meO7k1N6FOkzJX41wvJ0YRX9st0g+1z1Ji
        Y1p4y7kYwdo/P6NVmF0ZJmVMPvBjwviPkon8JAKprWq7
X-Google-Smtp-Source: APiQypKBgKIIUULJBNIFyiUlNVpd358GBRN4woXZBbJ3lihngMNpZaVaV+bH2VqPHRd8FwhqUBSC5Ecys7A9hD4CMlQ=
X-Received: by 2002:a6b:7317:: with SMTP id e23mr2618518ioh.72.1587630490610;
 Thu, 23 Apr 2020 01:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <1587625038-55484-1-git-send-email-jefflexu@linux.alibaba.com> <4898364f-e6e9-72e2-9b28-9a3a8f297ad4@linux.alibaba.com>
In-Reply-To: <4898364f-e6e9-72e2-9b28-9a3a8f297ad4@linux.alibaba.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 23 Apr 2020 11:27:59 +0300
Message-ID: <CAOQ4uxjzOmg03mgOG9cyAygK-XhfiMVh3M3k25yN1ZmvO39ckA@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: set MS_NOSEC flag for overlayfs
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "joseph.qi" <joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 23, 2020 at 10:06 AM JeffleXu <jefflexu@linux.alibaba.com> wrote:
>
> It seems that MS_NOSEC flag would be problematic for network filesystems.
>
>
> @Amir, would you please give some suggestions on if this would break the
>
> permission control down when 'NFS export' feature enabled ?
>

I cannot think of anything specific to NFS export.
I think you are confusing NFS server with NFS client permissions.
I think network filesystems do not set SB_NOSEC, because client
may not have an coherent state of the xattr on server and other clients.

To reflect on overlayfs, I think overlayfs should inherit the SB_NOSEC
flag from upper fs, which is most likelihood will be set.
The only filesystem I can think of that is used for upper fs without
SB_NOSEC is the recent feature of fuse as upper fs merged to
v5.7-rc1.

Thanks,
Amir.
