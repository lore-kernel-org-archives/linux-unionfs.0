Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D12C77B73
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Jun 2023 10:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237238AbjFFKh5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 06:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237268AbjFFKhO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Jun 2023 06:37:14 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F751BC7
        for <linux-unionfs@vger.kernel.org>; Tue,  6 Jun 2023 03:36:26 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9741caaf9d4so866509366b.0
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Jun 2023 03:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686047785; x=1688639785;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qd8uKMFm81vYRFqw2LDxc+4LQWMvwJ/7wVX2rL8bDEE=;
        b=FLE32HTMQXTPXIMgRym716RCPA5ZfaA426svAlixR6NT+JFwFi3wq9dhD5MTfGgcdS
         ydtKJDvXeYGZsCfd+Tpk4F1Ps9V0Sum8jeyo/vtelPtEMQ7X+FOslAzStxiS/F1qBha6
         7lhn3d9cM9dPtUfsVDGrEjsK1NUJDrPtoRc7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686047785; x=1688639785;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qd8uKMFm81vYRFqw2LDxc+4LQWMvwJ/7wVX2rL8bDEE=;
        b=RXjfospjZ2LJI94P1Sz8XCTt8wsFqJgpATFweT5KHaVyQD5daCjs3VI4RYyAWQmYwR
         qHuArfSCPkmfzHFvlQwhRRQVE5MQkpmJP2xCMse//Qz0uzWbTGmAMsYOg8/E0ebA/ipZ
         WpzMmO9BcoBgKncxxC3GcBBoHBTXH/m2X8SZmRITqvZ4fjkOJ6xsZILWS+wlWuqjxa9d
         MK3gH0x330+77pfxjDAAf/ZQp61Cl0rBJak9uZCRC8qQp0NnlpaezkhkbYtbG/5RFid5
         kfeNyG/iOi5Y9uqNnN15I4XwbjECjtDolR2xsyXJAfs6F6lGAPlFla/+SzOYoBt6zh31
         Qrtw==
X-Gm-Message-State: AC+VfDyjRr0MWzi8txdq2ETX3Qe/B5e6kM3khEGIQIjq7Bg9fB9izRPS
        M2n66Qr1l/fAn4DdUsWxAFQOAFPmD7mCkS0ggDyTHDQoJ48fxLJq
X-Google-Smtp-Source: ACHHUZ4DMm4EvB7MjP9b43pG7ppWOQ0n/9PE9z9PAfZkfaEzPc7VW24qLvfbEvgkodbFEfEf9pxMeDTJbxgOCc0lIso=
X-Received: by 2002:a17:907:2d13:b0:974:1e0e:9bd2 with SMTP id
 gs19-20020a1709072d1300b009741e0e9bd2mr2417597ejc.14.1686047785487; Tue, 06
 Jun 2023 03:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <amir73il@gmail.com> <20230506150911.1983249-1-gwj1235@yeah.net>
In-Reply-To: <20230506150911.1983249-1-gwj1235@yeah.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 6 Jun 2023 12:36:14 +0200
Message-ID: <CAJfpegs8HOreFpdVoBq9J5TLxOOPTXQ8BGa17Zg=JvejZdbzng@mail.gmail.com>
Subject: Re: [PATCH v2] overlayfs: clean error handling
To:     wenjun93 <gwj0511@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        wenjun93 <gwj1235@yeah.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 6 May 2023 at 17:09, wenjun93 <gwj0511@gmail.com> wrote:
>
> Remove PTR_ERR from unused code path and
> assign error value where it exactly happens.
> This cleans the code and also helps to reduce
> the possibility of incorrect err settings
> when it's set globally and is forgotten to be
> overwrite in custom development.
>
> Signed-off-by: wenjun93 <gwj1235@yeah.net>

Nack.

This is a regularly used pattern across the kernel to unclutter error handling.

If you find a concrete bug, please submit a fix for that.

Thanks,
Miklos
