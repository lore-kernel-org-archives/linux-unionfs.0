Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEDBDEE4993
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Aug 2023 11:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjHULAH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Aug 2023 07:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjHULAH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Aug 2023 07:00:07 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87DFDF
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Aug 2023 04:00:02 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-99357737980so422532266b.2
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Aug 2023 04:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1692615601; x=1693220401;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q4kipjLJapoK8kg3cLY785ipfDEy2WZsYLbd/5W3f0M=;
        b=dL7rWup9IPe1BBSo6gJG3GoHrlVTEYTtMd4hp8H48yEatHVDfomUssMQUxj4xfCKJK
         mSJjm8SAVY21u7E/ktSb7UUhN5mDOA/ErmomRohe8N86F7h5Sbfzcj3728X14LKpsICQ
         JKvmEIY8RiBzi/0AxMgiX1QjtFc5X3cxoSEIo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692615601; x=1693220401;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q4kipjLJapoK8kg3cLY785ipfDEy2WZsYLbd/5W3f0M=;
        b=SJM8jzPoYF70mUJWce3m5oL6sN9u02UCS0VWm2FR7g/qhRwhRh9CSnEH/KUcp2KFWo
         Lc1PCl2+srTGQGC3F8U2N4knvUqy21Yr/j227qajle2H6+Gbgg2sj0kC+HWp5vEybO9L
         /9tfjkm4ifHUWVsbtLCfjyEcOWLo+mGu+B920cc6LgygtdR6CBqokyAid1UA+GLPMMs+
         u+BfiHy9o9BOq0bDNjUuHSZGtC71T7tHudt4dAiTz3JQNtYcggGZdGzcy84ChirhBPDQ
         vGNOl0rW94u1Q69r4qIPtF56QtOCm4sj8TTA0DcFS2OauShgvEiHLlkIfkW/IdUB57d/
         30tA==
X-Gm-Message-State: AOJu0YwJ95JsGG0uzrOgQkIwcnQEm7Spp21doxALP28d+yMk/Ply1NnO
        ScKvoqymfB2b0RwgsEtKJKEQTtPT0la60YdU4MIPKA==
X-Google-Smtp-Source: AGHT+IGyxgUXzTk+1OLv/UQpG+C5Ts2fZM5Cqnsv8BrUjmNypZhraKICdUYKKaWAYxu/lIhl5A7N+SBXeSV4hfLTTFk=
X-Received: by 2002:a17:906:100c:b0:99d:f3ae:9a3e with SMTP id
 12-20020a170906100c00b0099df3ae9a3emr5656839ejm.38.1692615601276; Mon, 21 Aug
 2023 04:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
In-Reply-To: <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 21 Aug 2023 12:59:49 +0200
Message-ID: <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 17 Aug 2023 at 13:05, Alexander Larsson <alexl@redhat.com> wrote:
>
> This is needed to properly stack overlay filesystems, I.E, being able
> to create a whiteout file on an overlay mount and then use that as
> part of the lowerdir in another overlay mount.
>
> The way this works is that we create a regular whiteout, but set the
> `overlay.nowhiteout` xattr on it. Whenever we check if a file is a
> whiteout we check this xattr and don't treat it as a whiteout if it is
> set. The xattr itself is then stripped and when viewed as part of the
> overlayfs mount it looks like a regular whiteout.
>

I understand the motivation, but don't have good feelings about the
implementation.  Like the xattr escaping this should also have the
property that when fed to an old kernel version, it shouldn't
interpret this object as a whiteout.  Whether it remains hidden like
the escaped xattrs or if it shows up as something else is
uninteresting.

It could just be a zero sized regular file with "overlay.whiteout".

But we are also getting to the stage where the number of getxattr
queries on lookup could be a performance problem.  Or maybe not.  It
would be good to look at this aspect as well when adding xattr queries
to lookup.


Thanks,
Millos
