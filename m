Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55267EE4996
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Aug 2023 15:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjHUPlJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Aug 2023 11:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjHUPlJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Aug 2023 11:41:09 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73061E2
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Aug 2023 08:41:07 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-99bfcf4c814so465643166b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Aug 2023 08:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1692632466; x=1693237266;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Lt58C8wEwprfOJu1EyrAUZpxNMtNliSpKriTNXf3CT8=;
        b=IZoEJqZVyCVLXq2ZDvxBL3u9M3OGMfy17rS8Ba3/CR533f5EH/wG00aOPo2cycKAWl
         Y2Cv12gy0v2kp0Cc4REdIRwVMn4DnUsUlhYYGQRvAsakdjHp2+ZRj5pyuX2AafTj/6kf
         OAScZKHIrZLPIVULGwTPe9Igs45NlGD6YzoC8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692632466; x=1693237266;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lt58C8wEwprfOJu1EyrAUZpxNMtNliSpKriTNXf3CT8=;
        b=EdnwSxe/89vNDC96YMynJUSq/Mk/ZKpA4KX/GuzLNNn9AyX0hybg1JqCPaPXEO1luA
         Mq1R3NMFzBc4OlW6Ch0MwmDlMmcNeW0P0TY9XAGfvjtUnR9llzZ7LFTS/S7SFL0BBy0Q
         2MeBkU86MhOWv3ezBYpZGHIKLzrV320jEasNwomqRbJtdSQqTLhQY+dKXlGfEMfU3iJh
         D1oKs71V9b0lz59CNCV0qxITYt2r6TQg9O90BbnrBb3UDe17jei1tjih5W3u14GiJPgx
         BCs8dGvd/w/nUIKl/ib140x3Sj0hG1Cg3HBMYLom599YfXSka4Sq42i5c6a1i/ehWw1I
         j17A==
X-Gm-Message-State: AOJu0Ywk/NNCAYEoNQpBWRy4N6RJsKvi/vwcUy/D5yqyAC1mxZbzl0yL
        r/StFFTwr1YKoNa7i8MFq0tMBCEO70Mx/iqDv3bgJlYX/z3a52lnEtQ=
X-Google-Smtp-Source: AGHT+IEarPnMUqC93DehynhPOmYxjBR+YRMVHpQxN7n+S8ivPeo7ScBwURjn7rFTROKTxoVIqvBCKhWDvbsju3ZaJis=
X-Received: by 2002:a17:906:738d:b0:99b:e6c3:f6b0 with SMTP id
 f13-20020a170906738d00b0099be6c3f6b0mr6088323ejl.62.1692632465962; Mon, 21
 Aug 2023 08:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1G1uDUhOS0yJdaSKAz-8BkxS++gd29=K7Jr27zZU1wbPQ@mail.gmail.com>
 <CAOQ4uxgAvkrEo=ZOiaY=+HGzVMsk4UCA+D5RfYdEj2Ubffh27Q@mail.gmail.com> <CAL7ro1HskLvD6z5m_yyj6bJvzUdFk=D3jSkfeaKjgBtxCFP+Sw@mail.gmail.com>
In-Reply-To: <CAL7ro1HskLvD6z5m_yyj6bJvzUdFk=D3jSkfeaKjgBtxCFP+Sw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 21 Aug 2023 17:40:54 +0200
Message-ID: <CAJfpegs1QFfcRQ717qzNPnSjz3BfMVy-cOOWSM8=5PUjoFG_Vw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 21 Aug 2023 at 17:31, Alexander Larsson <alexl@redhat.com> wrote:

> So, I guess the end result is that it's probably ok to use an extra
> getxattr here, and that fuse should probably grow an xattr cache.

Having an xattr cache in the page cache would be wonderful, but it's
not how normal filesystems work and I have no idea how to get there.
I should probably talk to Matthew.

Thanks,
Miklos
