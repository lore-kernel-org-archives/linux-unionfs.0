Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28580C7EE2C
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjFFJMx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbjFFJMr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Jun 2023 05:12:47 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3920F10CA
        for <linux-unionfs@vger.kernel.org>; Tue,  6 Jun 2023 02:12:37 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9745c5fed21so707989466b.3
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Jun 2023 02:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686042755; x=1688634755;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cd0puSMqIBnhqCDdBMeqs3uo/UOm2Rr3r287QJHa4os=;
        b=FMOCRrERqzse/IzaoCSnx+eGw2gnoo2gyFcYkWvXtjS7ounh4quaNsB5ecNovlLdpK
         tVBf6h21bygdH0jf0IGZZlVatl+XObh/Rv3/FNXsfJOGfIUgNEp01LkohEUc98TLIZQi
         JKmSAlKiWpeV/cKFcryh2ZRjJH1vmcAzgE1jY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686042755; x=1688634755;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cd0puSMqIBnhqCDdBMeqs3uo/UOm2Rr3r287QJHa4os=;
        b=MSmm4Fpa66hFPprO+ROhqmZ5DYG+vuSfQ1hIt5lu9i4CbMy5fsvSigLJvfGZ3Xe9SB
         PSEsGDhieHPPO4VtxTkIqsi18wyCB+KJ+RaQALLsCHz01hrFE32DChPDL95S9DSDG73t
         xmnpWJOO+KeI+e7uvJHNVVH9owcoci0yJEn54sBgAVqP7s8ixfUrivZph3jo0ATtTCCM
         RgIBtWEEJ3zxdS1cRjYSjbKk0VNUY60yS5Q7v0VNeZDmip169tspuxa2f/nGFw4f8HSC
         MfstGKc74m8w0JrTD6nN+V2Ekv+O3/2RoSLzAwSwY5yI+3wF//OyhmTMa/pj/JbHXoDu
         MwPw==
X-Gm-Message-State: AC+VfDyZA4gbhr+VNmBjkt6QVujQHZspyN6vN2sMbbNrvZcuuy2Iud49
        xSUlp0wqn421157zXI+vCQVhcX028y3DF0Rn6QHK5ERgFffCjY+yBEQ=
X-Google-Smtp-Source: ACHHUZ6p1EVeeLBmJYSALHLxFdOefIDa9KSQ52ngGFmwhYwMAncXcfqmlUy8I7cTs/LosZJfyPCrEqMIm3mFP3+FNXE=
X-Received: by 2002:a17:907:d29:b0:973:ea73:b883 with SMTP id
 gn41-20020a1709070d2900b00973ea73b883mr2490656ejc.66.1686042755597; Tue, 06
 Jun 2023 02:12:35 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000067d24205c4d0e599@google.com>
In-Reply-To: <00000000000067d24205c4d0e599@google.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 6 Jun 2023 11:12:24 +0200
Message-ID: <CAJfpegtzZnzW506AHyw_5Bqn-thhrd3-_t-qJ5OJBzP-z3O6Fg@mail.gmail.com>
Subject: Re: [syzbot] possible deadlock in mnt_want_write (2)
To:     syzbot <syzbot+b42fe626038981fb7bfa@syzkaller.appspotmail.com>
Cc:     syzkaller-bugs@googlegroups.com,
        linux-integrity <linux-integrity@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

#syz set subsystems: intergrity, overlayfs
