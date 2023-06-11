Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E274C7EE23
	for <linux-unionfs@archiver.kernel.org>; Sun, 11 Jun 2023 19:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbjFKTMS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 11 Jun 2023 15:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbjFKTMQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 11 Jun 2023 15:12:16 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFC0E42
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Jun 2023 12:12:15 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-974638ed5c5so743443066b.1
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Jun 2023 12:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686510734; x=1689102734;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=METRwazHca7MV7IOYYjapwpHKqdNnyKS+AA8r4yB2C4=;
        b=e6It/fBrUDYRdXXHufp7sklr7AMAdw5+JbDqfxu/M00mMqIdQh5niw3Vn6zLMCvkSi
         UP9klVtCTw0bEs9XXRWEkU1CX+zEBOqsa3A/BRSBf96H8IsdqOREIgFYgznIGZQSIt5V
         CYPQEtCzRu3fZ6eAWSA4rmvopPfQrVK5p0Suw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686510734; x=1689102734;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=METRwazHca7MV7IOYYjapwpHKqdNnyKS+AA8r4yB2C4=;
        b=C1S+a9yQOsvn+KQWNPYRq/CFAoZEQ6RVsdNzZOyjJ+8Z/Oi3zyJLP3GXGa2ilpfEO7
         C1JC1Oscl8O6WN9KNCCjkGfo/xzS58qzRoCEgLvpl+1adyAqQq9lRpyrD0Sp8YgLQQd7
         PngfnjJCJyrAmANQtdqnWlrZM3KtvUF9WkAyCycT0+SMNTySXoSliznVy7Aj3BQzDa77
         eSldXCK/+sye4/f2xTQZnIAUdsJSQF1fE3djFhdevHRDrKCJwwdXWe0tZtvAo/ZLlyci
         SS7nH+ZRUbVktrkF/jacbN4JmXaQuzINsf2PcgYS/E5LeE1see8U8587GlTQvQCMirsP
         g2tw==
X-Gm-Message-State: AC+VfDwKR5tvPFEEn6gNdPT0NHU+pMDv7tLX4BkSaAfTW5op/VkrKJx/
        z9uzhsHWUcxHAo9UXCLd84HZzNvmsURN313PinMnCg==
X-Google-Smtp-Source: ACHHUZ7RBn/CljbLW3VPdao9L+E7Nxrqg62JEk8gE9vjUE4CPLlWuG+v9V2iO0GEOG2mxYNBVIJNg+jdkxfqovitQfk=
X-Received: by 2002:a17:907:2da1:b0:973:84b0:b077 with SMTP id
 gt33-20020a1709072da100b0097384b0b077mr8095251ejc.33.1686510734088; Sun, 11
 Jun 2023 12:12:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230611132732.1502040-1-amir73il@gmail.com> <CAJfpegugmTqJ5rWycxxeQpVBmGTxSHucnQjP7ZwT3K3jMXNcnA@mail.gmail.com>
 <CAOQ4uxgA9=-gTngiiFjBc5E1M==qP4T0aeiD5608nJxhQuqp+Q@mail.gmail.com> <CAOQ4uxiDL+u3SS-=HsNaHwPLz2CAV=8oDCED5RtzPhmFwQmkZw@mail.gmail.com>
In-Reply-To: <CAOQ4uxiDL+u3SS-=HsNaHwPLz2CAV=8oDCED5RtzPhmFwQmkZw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Sun, 11 Jun 2023 21:12:02 +0200
Message-ID: <CAJfpegu2CAvrqGfACuc+ux4430wwDrSeuXPEeUy0FE=fDrW6FA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Handle notifications on overlayfs fake path files
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, 11 Jun 2023 at 19:52, Amir Goldstein <amir73il@gmail.com> wrote:

> Is it because getting f_real_path() and file_dentry() via d_real()
> is more expensive?
> and caching this information in file_fake container would be
> more efficient?
>
> I will restore the file_fake container and post v3.

I simply dislike the fact that ->d_real() is getting more complex.
I'd prefer d_real to die, which is unfortunately not so easy, as
you've explained.

But if we can make it somewhat less complex (remove the inode
parameter) instead of more complex (add a vfsmount * parameter) then
that's already a big win in my eyes.

Thanks,
Miklos
