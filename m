Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50861C04A68
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 Jul 2022 13:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiG0NVf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 09:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbiG0NVf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 Jul 2022 09:21:35 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7AB23BD7
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Jul 2022 06:21:32 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w5so8940944edd.13
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Jul 2022 06:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ULYmlOXVqjXX7HeVd/2r6q13ryXvzeR5lMbaFhgz/dI=;
        b=mwJ5B/HanHs1g0oM8012VvvpHaBBGlXaJYcB2wtZ36mI+qNCuIL1anCeCBSe5+p9IU
         aBGaEoWYq1KAFgSempzhxd8fhPGzFyeQuJFmqDmKMU4Tb95FH9XUtWbxXzoQmtgIrRw+
         YJxymUcGXKjzOWyZO1heoPXOIuS6zyNQprt9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ULYmlOXVqjXX7HeVd/2r6q13ryXvzeR5lMbaFhgz/dI=;
        b=DCk+DSmZxOnBqLA0PWzJElnKDAhgFRrZ66qeNoVBkODr1fGLc68freB0lILIdKPq0s
         aJ5j0SHVXnxL/GDCvsJTiuQ/saoB5I+aVsE73o5PT5hMDcyLE5G8yUjA9eUEcAzGyy47
         DjVLMBhylW5dI+1Jyqi4WWbFOqiYR45IKBg4FjlGuCOpaIFxyzVn19tI/1qGu3ItZT7V
         +cnCG/k0ptqNdj5gwThWgdFhrTaXG+w+CtawZ4O/RIA678qF8jY5eFFW4sZt/EEaOji1
         2X0Q/sOh4UtV9B5sENXVemixm1Oqo9EAT4NfTLZKfTc5apRqdN+AJeK30PqOzsqBXwdt
         06Zg==
X-Gm-Message-State: AJIora+SopjJdKIedzzptjPhv7V+S8N0DChFaISEl7WW4OigVQZS+kpR
        NXjPKD19vhnFdnrbjgPJK5KSGC1C2sur8lAg8KIC8bXHArNG4Q==
X-Google-Smtp-Source: AGRyM1tqatOAwaiQnQ7oka4nkE+hxhpH+krVc2LxP7Ze9nRUK5KkGXnmKmssDISH1n2ItG/Q7j/mdwhNc9WwVQH/Doc=
X-Received: by 2002:a05:6402:e96:b0:43a:f21f:42a0 with SMTP id
 h22-20020a0564020e9600b0043af21f42a0mr23692787eda.382.1658928091268; Wed, 27
 Jul 2022 06:21:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220601022814.122620-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20220601022814.122620-1-yang.lee@linux.alibaba.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 27 Jul 2022 15:21:20 +0200
Message-ID: <CAJfpegtQqECU=-M8KomeG_6ba5OT2rPhkGXaQ9LMdjv2+PeKAw@mail.gmail.com>
Subject: Re: [PATCH -next] ovl: Fix some kernel-doc comments
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 1 Jun 2022 at 04:28, Yang Li <yang.lee@linux.alibaba.com> wrote:
>
> Remove warnings found by running scripts/kernel-doc,
> which is caused by using 'make W=1'.
> fs/overlayfs/super.c:311: warning: Function parameter or member 'dentry'
> not described in 'ovl_statfs'
> fs/overlayfs/super.c:311: warning: Excess function parameter 'sb'
> description in 'ovl_statfs'
> fs/overlayfs/super.c:357: warning: Function parameter or member 'm' not
> described in 'ovl_show_options'
> fs/overlayfs/super.c:357: warning: Function parameter or member 'dentry'
> not described in 'ovl_show_options'
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Applied, thanks.

Miklos
