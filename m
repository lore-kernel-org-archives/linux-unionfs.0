Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 172EFC433F5
	for <linux-unionfs@archiver.kernel.org>; Wed,  5 Oct 2022 14:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiJEOiS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 5 Oct 2022 10:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiJEOiO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Oct 2022 10:38:14 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7508246855
        for <linux-unionfs@vger.kernel.org>; Wed,  5 Oct 2022 07:38:11 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id u21so19090374edi.9
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Oct 2022 07:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=30RZfPuaNin29yiKpLmSu3lAATDfol189HBniwYXiU8=;
        b=pNkv1d03U/77IcW7X3mn7ka+SdIgp+9HRVNSSLr/aqFgd9PvNDXmIqBqi+/nZhOIiS
         aoJNWxRZQsPv9Uh8Zwx11sR2HbK62WmQuBt1KkTSQLE9ujmK31VXjHVZ7Y4EB7i9622b
         /DoZmRgogduDmPIB7+BdTzf9JUxp5CUWs7LfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=30RZfPuaNin29yiKpLmSu3lAATDfol189HBniwYXiU8=;
        b=J/1bAPJ5hm6lf5eXNTwIkAfwpgOLVJ4XkOIQtcZW1klzvDKHHg5aGQ5s80Dwix7hX4
         NPXX2l6llmxs1wKxsEqBpC6lVWqKWnPhrloqL+rZAROpnc+tIPT//V5pg5Xmadcf+sDV
         3MoZAHiQNMeVjUI1HzMbsY+Mb00peX100Nxo9iuPRYSbOzouJchpOeKHuO1InDrEWCbs
         rkvId8WYBVOVOFW5+Jop9FJ+COSG+yzG0gxZ1R4JV9j/0WbCZY8QiasOei4t9J+H5biS
         mjjA11Ip9VKWUJr+U31GMBwb6YKXA5vZ5iKjGrxOt45lup7FUlS1Y0w1Mb3SNrqZHcwT
         tS5g==
X-Gm-Message-State: ACrzQf2x2VDqVHZvF3hnWoxWYMj3FzXdL6qDpUW5365Ki3mQGltaxXN7
        5GvrMfDHwDihDMW9Ko8skWoLOPZe6tyUy7TOe7Ad5Q==
X-Google-Smtp-Source: AMsMyM7/IqrggiV8FhxgjZRBnx7wpmyG4q5btSJpLQFHxfujUzG9TEU0iIIkxWRCTFogY46FMZ22jYA7DUd7GlubTA4=
X-Received: by 2002:a05:6402:370c:b0:453:9fab:1b53 with SMTP id
 ek12-20020a056402370c00b004539fab1b53mr104487edb.28.1664980689738; Wed, 05
 Oct 2022 07:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <20221003123040.900827-1-amir73il@gmail.com> <20221003123040.900827-2-amir73il@gmail.com>
In-Reply-To: <20221003123040.900827-2-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 5 Oct 2022 16:37:58 +0200
Message-ID: <CAJfpegtaLQXb-9KoQ5_zA3mEk835UxMq_sN3UyyCdBuRZZG8dA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ovl: remove privs in ovl_copyfile()
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Filipe Manana <fdmanana@kernel.org>,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 3 Oct 2022 at 14:30, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Underlying fs doesn't remove privs because copy_range/remap_range are
> called with privileged mounter credentials.
>
> This fixes some failures in fstest generic/673.
>
> Fixes: 8ede205541ff ("ovl: add reflink/copyfile/dedup support")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>
