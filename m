Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03CDC43460
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Apr 2021 08:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 971CB61221
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Apr 2021 08:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237091AbhDLIXQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 04:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237284AbhDLIXP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Apr 2021 04:23:15 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE6AC061574
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Apr 2021 01:22:57 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id g4so6215337vsq.8
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Apr 2021 01:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z6C9YXujb2NLZJ5dAYbnRUAIM3827cN1WWDQ2RCcYPA=;
        b=j/1/2bDcIm/fvODY9BdyblSn2heaq6l/7UZlR/4xce2z5EVbBo3EtM1TSwDjcPsOiW
         Wi/rDoMzTxEeNlhJ5U89OtL0jjNgoW97/E2FGfmMfpgvJCKAwSv+Im+0L9TbqjkFLKj+
         TWG5rFkj90LGnqh77wiyfV+kPRKNBNHR6H8Kk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z6C9YXujb2NLZJ5dAYbnRUAIM3827cN1WWDQ2RCcYPA=;
        b=U/bPLHkuPp4Q+1dWclXM5481E0JMrM8u0r+SF0unr3OWnOtVEfrXG3m/xW94F+zOB2
         +Rg+8133vrzYU6HR2K8YLI9J2NaFzQfJj0mNh6Wp1ldvFCcC7OVlOp+a0Y9pP6Xhy1Fb
         mZe0TbCW27WrYooy9k5YWN6nxoST5eF/Jyyu8LZXTf8tRy3H8ybDYVccPhPAFGPlFzL0
         aIrAa+gXlUa/UuS/UWNLpx/VWiQ8MYqEehlkzQ8OGUbS5k2CFJW4+Iu6IkylX512xYfL
         iNTOjvwJZK7QDXNxUP3RiGTYCe8TOmNsvomnPHMYiUTV3bFjDwkv7VHiZ7eUWcClr/T3
         PKyA==
X-Gm-Message-State: AOAM532fevQs/7CNA7jetocprBfcbejae+H93aPyjAZRwF3hG5kmJjY8
        oLWuZOX41qepYZIHQ6dmU+qddE92Vwo/wvix0+k7rJ1+JwpBUw==
X-Google-Smtp-Source: ABdhPJzyiXQWcq5WTPkbOCcnwL5lN88rj6VKj3hmhbmvZYKTI0p0Vnu/CFbEbfKOBYn0XqDPq+1EEwd/lKBUH7sW0hg=
X-Received: by 2002:a67:6a85:: with SMTP id f127mr18376224vsc.9.1618215776611;
 Mon, 12 Apr 2021 01:22:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210410091750.1858145-1-amir73il@gmail.com>
In-Reply-To: <20210410091750.1858145-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 12 Apr 2021 10:22:45 +0200
Message-ID: <CAJfpegu8CvZPoUgU9K5WN+AX8HgBYRdQ2KPf-gL-eVbPSKsogQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: add debug print to ovl_do_getxattr()
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Apr 10, 2021 at 11:17 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> It was the only ovl_do helper missing it.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Applied.

Thanks,
Miklos
