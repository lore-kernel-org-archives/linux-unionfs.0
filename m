Return-Path: <SRS0=S/v9=A2=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E860C433E1
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 685852067D
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:04:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="OmaQyVtW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgGOUEG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 16:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgGOUEF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Jul 2020 16:04:05 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76385C061755
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 13:04:03 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id br7so3523474ejb.5
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 13:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OJZbbl7OmZ9VLHBumSbKhRL+js8ddLu/zBnfzlpPQqA=;
        b=OmaQyVtWCp4F1PFnU4OTcRIBVks9RTsrNjj8mBTd5lZdreRr/M6EN7Xj/3j69EuzS6
         tMWlF3+C7YToYelE9sNXTF1ol13Y7RCb0BM5S4ipWGnmR4j4fW+l55YSa9cz2APlh2Qs
         jZc/WgkAYutl5ZF36FlhHhGjfpBP4uwci/X/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OJZbbl7OmZ9VLHBumSbKhRL+js8ddLu/zBnfzlpPQqA=;
        b=g8UZBjjf9D1mm55E4Hp85fQw/tZR9YJaTHh4rwILNfImsWVs1YPx5J3Pw2gBL8ek3L
         FmUUSsGG+LONZd3y/QTYtdvI5hChOwFUnR4gagmiffUMYlGm2VqbhOFeXgkIRbURQOyq
         pG6jyJmGMlnEltyWS7XDFzRbXN+lQIYp5/KqYM4ZvBZTk8NBU5NR2RXjuMK2V+EAV+4/
         VKtxjoKPbG3OPuWXEkGF2tG99fXiA5+632OTUmqHkQoPe9pc94pQCJC7P64tSCHZfzW8
         Cd3E56USQBkmq4ZGcNi7pRMQ5LIEGMCtvaNfh01tKunKz2B3+q8jKkVMaEGmH9Ze++Vw
         78MA==
X-Gm-Message-State: AOAM530Am5xxG3LjTQkMLizBcXHCuE90Gu/PSuedPqjholbvKwpNizHT
        r7047pYmZdwaZt90usit4BjjjMtkPNIIK2e7HUcuaw==
X-Google-Smtp-Source: ABdhPJy9eXzo3+69egk8oqN2U0ofjV4hm6K1rgaWkEbRQnISLD00auvCUvpmxT7liexf6PVZ0TDkyrZgQFDehBdXEro=
X-Received: by 2002:a17:906:1c05:: with SMTP id k5mr596206ejg.320.1594843442222;
 Wed, 15 Jul 2020 13:04:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200713141945.11719-2-amir73il@gmail.com>
In-Reply-To: <20200713141945.11719-2-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 15 Jul 2020 22:03:50 +0200
Message-ID: <CAJfpegsAtSUPXg9gzwxc4UYAqNE2zQpkMxc-JvbpD9K0L2CH4w@mail.gmail.com>
Subject: Re: [PATCH 1/3] ovl: force read-only sb on failure to create index dir
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 13, 2020 at 4:19 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> With index feature enabled, on failure to create index dir, overlay
> is being mounted read-only.  However, we do not forbid user to remount
> overlay read-write.  Fix that by setting ofs->workdir to NULL, which
> prevents remount read-write.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Applied, thanks.

Miklos
