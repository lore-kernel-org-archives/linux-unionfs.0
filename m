Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D956EC19F28
	for <linux-unionfs@archiver.kernel.org>; Tue,  2 Aug 2022 13:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiHBNnm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 2 Aug 2022 09:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbiHBNnl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Aug 2022 09:43:41 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD7660D5
        for <linux-unionfs@vger.kernel.org>; Tue,  2 Aug 2022 06:43:41 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id i13so17654239edj.11
        for <linux-unionfs@vger.kernel.org>; Tue, 02 Aug 2022 06:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WxMBbuBDdwyOFmQW1I8hAnSHIEKIwpcYs30ZPSwwd5M=;
        b=FR5S3Cs0uToyFO8i8vZuZOYUJGqblJtUSCRmW2IF5+PQF2X0HKWATMMVySOTAJQ78Q
         5rUvmOd/CV2RmEIc88WV06bRDN+yWhrZHegSl5abWyG5GLZkCdAbr+U0tVq8MkGlvReX
         Sv2D0g0MI2LPEC7lDTYfdPGgtZS8Ulq4JtfFo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WxMBbuBDdwyOFmQW1I8hAnSHIEKIwpcYs30ZPSwwd5M=;
        b=3gbAY8QESCqNG5D0ApEuFmMlyAh0S9MN/W31BPYiLtd7L2ZUvymnKjiXJOK8zPDD0M
         IipE92yCv77AcWzTm20fUT9mA+8E0bfSQJ4/9jQtE6wuDVvTR55ZVbg5RYhRP5S3RXhq
         JWjipJW9iLDtcR5O4XsrCGesaBulyJZfAjBxQ8Z6990CR59jIpdIX7Awe9EBPsrHJG3H
         a+qgjVB+kCUF7KaZxwEH9JLsztR2w0y3fYHIupnyEveN7SS8MlUvNV4221RIeExms/Ta
         pTff7E+dD29fmpu1+U3S+nEsK35kUlnsq1ApilDHrvse6QCX3GcWTqQdoCPhdpcX+9fu
         dmCQ==
X-Gm-Message-State: AJIora/Jxnix31UJD15kQ5e7Z140L60HTzhMrYffDAg6/aWwmSVhp25j
        2d0+xFCL7iOrpdAtgv/yF9toBpJ3WZYYxAth8jxfGg==
X-Google-Smtp-Source: AGRyM1tQcDM51UiQAKhZ3CCyYSZbkAlD+nb38S6lVfegL5x/v4zGD6nILExtE7KhfeHHXzFc6jNpTW+kzQ3J5XC8aKc=
X-Received: by 2002:a05:6402:187:b0:43c:b095:4ab3 with SMTP id
 r7-20020a056402018700b0043cb0954ab3mr20719367edv.5.1659447819700; Tue, 02 Aug
 2022 06:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220729015726.3076091-1-williamsukatube@163.com>
In-Reply-To: <20220729015726.3076091-1-williamsukatube@163.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 2 Aug 2022 15:43:28 +0200
Message-ID: <CAJfpeguwkYgxX5u5Ww8rAKRYLfHPDgKs9rmGu+UJU=LtaaKweA@mail.gmail.com>
Subject: Re: [PATCH -next] ovl: Fix spelling mistakes and cleanup code
To:     williamsukatube@163.com
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        William Dean <williamsukatube@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 29 Jul 2022 at 03:58, <williamsukatube@163.com> wrote:
>
> From: William Dean <williamsukatube@gmail.com>
>
> fix follow spelling misktakes:
>         decendant  ==> descendant
>         indentify  ==> identify
>         underlaying ==> underlying
>
> Reported-by: Hacash Robot <hacashRobot@santino.com>
> Signed-off-by: William Dean <williamsukatube@gmail.com>

Applied, thanks.

Miklos
