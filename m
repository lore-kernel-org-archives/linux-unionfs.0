Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC99FC2D0E4
	for <linux-unionfs@archiver.kernel.org>; Tue, 24 Nov 2020 11:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 638132076B
	for <linux-unionfs@archiver.kernel.org>; Tue, 24 Nov 2020 11:53:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="k6D884fB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733108AbgKXLw6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 06:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732852AbgKXLw5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Nov 2020 06:52:57 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889D9C0613D6
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Nov 2020 03:52:57 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id u7so10918637vsq.11
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Nov 2020 03:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QYwpUXf9MOd1UXy87SihXPs0Lb5kLuS+SByPITmbzJ4=;
        b=k6D884fBWg+S/eH9wqhr0dJ1XnzXoK4yq0GDnUZGLEqC4fmd+0BAo7DZVsfzDtPRqd
         7oZ9q2dHy7G4z486oytIYVp88b1jx3zZG1jhVFCkWy+v1L/xvE9b9rJKbmckPJ0MiPKR
         VKu/MZEkF/GYxmzUhsoSkMoOKX8olmHJMkAFc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QYwpUXf9MOd1UXy87SihXPs0Lb5kLuS+SByPITmbzJ4=;
        b=KovQvqbOvVipvl05hyYbIBfDKkY2DnmD6ptGNS7wqSjVFfNmjgwjWrP1RYMUAvYWv7
         NQOOumdnHDqapH4qxY1WCSGWwx9fco0jf8+yZ2VK0g9/onTMLLrObjw8DvcKO1xoCtDK
         YPUiiBfzFsI/NfQqtC4zIgpbr2HNBTXfpN+hH7YcQH+UGNAtN9J+ouUgk8ZS5OOrKSpq
         vHHFlPdTPIrUqHJOJ9INNdm176BR85O5ze3leTbtdwqYK5nYSbz4szvJca30C18g6+o5
         dYlDfEyiztviB63JocGKMj++/41IP+TBvvgGdSKCxBqiaT9OTjYkDuxd53WLwm+yWPB1
         t4cQ==
X-Gm-Message-State: AOAM532jBP9C7bNHfJWbRDWjbLLalYbVPY6nAFtVz2Vfwg9j3v8CRV9o
        qcYjIG0lpnggMBOvI3MvEYRa+bTQKHI9dccpoFoyfw==
X-Google-Smtp-Source: ABdhPJwHqp8yckVbn5c3DrIHcZxQcwm+qnD7l8Sy5hsn+ZsG5bM56gagA8ZuwiB1itkaYHpkkPuC5X0x+6lTIhVjBGM=
X-Received: by 2002:a67:ce1a:: with SMTP id s26mr3248965vsl.0.1606218776732;
 Tue, 24 Nov 2020 03:52:56 -0800 (PST)
MIME-Version: 1.0
References: <20201123141207.GC327006@miu.piliscsaba.redhat.com> <20201124115004.GB22619@lst.de>
In-Reply-To: <20201124115004.GB22619@lst.de>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 24 Nov 2020 12:52:45 +0100
Message-ID: <CAJfpegvb7U4wgYpe4KPtayM5kpdjX1SkhrgNLbxaRmm_Tn8noA@mail.gmail.com>
Subject: Re: [RFC PATCH] vfs: fs{set,get}attr iops
To:     Christoph Hellwig <hch@lst.de>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Dmitry Vyukov <dvyukov@google.com>,
        linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Nov 24, 2020 at 12:50 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Looks pretty neat from a quick look, but you probably want to split
> it into a patch or two adding the infrastructure and then one patch
> per file system to ease review and bisection.

Definitely.  Just wanted to get this out to get early feedback.

Thanks,
Miklos
